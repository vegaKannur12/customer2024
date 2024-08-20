import 'package:customerapp/CONTROLLER/controller.dart';
import 'package:customerapp/SCREENS/DASHBOARD/PENDING/servivepend.dart';
import 'package:customerapp/SCREENS/DIALOGBoxes/incomdilog.dart';
import 'package:customerapp/SCREENS/NEWSERVICE/newservice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:phone_state/phone_state.dart';
import 'package:provider/provider.dart';
import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';

class PENDINGService extends StatefulWidget {
  const PENDINGService({super.key});

  @override
  State<PENDINGService> createState() => _PENDINGServiceState();
}

class _PENDINGServiceState extends State<PENDINGService> {
  String? date;
  PhoneState status = PhoneState.nothing();
  DialogIncoming incomdio = DialogIncoming();
  @override
  void initState() {
    super.initState();
    setStream();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<Controller>(context, listen: false).getPendingList(context);
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
          // Provider.of<Controller>(context, listen: false)
          //     .getIncomingCall(context, mobileNumber);
          // FlutterOverlayWindow.showOverlay(height: 200,width: 200);
          incomdio.showIncomingCallCustomDialog(context);
        }
      }
    });
  }

  TextEditingController seacrh = TextEditingController();
  bool _customTileExpanded = false;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () => _onBackPressed(context),
      child: Stack(
        children: [
          // Image.asset(
          //   // "assets/bk1.jpg",
          //   "assets/grn.jpg",
          //   height: MediaQuery.of(context).size.height,
          //   width: MediaQuery.of(context).size.width,
          //   fit: BoxFit.cover,
          // ),
          Scaffold(
            // backgroundColor: const Color.fromARGB(246, 207, 201, 224),
            backgroundColor: const Color.fromARGB(255, 219, 243, 247),
            // backgroundColor: Colors.black,
            extendBody: true,
            appBar: AppBar(
              // backgroundColor: const Color.fromARGB(255, 114, 84, 153),
              backgroundColor: const Color.fromARGB(255, 31, 164, 187),
              // leading:  Padding(
              //    padding: const EdgeInsets.all(10),
              //   child: SizedBox(width: 100,height: 50,
              //     child: ElevatedButton(
              //           onPressed: () async {

              //           },
              //           style: ElevatedButton.styleFrom(
              //             backgroundColor: Colors.white,
              //             elevation: 2,
              //           ),
              //           child: Padding(
              //             padding: const EdgeInsets.only(top: 12.0, bottom: 12),
              //             child:Text(
              //                     "ADD",
              //                     style: TextStyle(
              //                       fontWeight: FontWeight.bold,
              //                       fontSize: 13,
              //                       color: Colors.black,
              //                     ),
              //                   ),
              //           ),
              //         ),
              //   ),
              // ),
              title: Consumer<Controller>(
                builder:
                    (BuildContext context, Controller value, Widget? child) {
                  return SizedBox(
                    width: 100,
                    height: 40,
                    child: ElevatedButton(
                      onPressed: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddNEWService()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        elevation: 2,
                      ),
                      child: Text(
                        textAlign: TextAlign.center,
                        "ADD SERVICE",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  );
                },
              ),
              // forceMaterialTransparency: true,
              automaticallyImplyLeading: false,
              // backgroundColor: Colors.transparent,
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                              iconSize: 25,
                              onPressed: () {
                                // showIncomingAlert();
                                incomdio.showIncomingCallCustomDialog(context);
                              },
                              icon: Icon(Icons.shape_line)),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(15)),
                        child: Text(
                          "PENDING ( ${value.pendingList_list.length} )",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 17),
                        ),
                      ),
                      Divider(
                        color: Colors.blue,
                      ),
                      value.pendingListLoading
                          ? Expanded(
                              child: Align(
                                alignment: Alignment.center,
                                child: SpinKitCircle(
                                  color: Colors.black,
                                ),
                              ),
                            )
                          : Expanded(
                              child: value.pendingList_list.isEmpty
                                  ? Container(
                                      height: size.height * 0.7,
                                      child: Center(
                                          child: Lottie.asset(
                                              "assets/datano.json",
                                              height: size.height * 0.15)))
                                  : ListView.builder(
                                      itemCount: value.pendingList_list.length,
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: EdgeInsets.only(
                                              top: 7, left: 4, right: 4),
                                          child: InkWell(
                                            onTap: () async {
                                              await Provider.of<Controller>(
                                                      context,
                                                      listen: false)
                                                  .getserviceList(
                                                      context,
                                                      value.pendingList_list[
                                                              index]
                                                              ['SERVICE_ID']
                                                          .toString(),
                                                      value.pendingList_list[
                                                              index]
                                                              ['CUSTOMER_ID']
                                                          .toString());
                                              await Provider.of<Controller>(
                                                      context,
                                                      listen: false)
                                                  .getServiceCustomers(
                                                      context,
                                                      "",
                                                      "",
                                                      value.pendingList_list[
                                                              index]
                                                              ['CUSTOMER_ID']
                                                          .toString());
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        SERvicePendingList(from: "pending",)),
                                              );
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                color: Colors.white,
                                              ),
                                              width: size.width,
                                              // height: 80,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(5),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      value.pendingList_list[
                                                              index]['CUSTOMER']
                                                          .toString(),
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 17),
                                                    ),
                                                    SizedBox(
                                                      height:
                                                          size.height * 0.01,
                                                    ),
                                                    Text(
                                                      value.pendingList_list[
                                                              index]['Req_Name']
                                                          .toString(),
                                                      style: TextStyle(
                                                          color: Colors.red,
                                                          fontSize: 15),
                                                    ),
                                                    SizedBox(
                                                      height:
                                                          size.height * 0.02,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Text(
                                                              "Status : ",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 15),
                                                            ),
                                                            SizedBox(width:size.width/2,
                                                              child: Text(
                                                                value
                                                                    .pendingList_list[
                                                                        index][
                                                                        'SERVICE_STATUS']
                                                                    .toString(),overflow: TextOverflow.ellipsis,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize: 15),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          children: [
                                                            Text(
                                                              "Days : ",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 15),
                                                            ),
                                                            Text(
                                                              // "111",
                                                              value
                                                                  .pendingList_list[
                                                                      index]
                                                                      ['DAYS']
                                                                  .toString(),
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 17),
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
                            )
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

  Future<void> _handleRefresh() async {
    // Simulate network fetch or database query
    await Future.delayed(Duration(seconds: 2));
    // Update the list of items and refresh the UI
    setState(() {
      Provider.of<Controller>(context, listen: false).getPendingList(context);
      print("Table Refreshed----");
      // items = List.generate(20, (index) => "Refreshed Item ${index + 1}");
    });
  }
}
