import 'dart:io';

import 'package:customerapp/AUTHENTICATION/login.dart';
import 'package:customerapp/CONTROLLER/controller.dart';
import 'package:customerapp/SCREENS/DASHBOARD/dashboard.dart';
import 'package:customerapp/SCREENS/splashscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:phone_state/phone_state.dart';
import 'package:system_alert_window/system_alert_window.dart';

bool isLoggedIn = false;
bool isRegistered = false;
Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  isLoggedIn = await checkLogin();
  // PhoneState status = PhoneState.nothing();
  isRegistered = await checkRegistration();
  await requestPermission();
  await requestcallPermission();
  await requestoverLayPermission();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    // DeviceOrientation.landscapeLeft,
    // DeviceOrientation.landscapeRight,
  ]);

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => Controller()),
      // ChangeNotifierProvider(create: (_) => RegistrationController()),
    ],
    child: const MyApp(),
  ));
  // FlutterNativeSplash.remove();
}

// overlay entry point
// @pragma("vm:entry-point")
// void overlayMain() 
// {
//   WidgetsFlutterBinding.ensureInitialized();
//   runApp(const MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: Material(child: Text("My overlay"))));
// }

checkRegistration() async {
  bool isAuthenticated = false;
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  // prefs.setString("st_uname", "anu");
  // prefs.setString("st_pwd", "anu");
  final cid = prefs.getString("cid");
  if (cid != null) {
    isAuthenticated = true;
  } else {
    isAuthenticated = false;
  }
  return isAuthenticated;
}

checkLogin() async {
  bool isAuthenticated = false;
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  final stUname = prefs.getString("st_uname");
  final stPwd = prefs.getString("st_pwd");

  if (stUname != null && stPwd != null) {
    isAuthenticated = true;
  } else {
    isAuthenticated = false;
  }
  return isAuthenticated;
}

requestcallPermission() async {
  // var sta = await Permission.storage.request();
  var status = await Permission.phone.request();

  if (status.isGranted) {
    await Permission.phone.request();
  } else if (status.isDenied) {
    await Permission.phone.request();
  } else if (status.isRestricted) {
    await Permission.phone.request();
  } else if (status.isPermanentlyDenied) {
    await Permission.phone.request();
  }
}

requestPermission() async {
  var sta = await Permission.storage.request();
  var status = Platform.isIOS
      ? await Permission.photos.request()
      : await Permission.manageExternalStorage.request();
  if (status.isGranted) {
    await Permission.manageExternalStorage.request();
  } else if (status.isDenied) {
    await Permission.manageExternalStorage.request();
  } else if (status.isRestricted) {
    await Permission.manageExternalStorage.request();
  } else if (status.isPermanentlyDenied) {
    await Permission.manageExternalStorage.request();
  }
}

requestoverLayPermission() async {
  var status = SystemAlertWindow.requestPermissions;
  if (status!=true) {
    await SystemAlertWindow.requestPermissions;
  } 
  
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Color.fromARGB(255, 112, 183, 154),
        secondaryHeaderColor: Color.fromARGB(255, 237, 231, 232),
      ),
      debugShowCheckedModeBanner: false,
      home:
          // DashBoardScreen(),
          SplashScreen(),
      //  LoginPage(),
      // Registration(),
      // const HomePage(),
      // CartBag(),
      // MyTextFieldScreen(),
    );
  }
}
