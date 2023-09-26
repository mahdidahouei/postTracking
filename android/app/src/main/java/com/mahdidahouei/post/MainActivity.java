package com.mahdidahouei.post;

import android.content.Intent;

import androidx.annotation.NonNull;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "post.mahdidahouei.com/tracking";

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler(
                        (call, result) -> {
                            // This method is invoked on the main thread.
                            if (call.method.equals("openVpnSettings")) {
                                openVpnSettings();
                                ;
                            } else {
                                result.notImplemented();
                            }
                        }
                );
    }

    public void openVpnSettings() {
        Intent intent = new Intent("android.net.vpn.SETTINGS");
        intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        startActivity(intent);
    }
}
