import 'dart:convert';
import 'dart:io';

import 'package:customerapp/AUTHENTICATION/login.dart';
import 'package:customerapp/AUTHENTICATION/registration.dart';
import 'package:customerapp/COMPONENTS/c_errorDialog.dart';
import 'package:customerapp/COMPONENTS/custom_snackbar.dart';
import 'package:customerapp/COMPONENTS/external_dir.dart';
import 'package:customerapp/COMPONENTS/network_connectivity.dart';
import 'package:customerapp/MODELS/reg_model.dart';
import 'package:customerapp/SCREENS/db_selection.dart';
import 'package:customerapp/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sql_conn/sql_conn.dart';

class Controller extends ChangeNotifier {
  //for postreg
  String? fp;
  String? cid;
  ExternalDir externalDir = ExternalDir();
  List<CD> c_d = [];
  String? sof;
  bool isLoading = false;
  String? appType;
  String? os;
  String? cname;
  ////////
  bool isdbLoading = true;
  List<Map<String, dynamic>> db_list = [];
  bool isYearSelectLoading = false;
  bool isLoginLoading = false;
  List<Map<String, dynamic>> logList = [];
  String? selectedSmName;
  Map<String, dynamic>? selectedItemStaff;
  bool isDBLoading = false;
  /////////////////////////////////////
  bool isCustLoading = false;
  List<Map<String, dynamic>> customerList = [];
  List<Map<String, dynamic>> incomingCustomer = [];
  Future<RegistrationData?> postRegistration(
      String companyCode,
      String? fingerprints,
      String phoneno,
      String deviceinfo,
      BuildContext context) async {
    NetConnection.networkConnection(context).then((value) async {
      print("Text fp...$fingerprints---$companyCode---$phoneno---$deviceinfo");
      // ignore: prefer_is_empty
      if (companyCode.length >= 0) {
        appType = companyCode.substring(10, 12);
      }
      if (value == true) {
        try {
          Uri url =
              Uri.parse("https://trafiqerp.in/order/fj/get_registration.php");
          Map body = {
            'company_code': companyCode,
            'fcode': fingerprints,
            'deviceinfo': deviceinfo,
            'phoneno': phoneno
          };
          // ignore: avoid_print
          print("register body----$body");
          isLoading = true;
          notifyListeners();
          http.Response response = await http.post(
            url,
            body: body,
          );
          // print("body $body");
          var map = jsonDecode(response.body);
          // ignore: avoid_print
          print("regsiter map----$map");
          RegistrationData regModel = RegistrationData.fromJson(map);

          sof = regModel.sof;
          fp = regModel.fp;
          String? msg = regModel.msg;

          if (sof == "1") {
            if (appType == 'UY')
            // if (appType == 'ED')
            {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              /////////////// insert into local db /////////////////////
              String? fp1 = regModel.fp;
              if (map["os"] == null || map["os"].isEmpty) {
                isLoading = false;
                notifyListeners();
                CustomSnackbar snackbar = CustomSnackbar();
                snackbar.showSnackbar(context, "Series is Missing", "");
              } else {
                // ignore: avoid_print
                print("fingerprint......$fp1");
                prefs.setString("fp", fp!);

                cid = regModel.cid;
                os = regModel.os;
                prefs.setString("cid", cid!);

                cname = regModel.c_d![0].cnme;

                prefs.setString("cname", cname!);
                prefs.setString("os", os!);
                print("cid----cname-----$cid---$cname....$os");
                notifyListeners();
                await externalDir.fileWrite(fp1!);

                // ignore: duplicate_ignore
                for (var item in regModel.c_d!) {
                  print("ciddddddddd......$item");
                  c_d.add(item);
                }
                // verifyRegistration(context, "");
                isLoading = false;
                notifyListeners();
                prefs.setString("user_type", appType!);
                prefs.setString("db_name", map["mssql_arr"][0]["db_name"]);
                prefs.setString("old_db_name", map["mssql_arr"][0]["db_name"]);
                prefs.setString("ip", map["mssql_arr"][0]["ip"]);
                prefs.setString("port", map["mssql_arr"][0]["port"]);
                prefs.setString("usern", map["mssql_arr"][0]["username"]);
                prefs.setString("pass_w", map["mssql_arr"][0]["password"]);
                prefs.setString("multi_db", map["mssql_arr"][0]["multi_db"]);

                String? user = prefs.getString("userType");
                await VEGACUS.instance
                    .deleteFromTableCommonQuery("companyRegistrationTable", "");
                // ignore: use_build_context_synchronously
                String? m_db = prefs.getString("multi_db");
                if (m_db != "1") {
                  print("dont want year select");
                  await initDb(context, "from login");
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => LoginPage()), //m_db=0
                  );
                } else {
                  print("want year select");
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DBSelection()),
                  );
                }
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => DBSelection()),
                // );
              }
            } else {
              CustomSnackbar snackbar = CustomSnackbar();
              // ignore: use_build_context_synchronously
              snackbar.showSnackbar(context, "Invalid Apk Key", "");
            }
          }
          /////////////////////////////////////////////////////
          if (sof == "0") {
            CustomSnackbar snackbar = CustomSnackbar();
            // ignore: use_build_context_synchronously
            snackbar.showSnackbar(context, msg.toString(), "");
          }

          notifyListeners();
        } on SocketException catch (e) {
          // regLoad = false;
          notifyListeners();
          if (e.osError != null && e.osError!.errorCode == 110) {
            await showCommonErrorDialog(
                'Connection timed out. Please try again..',
                Registration(),
                context);
          } else {
            // print("SocketException");
            // ignore: use_build_context_synchronously
            await showCommonErrorDialog(
                'SocketException: ${e.message}', Registration(), context);
          }
        } catch (e) {
          // ignore: avoid_print
          // regLoad = false;
          await showCommonErrorDialog(
              'An unexpected error occurred: ${e.toString()}',
              Registration(),
              context);
          // return null;
        }
      }
    });
    return null;
  }

  getLogin(BuildContext context) async {
    try {
      isLoginLoading = true;
      notifyListeners();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? os = prefs.getString("os");

      // print("unaaaaaaaaaaammmeeeeeeeee$userName");
      String oo = "Kot_Login_Info '$os'";
      print("loginnnnnnnnnnnnnnn$oo");
      //  print("{Flt_Sp_Verify_User '$os','$userName','$password'}");
      // initDb(context, "from login");
      // initYearsDb(context, "");
      var res = await SqlConn.readData("Kot_Login_Info '$os'");
      var valueMap = json.decode(res);
      print("login details----------$res");
      if (valueMap != null) {
        // LoginModel logModel = LoginModel.fromJson(valueMap);
        for (var item in valueMap) {
          logList.add(item);
          notifyListeners();
        }
        print("LogList----$logList");
      }
      isLoginLoading = false;
      notifyListeners();
    } on PlatformException catch (e) {
      debugPrint("PlatformException Table: ${e.message}");
      debugPrint("not connected..Table..");
      // Navigator.pop(context);
      showConnectionDialog(context, "LOG", e.toString());
    } catch (e) {
      print("An unexpected error occurred: $e");
      // SqlConn.disconnect();
    }
  }

  verifyStaff(String pwd, BuildContext context) {
    print("pwd , selpwd ====$pwd ,${selectedItemStaff!['PWD']}");
    if (pwd == selectedItemStaff!['PWD'].toString().trim()) {
      return 1;
    } else {
      return 0;
    }
  }

  ////////////////////////////////////////////////////////
  getDatabasename(BuildContext context, String type) async {
    isdbLoading = true;
    notifyListeners();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? db = prefs.getString("db_name");
    String? cid = await prefs.getString("cid");
    await initDb(context, "");
    print("cid dbname---------$cid---$db");
    try {
      var res = await SqlConn.readData("Flt_LoadYears '$db','$cid'");
      var map = jsonDecode(res);
      db_list.clear();
      if (map != null) {
        for (var item in map) {
          db_list.add(item);
        }
      }
      print("years res-$res");
      print("tyyyyyyyyyp--------$type");
      isdbLoading = false;
      notifyListeners();
    } catch (e) {
      debugPrint("not connected..db  select..");
      debugPrint(e.toString());
      Navigator.pop(context);
      await showConnectionDialog(context, "DB", e.toString());

      //   showDialog(
      //   context: context,
      //   builder: (context) {
      //     return AlertDialog(
      //       title: Text("Connection Failed"),
      //       content: Text("Failed to connect to the database. Please check your settings and try again."),
      //       actions: [
      //         TextButton(
      //           onPressed: () {
      //             Navigator.of(context).pop();
      //           },
      //           child: Text("OK"),
      //         ),
      //       ],
      //     );
      //   },
      // );
    } finally {
      // Navigator.pop(context);
    }
    // SqlConn.disconnect();
    // print("disconnected--------$db");
    // if (db_list.length > 1) {
    //   if (type == "from login") {
    //     Navigator.push(
    //       context,
    //       MaterialPageRoute(builder: (context) => DBSelection()),
    //     );
    //   }
    // } else {
    //   Navigator.push(
    //     context,
    //     MaterialPageRoute(builder: (context) => HomePage()),
    //   );
    // }
  }

/////////////////////////////////////////////////////////////////////////////
  initYearsDb(
    BuildContext context,
    String type,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? ip = prefs.getString("ip");
    String? port = prefs.getString("port");
    String? un = prefs.getString("usern");
    String? pw = prefs.getString("pass_w");
    String? db = prefs.getString("db_name");
    String? multi_db = prefs.getString("multi_db");

    debugPrint("Connecting selected DB...$db----");
    debugPrint("Connecting ...$ip---$port----$un----$pw-");
    try {
      isYearSelectLoading = true;
      notifyListeners();
      // await SqlConn.disconnect();
      showDialog(
        context: context,
        builder: (context) {
          // Navigator.push(
          //   context,
          //   new MaterialPageRoute(builder: (context) => HomePage()),
          // );
          // Future.delayed(Duration(seconds: 5), () {
          //   Navigator.of(mycontxt).pop(true);
          // });
          return AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Please wait",
                  style: TextStyle(fontSize: 13),
                ),
                SpinKitCircle(
                  color: Colors.green,
                )
              ],
            ),
          );
        },
      );
      // if (multi_db == "1") {
      await SqlConn.connect(
          ip: ip!,
          port: port!,
          databaseName: db!,
          username: un!,
          password: pw!);
      // }
      debugPrint("Connected selected DB!----$ip------$db");
      // getDatabasename(context, type);
      Navigator.pop(context);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      // yr = prefs.getString("yr_name");
      // dbn = prefs.getString("db_name");
      // cName = prefs.getString("cname");
      isYearSelectLoading = false;
      notifyListeners();
      // prefs.setString("db_name", dbn.toString());
      // prefs.setString("yr_name", yrnam.toString());
      // getDbName();
      // getBranches(context);
      if (type == "DB") {
        await getDatabasename(context, "");
      } else if (type == "INDB") {
        await initDb(context, "");
      } else if (type == "INYR") {
        await initYearsDb(context, "");
      } else if (type == "LOG") {
        await getLogin(context);
      } else if (type == "CUS") {
        // await getServiceCustomers(context,"","","","");
      } else {}
    } on PlatformException catch (e) {
      debugPrint(e.toString());
      debugPrint("not connected..init-YRDB..");
      Navigator.pop(context);
      await showConnectionDialog(context, "INYR", e.toString());
    } catch (e) {
      print("An unexpected error occurred: $e");
      // SqlConn.disconnect();
      // return [];
    }
  }

//////////////////////////////////////////////////////////
  initDb(BuildContext context, String type) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? db = prefs.getString("old_db_name");
    String? ip = prefs.getString("ip");
    String? port = prefs.getString("port");
    String? un = prefs.getString("usern");
    String? pw = prefs.getString("pass_w");
    debugPrint("Connecting...initDB..$db");
    try {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Please wait",
                  style: TextStyle(fontSize: 13),
                ),
                SpinKitCircle(
                  color: Colors.green,
                )
              ],
            ),
          );
        },
      );
      await SqlConn.connect(
          ip: ip!, port: port!, databaseName: db!, username: un!, password: pw!
          // ip:"192.168.18.37",
          // port: "1433",
          // databaseName: "epulze",
          // username: "sa",
          // password: "1"

          );
      debugPrint("Connected!");
      Navigator.pop(context);
      // getDatabasename(context, type);
    } catch (e) {
      debugPrint(e.toString());
      debugPrint("not connected..initDB..");
      Navigator.pop(context);
      await showINITConnectionDialog(context, "INDB", e.toString());

      //   showDialog(
      //   context: context,
      //   builder: (context) {
      //     return AlertDialog(
      //       title: Text("Connection Failed"),
      //       content: Text("Failed to connect to the database. Please check your settings and try again."),
      //       actions: [
      //         TextButton(
      //           onPressed: () {
      //             Navigator.of(context).pop();
      //           },
      //           child: Text("OK"),
      //         ),
      //       ],
      //     );
      //   },
      // );
    } finally {
      // Navigator.pop(context);
    }
  }

////////////////////////////
  updateSm_id() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("Sm_id", selectedItemStaff!['Sm_id']);
    notifyListeners();
  }

  getServiceCustomers(BuildContext context, String? code) async {
    isCustLoading = true;
    notifyListeners();
    try {
      print("Flt_Ser_getcustomer '$code'");
      var res = await SqlConn.readData("Flt_Ser_getcustomer '$code'");
      // [{"H_CODE":"C@107", "H_NAME":"AAMI KANNUR", "H_ADDRESS":"", "H_PLACE":"KANNUR", "H_MOBILE":"", "STATUS":"PAID SERVICE", "EXPIRY":"2023-01-01 00:00:00.0", "EXP_DAYS":-585, "SERIES":"VEGA"}, {"H_CODE":"C@108", "H_NAME":"AAMI WEDDING EDAKARA", "H_ADDRESS":"EDAKARA", "H_PLACE":"NILAMBUR", "H_MOBILE":"", "STATUS":"PAID SERVICE", "EXPIRY":"2023-01-01 00:00:00.0", "EXP_DAYS":-585, "SERIES":"VEGA"}, {"H_CODE":"C@109", "H_NAME":"AAMI WEDDING VANDOOR", "H_ADDRESS":"VANDOOR", "H_PLACE":"NILAMBUR", "H_MOBILE":"", "STATUS":"WARRANTY", "EXPIRY":"2024-10-31 00:00:00.0", "EXP_DAYS":84, "SERIES":"VEGA"}];

//       [{"H_CODE":"C@431", "H_NAME":"J J AGENCIES-ERNAKULAM", "H_ADDRESS":"11155, MOOKANOOR,AZHAKATVI ", "H_PLACE":"ERANAKULAM", "H_MOBILE":"",
// "STATUS":"WARRANTY", "EXPIRY":"2025-06-01 00:00:00.000", "EXP_DAYS":297, "SERIES":"SIJOSH"},];

      print(res.runtimeType);
      var map = jsonDecode(res);
      customerList.clear();
      if (map != null) 
      {
        for (var item in map) {
          customerList.add(item);
        }
      }
      // customerList = [
      //   {
      //     "H_CODE": "C@106",
      //     "H_NAME": "AADHYA AGENCIES THALASSERY",
      //     "H_ADDRESS": "near -ym tradelink",
      //     "H_PLACE": "THALASSERY",
      //     "H_MOBILE": 9747731558,
      //     "STATUS": "PAID SERVICE",
      //     "EXPIRY": "2023-01-01 00:00:00.0",
      //     "EXP_DAYS": -585,
      //     "SERIES": "VEGA"
      //   },
      //   {
      //     "H_CODE": "C@107",
      //     "H_NAME": "AAMI KANNUR",
      //     "H_ADDRESS": "",
      //     "H_PLACE": "KANNUR",
      //     "H_MOBILE": "9061155841",
      //     "STATUS": "PAID SERVICE",
      //     "EXPIRY": "2023-01-01 00:00:00.0",
      //     "EXP_DAYS": -585,
      //     "SERIES": "VEGA"
      //   },
      //   {
      //     "H_CODE": "C@108",
      //     "H_NAME": "AAMI WEDDING EDAKARA",
      //     "H_ADDRESS": "EDAKARA",
      //     "H_PLACE": "NILAMBUR",
      //     "H_MOBILE": "",
      //     "STATUS": "PAID SERVICE",
      //     "EXPIRY": "2023-01-01 00:00:00.0",
      //     "EXP_DAYS": -585,
      //     "SERIES": "VEGA"
      //   },
      //   {
      //     "H_CODE": "C@113",
      //     "H_NAME": "ABABI ",
      //     "H_ADDRESS": "KINFRA PARK ,TLY",
      //     "H_PLACE": "THALASSERY",
      //     "H_MOBILE": "",
      //     "STATUS": "PAID SERVICE",
      //     "EXPIRY": "2023-01-01 00:00:00.0",
      //     "EXP_DAYS": -585,
      //     "SERIES": "SIJOSH"
      //   },
      // ];
      print("customerList---$res");

      isCustLoading = false;
      notifyListeners();
    } on PlatformException catch (e) {
      debugPrint("PlatformException customerList: ${e.message}");
      debugPrint("not connected..customerList..");
      debugPrint(e.toString());
      // Navigator.pop(context);
      await showConnectionDialog(context, "CUS", e.toString());
    } catch (e) {
      print("An unexpected error occurred: $e");
      // SqlConn.disconnect();
      return [];
    }
  }

  getIncomingCall(BuildContext context, String? ph) async {
    isCustLoading = true;
    notifyListeners();
    try {
      print("getIncoming Call");
      print("Flt_Ser_getcustomer '$ph'");
      var res = await SqlConn.readData("Flt_Ser_getcustomer '$ph'");
      print(res.runtimeType);
      var map = jsonDecode(res);
      incomingCustomer.clear();
      if (map != null) {
        for (var item in map) {
          incomingCustomer.add(item);
        }
      }
      // incomingCustomer = [
      //   {
      //     "H_CODE": "C@107",
      //     "H_NAME": "AAMI KANNUR",
      //     "H_ADDRESS": "",
      //     "H_PLACE": "KANNUR",
      //     "H_MOBILE": "9061155841",
      //     "STATUS": "PAID SERVICE",
      //     "EXPIRY": "2023-01-01 00:00:00.0",
      //     "EXP_DAYS": -585,
      //     "SERIES": "VEGA"
      //   },
        //  {
        //   "H_CODE": "C@107",
        //   "H_NAME": "AAMI KANNUR",
        //   "H_ADDRESS": "",
        //   "H_PLACE": "KANNUR",
        //   "H_MOBILE": "9061155841",
        //   "STATUS": "PAID SERVICE",
        //   "EXPIRY": "2023-01-01 00:00:00.0",
        //   "EXP_DAYS": -585,
        //   "SERIES": "VEGA"
        // }
      // ];
      print("Incoming Customer---$res");

      isCustLoading = false;
      notifyListeners();
    } on PlatformException catch (e) {
      debugPrint("PlatformException customerList: ${e.message}");
      debugPrint("not connected..customerList..");
      debugPrint(e.toString());
      await showConnectionDialog(context, "INCOM", e.toString());
    } catch (e) {
      print("An unexpected error occurred: $e");

      return [];
    }
  }

  Future<void> showConnectionDialog(
      BuildContext context, String from, String er) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Not Connected.!",
                style: TextStyle(fontSize: 13),
              ),
              SpinKitCircle(
                color: Colors.green,
              ),
            ],
          ),
          actions: [
            InkWell(
              child: Text('Connect'),
              onLongPress: () async {
                await showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content: Text(er),
                      );
                    });
              },
              onTap: () async {
                await initYearsDb(context, from);
                Navigator.of(context).pop();
              },
            )
            // TextButton(
            //   onPressed: () async {
            //     await initYearsDb(context, from);
            //     Navigator.of(context).pop();
            //   },
            //   child: Text('Connect'),
            // ),
          ],
        );
      },
    );
  }

  ///////////////////////////////////////////////
  Future<void> showINITConnectionDialog(
      BuildContext context, String from, String er) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Not Connected..!",
                style: TextStyle(fontSize: 13),
              ),
              SpinKitCircle(
                color: Colors.green,
              ),
            ],
          ),
          actions: [
            InkWell(
              child: Text('Connect'),
              onLongPress: () async {
                TextEditingController dbc = TextEditingController();
                TextEditingController ipc = TextEditingController();
                TextEditingController usrc = TextEditingController();
                TextEditingController portc = TextEditingController();
                TextEditingController pwdc = TextEditingController();
                bool pressed = false;
                SharedPreferences prefs = await SharedPreferences.getInstance();
                String? db = prefs.getString("db_name");
                String? ip = prefs.getString("ip");
                String? port = prefs.getString("port");
                String? un = prefs.getString("usern");
                String? pw = prefs.getString("pass_w");
                await showDialog(
                    context: context,
                    builder: (context) {
                      return StatefulBuilder(
                        builder: (BuildContext context,
                                void Function(void Function()) setState) =>
                            AlertDialog(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                  onLongPress: () async {
                                    await showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            content: Text(er),
                                          );
                                        });
                                  },
                                  child: Icon(
                                    Icons.error_outline,
                                    color: Colors.redAccent,
                                  )),
                              IconButton(
                                  style: ButtonStyle(),
                                  onPressed: () {
                                    Navigator.of(context, rootNavigator: true)
                                        .pop(false);
                                  },
                                  icon: Icon(Icons.close))
                            ],
                          ),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('DB Deatails'),
                              SizedBox(
                                height: 15,
                              ),
                              Row(
                                children: [
                                  SizedBox(width: 90, child: Text("DB")),
                                  pressed
                                      ? SizedBox(
                                          width: 150,
                                          child: TextFormField(
                                            controller: dbc,
                                          ))
                                      : Text(" :  ${db.toString()}")
                                ],
                              ),
                              Row(
                                children: [
                                  SizedBox(width: 90, child: Text("IP")),
                                  pressed
                                      ? SizedBox(
                                          width: 140,
                                          child: TextFormField(
                                            controller: ipc,
                                          ))
                                      : Text(" :  ${ip.toString()}")
                                ],
                              ),
                              Row(
                                children: [
                                  SizedBox(width: 90, child: Text("PORT")),
                                  pressed
                                      ? SizedBox(
                                          width: 150,
                                          child: TextFormField(
                                            controller: portc,
                                          ))
                                      : Text(" :  ${port.toString()}")
                                ],
                              ),
                              Row(
                                children: [
                                  SizedBox(width: 90, child: Text("USERNAME")),
                                  pressed
                                      ? SizedBox(
                                          width: 150,
                                          child: TextFormField(
                                            controller: usrc,
                                          ))
                                      : Text(" :  ${un.toString()}")
                                ],
                              ),
                              Row(
                                children: [
                                  SizedBox(width: 90, child: Text("PASSWORD")),
                                  pressed
                                      ? SizedBox(
                                          width: 150,
                                          child: TextFormField(
                                            controller: pwdc,
                                          ))
                                      : Text(" :  ${pw.toString()}")
                                ],
                              )
                            ],
                          ),
                          actions: <Widget>[
                            IconButton(
                                onPressed: () {
                                  setState(() {
                                    pressed = true;
                                  });

                                  dbc.text = db.toString();
                                  ipc.text = ip.toString();
                                  portc.text = port.toString();
                                  usrc.text = un.toString();
                                  pwdc.text = pw.toString();
                                  print("pressed---$pressed");
                                },
                                icon: Icon(Icons.edit)),
                            TextButton(
                              onPressed: () {
                                prefs.setString(
                                    "old_db_name", dbc.text.toString());
                                prefs.setString("db_name", dbc.text.toString());
                                prefs.setString("ip", ipc.text.toString());
                                prefs.setString("port", portc.text.toString());
                                prefs.setString("usern", usrc.text.toString());
                                prefs.setString("pass_w", pwdc.text.toString());
                                // setState(() {});
                                Navigator.of(context, rootNavigator: true).pop(
                                    false); // dismisses only the dialog and returns false
                              },
                              child: Text('UPDATE'),
                            ),
                          ],
                        ),
                      );
                    });
              },
              onTap: () async {
                await initDb(context, "");
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }
}
