package com.MarlosTrinidad.fogaca_app;

import android.Manifest;
import android.annotation.SuppressLint;
import android.app.Activity;
import android.app.ActivityManager;
import android.app.AlertDialog;
import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.Service;
import android.content.ComponentName;
import android.content.Context;
import android.content.ContextWrapper;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.content.res.AssetFileDescriptor;
import android.content.res.ColorStateList;
import android.graphics.Color;
import android.graphics.PixelFormat;
import android.location.LocationListener;
import android.location.LocationManager;
import android.media.MediaPlayer;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.os.AsyncTask;
import android.os.Binder;
import android.os.Build;
import android.os.Bundle;
import android.os.CountDownTimer;
import android.os.IBinder;
import android.os.Handler;
import android.os.Looper;
import android.os.PowerManager;
import android.provider.Settings;
import android.text.TextUtils;
import android.util.Log;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.LinearLayout;
import android.widget.PopupWindow;
import android.widget.ProgressBar;
import android.widget.TextView;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.annotation.RequiresApi;
import androidx.core.app.ActivityCompat;
import androidx.core.app.NotificationCompat;

import com.MarlosTrinidad.fogaca_app.model.MotoboyAccount;
import com.firebase.geofire.GeoFire;
import com.firebase.geofire.GeoLocation;
import com.google.android.gms.location.FusedLocationProviderClient;
import com.google.android.gms.location.LocationAvailability;
import com.google.android.gms.location.LocationCallback;
import com.google.android.gms.location.LocationRequest;
import com.google.android.gms.location.LocationResult;
import com.google.android.gms.location.LocationServices;
import com.google.android.gms.location.LocationStatusCodes;
import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.Task;
import com.google.firebase.FirebaseApp;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseUser;
import com.google.firebase.auth.GetTokenResult;
import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;
import com.google.firebase.firestore.DocumentReference;
import com.google.firebase.firestore.DocumentSnapshot;
import com.google.firebase.firestore.EventListener;
import com.google.firebase.firestore.FirebaseFirestore;
import com.google.firebase.firestore.FirebaseFirestoreException;
import com.google.firebase.firestore.ListenerRegistration;
import com.google.firebase.functions.FirebaseFunctions;
import com.google.firebase.messaging.FirebaseMessaging;
import com.google.gson.JsonObject;

import org.json.JSONObject;

import java.io.IOException;
import java.net.DatagramPacket;
import java.net.DatagramSocket;
import java.net.HttpURLConnection;
import java.net.InetSocketAddress;
import java.net.Socket;
import java.net.SocketException;
import java.net.URL;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import static android.content.ContentValues.TAG;
import static android.location.LocationManager.MODE_CHANGED_ACTION;
import static android.location.LocationManager.PROVIDERS_CHANGED_ACTION;

import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class ReceiverService extends Service
        implements MediaPlayer.OnPreparedListener, MediaPlayer.OnCompletionListener {

    IBinder serviceBinder = new ServiceBinder();
    DatagramSocket server;
    Handler hand;
    String SAIU_PARA_ENTREGA = "2";
    String BUSCANDO = "0";
    String CANCELADO = "-1";
    String ACEITO = "1";
    String FINALIZADO = "3";
   // boolean isRelease = BuildConfig.BUILD_TYPE == "release";
    String PEDIDOS = "TestePedidos";
    String MOTOBOYS = "TesteMotoboysOnline";
    String BASE_URL = "http://172.30.192.1:8089/dev";
    String BASE_SOCKET = "http://fogacaexpress.com:8089";


    // http://10.0.0.78:8089
    byte[] receiveData = new byte[4024];
    List<String> quantview = new ArrayList<>();
    List<String> quantview_cancel = new ArrayList<>();
    List<String> Contar_View = new ArrayList<>();
    String Type_notification;
    WindowManager wm;
    WindowManager.LayoutParams lp;
    MediaPlayer mp;
    Toast toast;
    String idToken;
    FirebaseUser user;
    MotoboyAccount account;
    TextView textViewAguarde;
    Button botaoAceitar,botaocancel;
    int StatusCode = 0;
    GeoFire geoFire;
    boolean gps_ativado;
    FusedLocationProviderClient fusedLocation;
    LocationRequest locationRequest;
    private LocationManager locationManager;
    PowerManager powerManager;
    ConnectionSocket connectionSocket;
    boolean powerresult;
    private final FirebaseFirestore db = FirebaseFirestore.getInstance();

    FirebaseFunctions mFunctions;
    LocationListener locationListenerGPS = new LocationListener() {
        @Override
        public void onLocationChanged(android.location.Location location) {
        }

        @Override
        public void onStatusChanged(String provider, int status, Bundle extras) {
            Log.i("AtualizandoEnable1", provider);
            Log.i("AtualizandoEnable1", String.valueOf(status));
            Log.i("AtualizandoEnable1", String.valueOf(extras));
        }

        @Override
        public void onProviderEnabled(String provider) {
            Log.i("AtualizandoEnable", provider);
        }

        @Override
        public void onProviderDisabled(String provider) {
            Log.i("AtualizandoDisable", provider);
            if (provider.equals("gps")) {
                Log.i("AtualizandoDisable", "entrou2");
                moveParaFrente();
                FicarInvisivel();
            }

        }
    };
    LocationCallback locationCallback = new LocationCallback() {
        @Override
        public void onLocationResult(LocationResult locationResult) {
            double latitude = locationResult.getLastLocation().getLatitude();
            double longitude = locationResult.getLastLocation().getLongitude();
            Log.i("Atualizando0", String.valueOf(latitude));
            Log.i("Atualizando0", String.valueOf(longitude));
            geoFire.setLocation(user.getUid(), new GeoLocation(latitude, longitude));
        }

    };



    @Override
    public IBinder onBind(Intent intent) {

        return serviceBinder;
    }

    @SuppressLint("MissingPermission")
    public void startListen() {
        // monitorando se o gps ta ativo


        
        locationManager = (LocationManager) getApplicationContext().getSystemService(Context.LOCATION_SERVICE);
        locationManager.requestLocationUpdates(LocationManager.GPS_PROVIDER,
                2000, 1, locationListenerGPS);

        locationRequest = new LocationRequest();
        locationRequest.setInterval(2000);
        locationRequest.setFastestInterval(4000);
        locationRequest.setPriority(LocationRequest.PRIORITY_HIGH_ACCURACY);

        fusedLocation = LocationServices.getFusedLocationProviderClient(this);
        fusedLocation.requestLocationUpdates(locationRequest, locationCallback, hand.getLooper());

        FirebaseAuth.getInstance().addIdTokenListener(new FirebaseAuth.IdTokenListener() {
            @Override
            public void onIdTokenChanged(@NonNull FirebaseAuth firebaseAuth) {
                if (firebaseAuth.getCurrentUser() == null) {
                    TokenRefresh();
                }
            }
        });
    }
    public void TokenRefresh() {

        user.getIdToken(true)
                .addOnCompleteListener(new OnCompleteListener<GetTokenResult>() {
                    public void onComplete(@NonNull Task<GetTokenResult> task) {
                        if (task.isSuccessful()) {
                            idToken = task.getResult().getToken();
                            Log.d("IdToken", idToken);
                            connectionSocket.setToken(idToken);
                            // Send token to your backend via HTTPS
                            // ...
                        } else {
                            // Handle error -> task.getException();
                        }
                    }
                });
    }

    protected void moveParaFrente() {
        if (Build.VERSION.SDK_INT >= 11) { // honeycomb
            final ActivityManager activityManager = (ActivityManager) getSystemService(Context.ACTIVITY_SERVICE);
            final List<ActivityManager.RunningTaskInfo> recentTasks = activityManager
                    .getRunningTasks(Integer.MAX_VALUE);

            for (int i = 0; i < recentTasks.size(); i++) {
                Log.d("Executed app", "Application executed : "
                        + recentTasks.get(i).baseActivity.toShortString()
                        + "\t\t ID: " + recentTasks.get(i).id + "");
                // bring to front
                if (recentTasks.get(i).baseActivity.toShortString().contains(BuildConfig.APPLICATION_ID)) {
                    activityManager.moveTaskToFront(recentTasks.get(i).id, ActivityManager.MOVE_TASK_WITH_HOME);

                }
            }
        }
    }

    public void VerificarQuantPedido() {
        Log.d("ViewArmazenada", String.valueOf(Contar_View.size()));
        if (Contar_View.size() >= 8) {
            moveParaFrente();
            // onStopCommand();
            FicarInvisivel();
        }
    }

    public void FicarInvisivel() {
        Contar_View.clear();
        new Thread() {
            @Override
            public void run() {
                try {
                    Map<String, Object> map = new HashMap<>();
                    map.put("id", account.getId());

                    StringBuilder postData = new StringBuilder();
                    for (Map.Entry<String, Object> param : map.entrySet()) {
                        if (postData.length() != 0)
                            postData.append('&');
                        postData.append(URLEncoder.encode(param.getKey(), "UTF-8"));
                        postData.append('=');
                        postData.append(URLEncoder.encode(String.valueOf(param.getValue()), "UTF-8"));
                    }
                    byte[] postDataBytes = postData.toString().getBytes(StandardCharsets.UTF_8);

                    Looper.prepare();
                    URL url = new URL(BASE_URL + "/FicarInvisivel");
                    // URL url = new URL("http://10.0.0.78:8089/ficaroffline");
                    HttpURLConnection http = (HttpURLConnection) url.openConnection();
                    http.setRequestMethod("POST");
                    http.setDoOutput(true);
                    http.setRequestProperty("authorization", idToken);
                    http.setRequestProperty("type", "1");
                    http.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
                    http.getOutputStream().write(postDataBytes);
                    http.getOutputStream().flush();

                    StatusCode = http.getResponseCode();
                    Log.e("ERRO INVISIVEL", http.getResponseCode() + "");
                    if (http.getResponseCode() == 200) {
                        showMessage("certo");
                        Log.d("click", "clickando");
                    } else {

                        showMessage("negado");
                    }
                } catch (Exception e) {
                    Log.e("ERROR FIREBASE", e.toString());
                }
            }

            public void showMessage(String message) {
                hand.post(() -> {
                    if (message.equals("certo")) {
                        NotificationManager notificationManager = (NotificationManager) getSystemService(
                                Context.NOTIFICATION_SERVICE);
                        notificationManager.cancelAll();
                        LinearLayout.LayoutParams params = new LinearLayout.LayoutParams(
                                LinearLayout.LayoutParams.MATCH_PARENT,
                                LinearLayout.LayoutParams.WRAP_CONTENT);
                        LayoutInflater vi = (LayoutInflater) getBaseContext()
                                .getSystemService(Context.LAYOUT_INFLATER_SERVICE);
                        LinearLayout lm = (LinearLayout) vi.inflate(R.layout.toast_pedido_expirado,
                                new LinearLayout(getBaseContext()), false);
                        lm.setLayoutParams(params);
                        TextView text = lm.findViewById(R.id.custom_toast_message);
                        text.setText("Você está Offline");

                        Toast toast = new Toast(getApplicationContext());
                        // toast.setGravity(Gravity.CENTER_VERTICAL, 0, 0);
                        toast.setDuration(Toast.LENGTH_SHORT);
                        toast.setView(lm);
                        toast.show();
                    } else if (message.equals("negado")) {
                        NotificationManager notificationManager = (NotificationManager) getSystemService(
                                Context.NOTIFICATION_SERVICE);
                        notificationManager.cancelAll();
                        LinearLayout.LayoutParams params = new LinearLayout.LayoutParams(
                                LinearLayout.LayoutParams.MATCH_PARENT,
                                LinearLayout.LayoutParams.WRAP_CONTENT);
                        LayoutInflater vi = (LayoutInflater) getBaseContext()
                                .getSystemService(Context.LAYOUT_INFLATER_SERVICE);
                        LinearLayout lm = (LinearLayout) vi.inflate(R.layout.toast_pedido_expirado,
                                new LinearLayout(getBaseContext()), false);
                        lm.setLayoutParams(params);
                        TextView text = lm.findViewById(R.id.custom_toast_message);
                        text.setText("Algo Deu errado");

                        Toast toast = new Toast(getApplicationContext());
                        // toast.setGravity(Gravity.CENTER_VERTICAL, 0, 0);
                        toast.setDuration(Toast.LENGTH_SHORT);
                        toast.setView(lm);
                        toast.show();
                    }

                });
            }
        }.start();
    }

    @Override
    public void onCreate() {
        super.onCreate();
        FirebaseApp.initializeApp(getBaseContext());
        mFunctions = FirebaseFunctions.getInstance();



        DatabaseReference ref = FirebaseDatabase.getInstance().getReference(MOTOBOYS);
        geoFire = new GeoFire(ref);

        hand = new Handler(getMainLooper());

        // OuvirLoc();
        startListen();

        if (FirebaseAuth.getInstance().getCurrentUser() != null) {
            user = FirebaseAuth.getInstance().getCurrentUser();

            final DocumentReference docRef = db.collection("user_motoboy").document(user.getUid());
            docRef.addSnapshotListener(new EventListener<DocumentSnapshot>() {
                @Override
                public void onEvent(@Nullable DocumentSnapshot snapshot,
                        @Nullable FirebaseFirestoreException e) {
                    if (e != null) {
                        Log.w(TAG, "Listen failed.", e);
                        return;
                    }

                    if (snapshot != null && snapshot.exists()) {
                        account = snapshot.toObject(MotoboyAccount.class);
                        Log.i("123Atualizando:::::::", "Current data: " + account.getPermissao());
                        if (!account.getPermissao()) {
                            onStopCommand();
                        }
                        Log.i("123Atualizando:::::::", "Current data: " + snapshot.getData());
                    } else {
                        geoFire.removeLocation(user.getUid());
                        Log.d(TAG, "Current data: null");
                    }
                }
            });
        }

        mp = new MediaPlayer();
        wm = (WindowManager) getBaseContext().getSystemService(WINDOW_SERVICE);
        lp = new WindowManager.LayoutParams(WindowManager.LayoutParams.MATCH_PARENT,
                WindowManager.LayoutParams.WRAP_CONTENT);
        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.O) {
            lp.type = WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY;
        } else {
            lp.type = WindowManager.LayoutParams.TYPE_SYSTEM_ALERT;
        }
        lp.format = PixelFormat.TRANSPARENT;
        lp.flags = WindowManager.LayoutParams.FLAG_LAYOUT_IN_SCREEN;

        lp.gravity = Gravity.CENTER;

        new Thread() {
            @Override
            public void run() {
                super.run();

                try {

                    if (server == null) {
                        server = new DatagramSocket(null);
                        server.setReuseAddress(true);
                        server.setBroadcast(true);
                        server.bind(new InetSocketAddress(3306));
                    }

                    while (true) {

                        DatagramPacket packet = new DatagramPacket(receiveData, receiveData.length);

                        try {
                            server.receive(packet);
                            String data = new String(packet.getData(), StandardCharsets.UTF_8);
                            JSONObject json = new JSONObject(data);

                            Type_notification = (json.getString("click_action"));

                            Log.d("TIPOANIMAL:::::", Type_notification);
                            if(Type_notification.equals("request")){
                                createView(json);
                            }else{
                                Log.d("TIPOANIMAL:::::", "moveParaFrente");
                                cancelView(json);
                            }


                            VerificarQuantPedido();

                        } catch (Exception e) {
                            e.printStackTrace();
                        }

                    }

                } catch (SocketException e) {
                    e.printStackTrace();

                }
            }
        }.start();

    }
    public void cancelView(JSONObject json) {

        TokenRefresh();
        try {
            String id_doc = (json.getString("id_doc"));
            Log.d("TIPOANIMAL", id_doc);
            Log.d("TIPOANIMAL", json.getString("nome_ponto"));
            quantview.add(id_doc);
            TextView nome_lojista;
            ProgressBar progress_time;
            LinearLayout.LayoutParams params = new LinearLayout.LayoutParams(
                    LinearLayout.LayoutParams.MATCH_PARENT,
                    LinearLayout.LayoutParams.WRAP_CONTENT);
            LayoutInflater vi = (LayoutInflater)
                    getBaseContext().getSystemService(Context.LAYOUT_INFLATER_SERVICE);
            LinearLayout cm = (LinearLayout) vi.inflate(R.layout.activity_main_cancel,
                    new LinearLayout(getBaseContext()), false);
            cm.setLayoutParams(params);

            progress_time = cm.findViewById(R.id.progress_time_cancel);
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                progress_time.setProgressTintList(ColorStateList.valueOf(Color.RED));
            }
            nome_lojista = cm.findViewById(R.id.nome_loja_cancel);
            nome_lojista.setText(json.getString("nome_ponto"));

            final int[] progress = { 100 };
            new Thread() {
                @Override
                public void run() {
                    Looper.prepare();
                    while (progress[0] > 0) {
                        try {
                            Thread.sleep(70);
                        } catch (Exception e) {
                        }
                        progress[0] -= 1;
                        hand.post(() -> {
                            progress_time.setProgress(progress[0]);
                        });

                    }
                }
            }.start();

            hand.post(() -> {

                wm.addView(cm, lp);
                // listen(id_doc,lm);
                playSong();

            });

            hand.postDelayed(() -> {
                try {
                   wm.removeView(cm);
                } catch (Exception e) {

                }
                try {
                    quantview.remove(id_doc);
                    if (quantview.size() == 0) {
                        mp.stop();
                        mp.reset();
                    }
                } catch (Exception e) {

                }

            }, 7000);

        } catch (Exception e) {
            Log.d("layout", e.getMessage());
        }

    }
    public void createView(JSONObject json) {

        TokenRefresh();
        try {
            String id_doc = (json.getString("id_doc"));
            quantview.add(id_doc);
            Contar_View.add(id_doc);
            Log.d("TIPOANIMAL::::::", String.valueOf(quantview.size()));
            Log.d("TIPOANIMAL::::::", id_doc);
            TextView nome_lojista, rua_lojista, num_lojista, bairro_lojista, quant_itens, distancia;
            ProgressBar progress_time;
            LinearLayout.LayoutParams params = new LinearLayout.LayoutParams(
                    LinearLayout.LayoutParams.MATCH_PARENT,
                    LinearLayout.LayoutParams.WRAP_CONTENT);
            LayoutInflater vi = (LayoutInflater) getBaseContext().getSystemService(Context.LAYOUT_INFLATER_SERVICE);
            LinearLayout lm = (LinearLayout) vi.inflate(R.layout.activity_main_alert,
                    new LinearLayout(getBaseContext()), false);
            lm.setLayoutParams(params);

            String rua_numero;
            String km;
            String quant_entregas;

            progress_time = lm.findViewById(R.id.progress_time);
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                progress_time.setProgressTintList(ColorStateList.valueOf(Color.RED));
            }
            nome_lojista = lm.findViewById(R.id.nome_loja);
            rua_lojista = lm.findViewById(R.id.rua_loja_numero);
            bairro_lojista = lm.findViewById(R.id.bairro_loja);
            distancia = lm.findViewById(R.id.distancia);
            quant_itens = lm.findViewById(R.id.quantitens_loja);

            botaoAceitar = lm.findViewById(R.id.button_aceitar);
            nome_lojista.setText(json.getString("nome_ponto"));
            km = json.getString("distancia") + " km";
            quant_entregas = json.getString("quant_itens") + " entrega";
            rua_numero = json.getString("rua_ponto") + "," + json.getString("num_ponto");
            rua_lojista.setText(rua_numero);
            bairro_lojista.setText(json.getString("bairro_ponto"));
            quant_itens.setText(quant_entregas);
            distancia.setText(km);
            botaoAceitar.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    Contar_View.clear();
                    quantview.remove(id_doc);
                    aceitarCorrida(lm, id_doc);
                }
            });
            lm.findViewById(R.id.button_negar).setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {

                    quantview.remove(id_doc);
                    fecharDialogo(lm);
                }
            });
            final int[] progress = { 100 };
            new Thread() {
                @Override
                public void run() {
                    Looper.prepare();
                    while (progress[0] > 0) {
                        try {
                            Thread.sleep(100);
                        } catch (Exception e) {
                        }
                        progress[0] -= 1;
                        hand.post(() -> {
                            progress_time.setProgress(progress[0]);
                        });

                    }
                }
            }.start();

            hand.post(() -> {

                wm.addView(lm, lp);
                // listen(id_doc,lm);
                playSong();

            });

            hand.postDelayed(() -> {
                try {
                    wm.removeView(lm);
                } catch (Exception e) {

                }
                try {
                    quantview.remove(id_doc);
                    if (quantview.size() == 0) {
                        mp.stop();
                        mp.reset();
                    }
                } catch (Exception e) {

                }

            }, 10000);

        } catch (Exception e) {
            Log.d("layout", e.getMessage());
        }

    }

    public void playSong() {
        Log.d("viewCriada PlaySong", String.valueOf(quantview.size()));
        try {
            if(Type_notification.equals("request")){
                AssetFileDescriptor song = getResources().getAssets().openFd("somsino.mp3");
                mp.setDataSource(song.getFileDescriptor(), song.getStartOffset(), song.getLength());
                mp.setLooping(true);
                mp.setOnPreparedListener(this);
                mp.setOnCompletionListener(this);
                mp.prepareAsync();
            }else{
                AssetFileDescriptor song = getResources().getAssets().openFd("cancel.mp3");
                mp.setDataSource(song.getFileDescriptor(), song.getStartOffset(), song.getLength());
                mp.setLooping(true);
                mp.setOnPreparedListener(this);
                mp.setOnCompletionListener(this);
                mp.prepareAsync();
            }


        } catch (Exception e) {

            System.out.println("ErrorSong " + e.getMessage());
        }
    }

    @RequiresApi(api = Build.VERSION_CODES.O)
    private void startMyOwnForeground() {
        String NOTIFICATION_CHANNEL_ID = BuildConfig.APPLICATION_ID;
        String channelName = "Motoboy Online";
        NotificationChannel chan = new NotificationChannel(NOTIFICATION_CHANNEL_ID, channelName,
                NotificationManager.IMPORTANCE_NONE);
        chan.setLightColor(Color.BLUE);
        chan.setLockscreenVisibility(Notification.VISIBILITY_PRIVATE);
        NotificationManager manager = (NotificationManager) getSystemService(Context.NOTIFICATION_SERVICE);
        assert manager != null;
        manager.createNotificationChannel(chan);

        if (android.os.Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            NotificationCompat.Builder notificationBuilder = new NotificationCompat.Builder(this,
                    NOTIFICATION_CHANNEL_ID);
            Notification notification = notificationBuilder.setOngoing(true)
                    .setSmallIcon(R.drawable.ic_notification)
                    .setColor(getResources().getColor(R.color.pretoclaro))
                    .setContentTitle("Voçê está online")
                    .setPriority(NotificationManager.IMPORTANCE_MIN)
                    .setCategory(Notification.CATEGORY_SERVICE)
                    .build();
            startForeground(2, notification);
        } else {
            NotificationCompat.Builder notificationBuilder = new NotificationCompat.Builder(this,
                    NOTIFICATION_CHANNEL_ID);
            Notification notification = notificationBuilder.setOngoing(true)
                    .setSmallIcon(R.drawable.ic_notification)
                    .setContentTitle("Voçê está online")
                    .setPriority(NotificationManager.IMPORTANCE_MIN)
                    .setCategory(Notification.CATEGORY_SERVICE)
                    .build();
            startForeground(2, notification);

        }

    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {

        if (connectionSocket == null && intent != null && intent.getExtras() != null) {
            String uid = intent.getExtras().getString("uid");
            String token = intent.getExtras().getString("token");
            connectionSocket = new ConnectionSocket(token, this, uid);
            connectionSocket.start();
        }

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O)
            startMyOwnForeground();
        else
            startForeground(1, new Notification());

        TokenRefresh();
        return START_STICKY;

    }

    public void onStopCommand() {
        Contar_View.clear();
        Intent intent = new Intent(getApplicationContext(), ReceiverService.class);
        stopService(intent);
        if(connectionSocket!=null){
            connectionSocket.destroy();
            connectionSocket = null;
        }

    }

    @Override
    public void onDestroy() {
        stopPlaying();
        try {
            FirebaseMessaging.getInstance().unsubscribeFromTopic("pending_order");
            fusedLocation.removeLocationUpdates(locationCallback);
            geoFire.removeLocation(user.getUid());
            connectionSocket.destroy();

        } catch (Exception e) {
        }
        super.onDestroy();

    }

    public void fecharDialogo(View lm) {
        try {
            if (lm != null) {
                if (lm.isShown()) {
                    wm.removeView(lm);
                    if (quantview.size() == 0) {
                        mp.stop();
                        mp.reset();
                    }

                }

            }
        } catch (Exception e) {
            System.out.println("Error " + e.getMessage());
            Log.d("layout", e.getMessage());
        }

    }

    public void aceitarCorrida(View lm, String doc) {
        // Verificando se tem net
        Button button = lm.findViewById(R.id.button_aceitar);
        ConnectivityManager cm = (ConnectivityManager) ReceiverService.this.getBaseContext()
                .getSystemService(Context.CONNECTIVITY_SERVICE);
        NetworkInfo activeNetwork = cm.getActiveNetworkInfo();
        boolean isConnected = activeNetwork != null && activeNetwork.isConnectedOrConnecting();

        // caso tenha ele deixa passar
        if (isConnected) {

            button.setText("Aguarde...");
            button.setBackgroundColor(Color.GRAY);
            button.setOnClickListener(null);
            try {
                Map<String, Object> map = new HashMap<>();
                map.put("motoboy", account.getId());
                map.put("pedido", doc);
                StringBuilder postData = new StringBuilder();
                for (Map.Entry<String, Object> param : map.entrySet()) {
                    if (postData.length() != 0)
                        postData.append('&');
                    postData.append(URLEncoder.encode(param.getKey(), "UTF-8"));
                    postData.append('=');
                    postData.append(URLEncoder.encode(String.valueOf(param.getValue()), "UTF-8"));
                }
                byte[] postDataBytes = postData.toString().getBytes(StandardCharsets.UTF_8);

                new Thread() {
                    @Override
                    public void run() {
                        try {
                            Looper.prepare();
                            URL url = new URL(BASE_URL + "/accept");
                            HttpURLConnection http = (HttpURLConnection) url.openConnection();
                            http.setRequestMethod("POST");
                            http.setDoOutput(true);
                            http.setRequestProperty("authorization", idToken);
                            http.setRequestProperty("type", "1");
                            http.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
                            http.getOutputStream().write(postDataBytes);
                            http.getOutputStream().flush();

                            StatusCode = http.getResponseCode();

                            if (http.getResponseCode() == 200) {

                                button.setBackgroundColor(Color.GREEN);
                                button.setText("ACEITO");

                                Log.d("click", "clickando");
                            } else if(http.getResponseCode() == 398) {
                                button.setBackgroundColor(Color.RED);
                                button.setText("PEGARAM");

                            }else if(http.getResponseCode() == 399) {
                                button.setBackgroundColor(Color.RED);
                                button.setText("CANCELADO");

                            }else{
                                button.setBackgroundColor(Color.RED);
                                button.setText("NEGADO");
                            }
                            hand.postDelayed(() -> {
                                fecharDialogo(lm);
                            }, 1500);

                        } catch (Exception e) {
                            Log.e("ERROR FIREBASE", e.toString());
                        }
                    }


                }.start();

            } catch (Exception e) {
                Toast.makeText(getBaseContext(), "Não foi possível aceitar a corrida", Toast.LENGTH_SHORT).show();
            }

        } else {
            button.setBackgroundColor(Color.YELLOW);
            button.setText("PROBLEMA INTERNET");

        }
    }

    @Override
    public void onPrepared(MediaPlayer mp) {

        mp.start();
    }

    @Override
    public void onCompletion(MediaPlayer mp) {
        mp.release();
    }

    private void stopPlaying() {
        if (mp != null) {
            mp.stop();
            mp.release();
            mp = null;
        }
    }

    class ServiceBinder extends Binder{
        public ReceiverService getService(){
            return ReceiverService.this;
        }
        public ConnectionSocket getSocket(){
            return connectionSocket;
        }
    }
}
