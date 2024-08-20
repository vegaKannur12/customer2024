import 'package:customerapp/CONTROLLER/controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ServiceLOGBottomSheet {
  ValueNotifier<bool> visible = ValueNotifier(false);
  TextEditingController note = TextEditingController();
  TextEditingController amt = TextEditingController();

  showServiceLOGMoadlBottomsheet(
    int ser_id,
    BuildContext context,
    Size size,
  ) async {
    String? datenow = DateFormat('dd-MMM-yyyy').format(DateTime.now());
    List<Map<String, dynamic>> ll = [
      {"Key": -1, "val": "CANCELLED"},
      {"Key": 0, "val": "PENDING"},
      {"Key": 1, "val": "MODIFYING"},
      {"Key": 2, "val": "MODIFICATION COMPLETED"},
      {"Key": 3, "val": "JOB CARD"},
      {"Key": 4, "val": "SERVICE COMPLETED"},
    ];
    Map<String, dynamic>? selectedValue;
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          print("param---$ser_id--");
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
                                        vertical: 6, horizontal: 5),
                                    child: Container(
                                      width: size.width / 1.1,
                                      // width: 250,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.rectangle),
                                      child: DropdownButtonFormField<
                                          Map<String, dynamic>>(
                                        decoration: InputDecoration(
                                            labelStyle:
                                                TextStyle(color: Colors.black),
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20.0)),
                                              borderSide: const BorderSide(
                                                  color: Colors.black,
                                                  width: 1),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20.0)),
                                              borderSide: const BorderSide(
                                                  color: Colors.black,
                                                  width: 1),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20.0)),
                                              borderSide: const BorderSide(
                                                  color: Colors.black,
                                                  width: 1),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20.0)),
                                              borderSide: const BorderSide(
                                                  color: Colors.red, width: 1),
                                            )),
                                        isExpanded: true,
                                        hint: Text(
                                          "Status",
                                          style: TextStyle(color: Colors.black),
                                        ),
                                        value: selectedValue,
                                        style: TextStyle(color: Colors.black),
                                        onChanged:
                                            (Map<String, dynamic>? newValue) {
                                          selectedValue = newValue;
                                          print(selectedValue!["Key"]);
                                        },
                                        items: ll.map<
                                                DropdownMenuItem<
                                                    Map<String, dynamic>>>(
                                            (Map<String, dynamic> item) {
                                          return DropdownMenuItem<
                                              Map<String, dynamic>>(
                                            value: item,
                                            child: Text(item['val']),
                                          );
                                        }).toList(),
                                      ),
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
                                            controller: amt,
                                            decoration: InputDecoration(
                                              hintText: "Amount",
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
                                                    .saveServiceLog(
                                                        context,
                                                        ser_id,
                                                        datenow,
                                                        int.parse(
                                                            selectedValue![
                                                                    "Key"]
                                                                .toString()),
                                                        note.text,
                                                        amt.text);
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
                                                        note.clear();
                                                        amt.clear();
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
                                                                'Service Log added',
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
                                              child: Text("ADD LOG"),
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
