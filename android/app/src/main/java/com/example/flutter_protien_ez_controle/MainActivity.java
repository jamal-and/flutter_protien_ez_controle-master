package com.example.flutter_protien_ez_controle;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin;
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin.NativeAdFactory;

public class MainActivity extends FlutterActivity {
    @Override
    public void configureFlutterEngine(FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        final NativeAdFactory factory = new NativeAdFactoryExample(getLayoutInflater());
        final NativeAdFactory factory4 = new NativeAdFactoryExample2(getLayoutInflater());
        final NativeAdFactory factory2 = new AnotherNativeAdFactoryExample(getLayoutInflater());
        final NativeAdFactory factory3 = new AnotherNativeAdFactoryExample2(getLayoutInflater());
        GoogleMobileAdsPlugin.registerNativeAdFactory(flutterEngine, "adFactoryExample", factory);
        GoogleMobileAdsPlugin.registerNativeAdFactory(flutterEngine, "adFactoryExample2", factory2);
        GoogleMobileAdsPlugin.registerNativeAdFactory(flutterEngine, "adFactoryExample3", factory3);
        GoogleMobileAdsPlugin.registerNativeAdFactory(flutterEngine, "adFactoryExample4", factory4);
    }

    @Override
    public void cleanUpFlutterEngine(FlutterEngine flutterEngine) {
        GoogleMobileAdsPlugin.unregisterNativeAdFactory(flutterEngine, "adFactoryExample");
        GoogleMobileAdsPlugin.unregisterNativeAdFactory(flutterEngine, "adFactoryExample2");
        GoogleMobileAdsPlugin.unregisterNativeAdFactory(flutterEngine, "adFactoryExample3");
        GoogleMobileAdsPlugin.unregisterNativeAdFactory(flutterEngine, "adFactoryExample4");
    }
}