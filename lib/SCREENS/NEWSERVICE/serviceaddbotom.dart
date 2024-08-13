import 'package:customerapp/CONTROLLER/controller.dart';
import 'package:customerapp/SCREENS/DASHBOARD/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ServiceADDBottomSheet {
  // String? selected;
  ValueNotifier<bool> visible = ValueNotifier(false);
  TextEditingController note = TextEditingController();
  TextEditingController called = TextEditingController();

  showServiceADDMoadlBottomsheet(
    List<Map<String, dynamic>> list,
    BuildContext context,
    Size size,
    int index,

    // TextEditingController dec_ctrl,
    String? date,
    String from,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cusnm = prefs.getString("h_name");

    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          print("param---$index--");
          if (from=="incoming") {
            String? ph = prefs.getString("ph");
            print("ph=====$ph");
            called.text=ph.toString();
          }
          return Consumer<Controller>(
            builder: (context, value, child) {
              return SingleChildScrollView(
                child: Container(
                  // height: size.height * 0.96,
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                    ),
                    child: value.isLoading
                        ? SpinKitFadingCircle(color: Colors.black)
                        : Column(
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      icon: Icon(Icons.close,
                                          color: Colors.black)),
                                ],
                              ),
                              Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          cusnm
                                              .toString()
                                              .trimLeft()
                                              .toUpperCase(),
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                       padding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          list[index]["Req_Name"]
                                              .toString()
                                              .trimLeft()
                                              .toUpperCase(),
                                          style: TextStyle(
                                            fontSize:18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20, right: 20),
                                    child: Divider(
                                      thickness: 2,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 6, horizontal: 5),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: size.width / 1.1,
                                          child: TextFormField(
                                            controller: note,
                                            decoration: InputDecoration(
                                              hintText: "Note...",
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 6, horizontal: 5),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: size.width / 1.1,
                                          child: TextFormField(
                                            controller: called,
                                            decoration: InputDecoration(
                                              hintText: "Called By",
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 6, horizontal: 5),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                            width: size.width / 1.1,
                                            child: ElevatedButton(
                                              onPressed: () async {
                                                await Provider.of<Controller>(
                                                        context,
                                                        listen: false)
                                                    .saveService(
                                                        context,
                                                        date.toString(),
                                                        note.text,
                                                        called.text);
                                                Navigator.pop(context);
                                                return showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      Size size =
                                                          MediaQuery.of(context)
                                                              .size;

                                                      Future.delayed(
                                                          Duration(seconds: 2),
                                                          () {
                                                        // Navigator.of(context)
                                                        //     .pop(true);
                                                        Navigator.of(context,
                                                                rootNavigator:
                                                                    true)
                                                            .pop(false);

                                                        // Navigator.of(context)
                                                        //     .push(
                                                        //   PageRouteBuilder(
                                                        //       opaque:
                                                        //           false, // set to false
                                                        //       pageBuilder: (_,
                                                        //               __,
                                                        //               ___) =>
                                                        //           DashBoardScreen()),
                                                        // );
                                                      });
                                                      return AlertDialog(
                                                          backgroundColor:
                                                              Colors.black,
                                                          content: Row(
                                                            children: [
                                                              Text(
                                                                'Service added',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            ],
                                                          ));
                                                    });
                                              },
                                              child: Text("ADD"),
                                            ))
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                  ),
                ),
              );
            },
          );
        });
  }
}
