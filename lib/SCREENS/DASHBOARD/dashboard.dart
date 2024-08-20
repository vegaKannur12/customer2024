import 'package:customerapp/CONTROLLER/controller.dart';
import 'package:customerapp/SCREENS/DASHBOARD/PENDING/pending.dart';
import 'package:customerapp/SCREENS/DIALOGBoxes/incomdilog.dart';
import 'package:customerapp/SCREENS/NEWSERVICE/newservice.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:phone_state/phone_state.dart';
import 'package:provider/provider.dart';
import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({super.key});

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  String? date;
  PhoneState status = PhoneState.nothing();
  DialogIncoming incomdio = DialogIncoming();
  @override
  void initState() {
    super.initState();
    setStream();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Provider.of<Controller>(context, listen: false)
      //     .getServiceCustomers(context, "");
    });
    date = DateFormat('dd-MMM-yyyy').format(DateTime.now());
  }

  void setStream() {
    // Size size = MediaQuery.of(context).size;
    print("settttt------");
    PhoneState.stream.listen((event) async {
      setState(() {
        status = event;
      });
      if (event.status == PhoneStateStatus.CALL_INCOMING
          // ||
          //     event.status == PhoneStateStatus.CALL_STARTED
          ) {
        String date = DateFormat('dd-MMM-yyyy').format(DateTime.now());
        print('Incoming number: ${event.number}, $date');

        if (event.number != "null" &&
            event.number != " " &&
            event.number != "NULL" &&
            event.number != "") {
          String mobileNumber =
              event.number!.substring(event.number!.length - 10);
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString("ph", mobileNumber);
          Provider.of<Controller>(context, listen: false)
              .getIncomingCall(context, mobileNumber);
          // FlutterOverlayWindow.showOverlay(height: 200,width: 200);
          incomdio.showIncomingCallCustomDialog(context);
        }
      }
    });
  }

  TextEditingController seacrh = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () => _onBackPressed(context),
      child: Stack(
        children: [
          Image.asset(
            // "assets/bk1.jpg",
            "assets/grn.jpg",
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            // backgroundColor: Colors.black,
            extendBody: true,
            appBar: AppBar(
              // title: Center(child: Text("Customer List",style: TextStyle(color: Colors.white),)),
              // SizedBox(
              //   height: 40,
              //   width: 150,
              //   child: Image.asset(
              //     "assets/logo_black_bg.png",
              //     fit: BoxFit.fitHeight,
              //   ),
              // ),
              forceMaterialTransparency: true,
              automaticallyImplyLeading: false,
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              // backgroundColor: Colors.yellow,
              actions: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    date.toString(),
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ),
                )
                // IconButton(
                //     onPressed: () {
                //       // showIncomingAlert();
                //       showIncomingCallCustomDialog(context);
                //     },
                //     icon: Icon(Icons.shape_line))
              ],
            ),
            body: RefreshIndicator(
              onRefresh: _handleRefresh,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Consumer<Controller>(
                  builder: (context, value, child) => Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 15, left: 15, right: 15),
                        child: InkWell(
                          onTap: () async {
                            await Provider.of<Controller>(context,
                                    listen: false)
                                .getPendingList(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PENDINGService()),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(21),
                              color: Colors.white,
                            ),
                            width: size.width,
                            height: 120,
                            child: Center(
                              child: Text(
                                "PENDING",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 23),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 15, left: 15, right: 15),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(21),
                            color: Colors.white,
                          ),
                          width: size.width,
                          height: 120,
                          child: Center(
                            child: Text(
                              "ALL PENDING",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 23),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 15, left: 15, right: 15),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddNEWService()),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(21),
                              color: Colors.white,
                            ),
                            width: size.width,
                            height: 120,
                            child: Center(
                              child: Text(
                                "NEW SERVICE",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 23),
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Expanded(
                      //   child: ListView.builder(
                      //       itemCount: 3,
                      //       shrinkWrap: true,
                      //       itemBuilder: (context, index) {
                      //         return Padding(
                      //           padding: EdgeInsets.only(
                      //               top: 30, left: 15, right: 15),
                      //           child: Container(
                      //             decoration: BoxDecoration(
                      //               borderRadius: BorderRadius.circular(21),
                      //               color: Colors.white,
                      //             ),
                      //             width: size.width,
                      //             height: 100,
                      //             child: Center(child: Text("data"),),
                      //           ),
                      //         );
                      //       }),
                      // )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleRefresh() async {
    // Simulate network fetch or database query
    await Future.delayed(Duration(seconds: 2));
    // Update the list of items and refresh the UI
    setState(() {
      Provider.of<Controller>(context, listen: false)
          .getServiceCustomers(context, "", "", "");
      print("Table Refreshed----");
      // items = List.generate(20, (index) => "Refreshed Item ${index + 1}");
    });
  }

  Future<bool> _onBackPressed(BuildContext context) async {
    return await showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          // title: const Text('AlertDialog Title'),
          content: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: ListBody(
              children: const <Widget>[
                Text(
                  'Want to exit from this app ?',
                  style: TextStyle(color: Colors.white, fontSize: 17),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'No',
                style: TextStyle(color: Colors.white54),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: const Text(
                'Yes',
                style: TextStyle(color: Colors.white54),
              ),
              onPressed: () {
                exit(0);
              },
            ),
          ],
        );
      },
    );
  }
}
