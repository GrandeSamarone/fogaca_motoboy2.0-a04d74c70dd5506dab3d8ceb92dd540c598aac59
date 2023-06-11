package com.MarlosTrinidad.fogaca_app;


import android.app.ActivityManager;
import android.content.ComponentName;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.ServiceConnection;
import android.location.LocationManager;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.os.IBinder;
import android.os.PowerManager;
import android.provider.Settings;
import android.util.Log;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.appcompat.app.AlertDialog;

import com.MarlosTrinidad.fogaca_app.events.LocalSocketEvent;
import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.Task;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseAuthException;
import com.google.firebase.auth.GetTokenResult;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {
    ReceiverService receiverService;
    boolean hasBind = false;
    LocalSocketEvent socketEvent;


    @Override
    protected void onDestroy() {
        super.onDestroy();

        if(hasBind)
        unbindService(connection);
    }

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        socketEvent = new LocalSocketEvent(getFlutterEngine());

    }



    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {

        super.configureFlutterEngine(flutterEngine);


        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(),"motoboy")
                .setMethodCallHandler(new MethodChannel.MethodCallHandler() {
                    @Override
                    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {

                        if(call.method.equals("startService")){
                            Intent intent = new Intent(getContext(), ReceiverService.class);
                            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                                if(!Settings.canDrawOverlays(getApplicationContext())) {
                                     Intent intentOverlay = new Intent(Settings.ACTION_MANAGE_OVERLAY_PERMISSION,
                                      Uri.parse("package:" + getPackageName()));
                                  startActivityForResult(intentOverlay, 200);

                                }else{

                                    FirebaseAuth.getInstance().getCurrentUser().getIdToken(true)
                                            .addOnCompleteListener(new OnCompleteListener<GetTokenResult>() {
                                        @Override
                                        public void onComplete(@NonNull Task<GetTokenResult> task) {
                                            if (task.isSuccessful()) {
                                                intent.putExtra("uid", FirebaseAuth.getInstance().getUid());
                                                intent.putExtra("token", task.getResult().getToken());
                                                startService(intent);
                                                bindService(intent, connection, 0);
                                            } else {
                                                Toast.makeText(getApplicationContext(), "Não foi possível ficar online, tente novamente!", Toast.LENGTH_LONG).show();

                                            }
                                        }
                                    });

                                }
                            }


                        }else if(call.method.equals("stopService")){
                          
                            try{
                                Intent intent = new Intent(getContext(), ReceiverService.class);
                                if(hasBind)
                                unbindService(connection);
                                stopService(intent);

                            }catch (Exception e){

                            }

                        }else if(call.method.equals("checkOverlay")){
                            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                                if(!Settings.canDrawOverlays(getApplicationContext())) {
                                    result.success(false);

                                    Log.i("canDrawOverlays::","false");
                                }else {
                                    result.success(true);
                                    Log.i("canDrawOverlays::","true");
                            }
                            }
                        }else if(call.method.equals("ativarOverlay")){
                            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                                    Intent intent = new Intent(Settings.ACTION_MANAGE_OVERLAY_PERMISSION,
                                            Uri.parse("package:" + getPackageName()));
                                    startActivityForResult(intent, 200);

                                    Log.i("canDrawOverlays::","false");

                            }
                        }else if(call.method.equals("serviceStatus")){

                                ActivityManager manager = (ActivityManager) getSystemService(ACTIVITY_SERVICE);
                                for (ActivityManager.RunningServiceInfo service : manager.getRunningServices(Integer.MAX_VALUE))
                                {
                                    if (ReceiverService.class.getName().equals(service.service.getClassName()))
                                    {
                                        result.success(true);
                                        if(!hasBind) {
                                            Intent intent = new Intent(getContext(), ReceiverService.class);
                                            bindService(intent, connection, 0);
                                        }
                                        return;
                                    }
                                }

                                result.success(false);

                        }
                    }
                });
    }
    public int isPowerSaveModeHuaweiXiaomi(){
        if (Build.MANUFACTURER.equalsIgnoreCase("Xiaomi")) {
            try {

                return  android.provider.Settings.System.getInt(getContext().getContentResolver(), "POWER_SAVE_MODE_OPEN");

            } catch (Settings.SettingNotFoundException e) {
                Log.d("Valor modo bateria:", "Error");
            }
        }else if (Build.MANUFACTURER.equalsIgnoreCase("Huawei")){
            try {
                return android.provider.Settings.System.getInt(getContext().getContentResolver(), "SmartModeStatus");

            } catch (Settings.SettingNotFoundException e) {
                Log.d("Valor modo bateria:", "Error");
            }
        }
        return 0;
    }

    private ServiceConnection connection = new ServiceConnection() {

        @Override
        public void onServiceConnected(ComponentName className,
                                       IBinder service) {
            // We've bound to LocalService, cast the IBinder and get LocalService instance
            ReceiverService.ServiceBinder binder = (ReceiverService.ServiceBinder) service;
            receiverService = binder.getService();
            hasBind = true;


            Log.i("SOCKET", "BINDING");
            binder.getSocket().setListenerEvent(socketEvent);
        }

        @Override
        public void onServiceDisconnected(ComponentName arg0) {
            hasBind = false;
            Log.i("SOCKET", "UNBINDING");
        }
    };
}
