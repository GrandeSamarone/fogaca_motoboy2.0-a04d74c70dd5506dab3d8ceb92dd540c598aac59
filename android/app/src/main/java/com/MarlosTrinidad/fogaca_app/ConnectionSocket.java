package com.MarlosTrinidad.fogaca_app;

import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.Handler;
import android.os.Looper;
import android.util.Log;

import androidx.annotation.NonNull;

import com.MarlosTrinidad.fogaca_app.events.LocalSocketEvent;
import com.google.firebase.auth.FirebaseAuth;

import java.net.URISyntaxException;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.EventChannel;
import io.socket.client.IO;
import io.socket.client.Manager;
import io.socket.client.Socket;
import io.socket.emitter.Emitter;
import io.socket.engineio.client.Transport;
import okhttp3.Request;

public class ConnectionSocket {
    String token;
    Socket mSocket;
    ReceiverService service;
    String uid;
    Handler hand;

    LocalSocketEvent localSocketEvent;

    int countErrors = 0;
    ConnectionSocket(String token, ReceiverService service, String uid){
        this.service = service;
        this.uid = uid;
        this.token = token;


        hand = new Handler();


    }

    public void start(){
        try {

            
            Map<String, String> headers = new HashMap<>();
            headers.put("authorization", token);
            headers.put("uid",uid);
            IO.Options options = new IO.Options();

            options.path = "/socket";

            options.auth = headers;
            options.query = "";
            Map<String, List<String>> mHeaders = new HashMap<>();
            mHeaders.put("Authorization", Arrays.asList(token));
            mHeaders.put("type", Arrays.asList("1"));

            options.extraHeaders = mHeaders;
            mSocket = IO.socket(service.BASE_SOCKET, options);

            mSocket.on(Socket.EVENT_CONNECT, new Emitter.Listener() {
                @Override
                public void call(Object... args) {
                    hand.post(new Runnable() {
                        @Override
                        public void run() {
                            //if(localSocketEvent != null)localSocketEvent.send(true);
                            Log.i("SOCKET","CONNECTED");
                        }
                    });

                }
            });
            mSocket.on(Socket.EVENT_DISCONNECT, new Emitter.Listener() {
                @Override
                public void call(Object... args) {

                    hand.post(new Runnable() {
                        @Override
                        public void run() {
                            if(localSocketEvent != null)localSocketEvent.send(false);
                            Log.i("SOCKET","DISCONNECTED");
                        }
                    });

                }
            });
            mSocket.on(Socket.EVENT_CONNECT_ERROR, new Emitter.Listener() {
                @Override
                public void call(Object... args) {

                    hand.post(new Runnable() {
                        @Override
                        public void run() {
                            if(localSocketEvent != null)localSocketEvent.send(false);
                            Log.i("SOCKET","DISCONNECTED");
                        }
                    });

                }
            });



            mSocket.on("auth", new Emitter.Listener() {
                @Override
                public void call(Object... args) {

                    hand.post(new Runnable() {
                        @Override
                        public void run() {
                            if(localSocketEvent != null)localSocketEvent.send(true);
                            Log.i("SOCKET","ATHENTICATED");
                        }
                    });

                }
            });

            mSocket.on("error", new Emitter.Listener() {
                @Override
                public void call(Object... args) {

                    service.stopSelf();
                    Log.e("DISCONNECT REASON", args[0].toString());
                }
            });

            mSocket.on("auth-error", new Emitter.Listener() {
                @Override
                public void call(Object... args) {
                    countErrors++;
                    mSocket.disconnect();
                    mSocket.close();
                    if(countErrors <= 3) {
                        Looper.prepare();
                        hand.postDelayed(new Runnable() {
                            @Override
                            public void run() {
                                start();
                            }
                        },3000);


                    }else service.stopSelf();
                    Log.e("DISCONNECT REASON", args[0].toString());
                }
            });

            mSocket.connect();


        } catch (URISyntaxException e) {
            service.stopSelf();
        }
    }




    public void setToken(String token){
        this.token = token;
    }

    public void destroy(){
        localSocketEvent.send(false);
        if(mSocket != null){
            mSocket.disconnect();
            mSocket.close();
        }
    }

    public void setListenerEvent(LocalSocketEvent socketEvent) {
        this.localSocketEvent = socketEvent;
        socketEvent.send(mSocket.connected());
    }
}
