import 'package:customerapp/CONTROLLER/controller.dart';
import 'package:customerapp/SCREENS/DIALOGBoxes/incomdilog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
   bool _customTileExpanded = false;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(
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
            title: Consumer<Controller>(
              builder: (BuildContext context, Controller value, Widget? child) {
                return Center(
                    child: Column(
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      "Pending ( ${value.pendingList_list.length} )",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    Divider()
                  ],
                ));
              },
            ),
            forceMaterialTransparency: true,
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            // backgroundColor: Colors.yellow,
            actions: [
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
                    Expanded(
                      child: ListView.builder(
                          itemCount: value.pendingList_list.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            // Provider.of<Controller>(context, listen: false)
                            //     .getServiceCustomers(
                            //         context,
                            //         "",
                            //         "",
                            //         value.pendingList_list[index]['CUSTOMER_ID']
                            //             .toString());
                            return ExpansionTile(  backgroundColor: Colors.white,
                              collapsedBackgroundColor: Colors.white,
                              title:  Text(value.pendingList_list[index]['CUSTOMER']
                                    .toString(),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),),
                              subtitle:
                                   Text(value.pendingList_list[index]
                                      ['Req_Name']
                                  .toString()),
                              trailing: Icon(
                                _customTileExpanded
                                    ? Icons.arrow_drop_down_circle
                                    : Icons.arrow_drop_down,
                              ),
                              children: const <Widget>[
                                ListTile(title: Text('This is tile number 2')),
                              ],
                              onExpansionChanged: (bool expanded) {
                                setState(() {
                                    Provider.of<Controller>(context, listen: false)
                                .getServiceCustomers(
                                    context,
                                    "",
                                    "",
                                    value.pendingList_list[index]['CUSTOMER_ID']
                                        .toString());
                                  _customTileExpanded = expanded;
                                });
                              },
                            );
                            // ExpansionTile(
                            //   backgroundColor: Colors.white,
                            //   collapsedBackgroundColor: Colors.white,
                            //   title: Text(
                            //     value.pendingList_list[index]['CUSTOMER']
                            //         .toString(),
                            //     style: TextStyle(
                            //       fontWeight: FontWeight.bold,
                            //     ),
                            //   ),
                            //   subtitle: Text(value.pendingList_list[index]
                            //           ['Req_Name']
                            //       .toString()),
                            //   children: <Widget>[
                            //     ListTile(title: Text('This is tile number 1')),
                            //   ],
                            // );
                            // Padding(
                            //   padding:
                            //       EdgeInsets.only(top: 30, left: 15, right: 15),
                            //   child: Container(
                            //     decoration: BoxDecoration(
                            //       // borderRadius: BorderRadius.circular(21),
                            //       color: Colors.white,
                            //     ),
                            //     width: size.width,
                            //     height: 80,
                            //     child: Center(
                            //       child: Text(value.pendingList_list[index]
                            //               ['CUSTOMER']
                            //           .toString()),
                            //     ),
                            //   ),
                            // );
                          }),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
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
