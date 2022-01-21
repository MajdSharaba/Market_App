package com.sy.ams.market_app;

import android.os.Bundle;
import io.flutter.embedding.android.FlutterFragmentActivity;
import io.flutter.plugins.flutter_plugin_android_lifecycle.FlutterAndroidLifecyclePlugin;
//import io.flutter.plugins.localauth.LocalAuthPlugin;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.PluginRegistry.PluginRegistrantCallback;
import io.flutter.plugins.GeneratedPluginRegistrant;



public class MainActivity extends FlutterFragmentActivity implements PluginRegistrantCallback{

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

//        LocalAuthPlugin.registerWith(registrarFor("io.flutter.plugins.localauth.LocalAuthPlugin"));
    }

    @Override
    public void registerWith(PluginRegistry registry) {
        FlutterAndroidLifecyclePlugin.registerWith(
                registry.registrarFor(
                        "io.flutter.plugins.flutter_plugin_android_lifecycle.FlutterAndroidLifecyclePlugin"));
    }
}
