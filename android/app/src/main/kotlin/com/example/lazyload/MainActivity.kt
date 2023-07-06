package com.example.lazyload
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant
import com.yandex.mapkit.MapKitFactory

class MainActivity: FlutterActivity() {
  override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
      MapKitFactory.setApiKey("ebd11aaf-aa28-4518-9f15-f243f4e9cb18") // Your generated API key
      super.configureFlutterEngine(flutterEngine)
  }
}
