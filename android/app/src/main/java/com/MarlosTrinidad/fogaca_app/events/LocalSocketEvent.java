package com.MarlosTrinidad.fogaca_app.events;

import android.util.Log;

import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.EventChannel;

public class LocalSocketEvent {

    EventChannel.EventSink sink;

    public LocalSocketEvent(FlutterEngine engine){
        new EventChannel(engine.getDartExecutor().getBinaryMessenger(),"event").setStreamHandler(new EventChannel.StreamHandler() {
            @Override
            public void onListen(Object arguments, EventChannel.EventSink events) {
                Log.i("SOCKET", "LISTENING");
                sink = events;

            }

            @Override
            public void onCancel(Object arguments) {
                Log.i("SOCKET", "LISTENING CANCEL");
                sink = null;
            }
        });
    }

    public void send(Object object){
        if(sink != null){
            sink.success(object);
        }
    }
}
