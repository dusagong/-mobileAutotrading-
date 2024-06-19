import 'dart:async';
import 'dart:ui';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:trade_app/API/Kor/api.dart';

void startBackgroundService() {
  final service = FlutterBackgroundService();
  service.startService();

}

void stopBackgroundService() {
  final service = FlutterBackgroundService();
  service.invoke("stop");
}

Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  await service.configure(
    iosConfiguration: IosConfiguration(
      autoStart: true,
      onForeground: onStart,
      onBackground: onIosBackground,
    ),
    androidConfiguration: AndroidConfiguration(
      autoStart: true,
      onStart: onStart,
      isForegroundMode: false,
      autoStartOnBoot: true,
    ),
  );

}

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();

  return true;
}


@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  // Ensure Dart plugins are registered
  DartPluginRegistrant.ensureInitialized();


  // Example: Periodically send HTTP requests or perform other tasks
  Timer.periodic(const Duration(seconds: 10), (timer) async {
    
    if(await StartCheck()){
      String accessToken = await getAccessToken() ?? '';
      algorithm(accessToken);
    }
    // Perform other periodic tasks
    print("Service is running at ${DateTime.now()}");

    if (service is AndroidServiceInstance && !(await service.isForegroundService())) {
      service.setForegroundNotificationInfo(
        title: "Background Service",
        content: "Running in background",
      );
    }
  });

  // Listen for stop event
  service.on("stop").listen((event) {
    service.stopSelf();
    debugPrint("Background process is now stopped");
  });

  service.on("start").listen((event) {
    // Handle start event
  });
}