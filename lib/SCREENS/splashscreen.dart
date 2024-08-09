import 'package:customerapp/AUTHENTICATION/login.dart';
import 'package:customerapp/AUTHENTICATION/registration.dart';
import 'package:customerapp/CONTROLLER/controller.dart';
import 'package:customerapp/SCREENS/dashboard.dart';
import 'package:customerapp/SCREENS/db_selection.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:phone_state/phone_state.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isLoggedIn = false;
  bool isRegistered = false;
  
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

  navigate() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? m_db = prefs.getString("multi_db");
    await Future.delayed(Duration(seconds: 3), () async {
      isLoggedIn = await checkLogin();
      isRegistered = await checkRegistration();
      Navigator.push(
          context,
          PageRouteBuilder(
              opaque: false, // set to false
              pageBuilder: (_, __, ___) {
                if (isRegistered) {
                  if (m_db != "1") {
                    Provider.of<Controller>(context, listen: false)
                        .initDb(context, "");
                    return const LoginPage();
                  } else {
                    return const DBSelection();
                  }
                } else {
                  return Registration();
                }
              }));
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // setStream();
    navigate();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      // backgroundColor: Theme.of(context).primaryColor,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Color(0xFFCE1010),
                Color.fromARGB(255, 204, 147, 93),
              ]),
        ),
        child: InkWell(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Center(
              child: Column(
            children: [
              Expanded(
                child: Container(
                  height: 150,
                  width: 150,
                  child: Image.asset(
                    "assets/logo_black_bg.png",
                  ),
                ),
              ),
            ],
          )),
        ),
      ),
    );
  }
}
