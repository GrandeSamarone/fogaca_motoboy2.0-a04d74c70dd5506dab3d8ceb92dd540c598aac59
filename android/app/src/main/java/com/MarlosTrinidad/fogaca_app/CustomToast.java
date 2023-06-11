package com.MarlosTrinidad.fogaca_app;

import android.app.Activity;
import android.content.Context;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;
import android.widget.Toast;

import com.MarlosTrinidad.fogaca_app.R;

public class CustomToast {
    Context context;



    public static void showToastMessage(Context context, String message){

        LayoutInflater inflater = ((Activity) context).getLayoutInflater();

        View layout = inflater.inflate(R.layout.toast_pedido_aceito,
                (ViewGroup) ((Activity) context).findViewById(R.id.custom_toast_layout));
        // set a message
        TextView text = (TextView) layout.findViewById(R.id.custom_toast_message);
        text.setText(message);

        // Toast...
        Toast toast = new Toast(context);
        toast.setGravity(Gravity.CENTER_VERTICAL, 0, 0);
        toast.setDuration(Toast.LENGTH_LONG);
        toast.setView(layout);
        toast.show();
    }
    }