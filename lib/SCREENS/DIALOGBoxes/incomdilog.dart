import 'package:customerapp/CONTROLLER/controller.dart';
import 'package:customerapp/SCREENS/DIALOGBoxes/serviceCatdilog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DialogIncoming {
  showIncomingCallCustomDialog(BuildContext context) async {
    Size size = MediaQuery.of(context).size;
    DialogService serdio=DialogService();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? phh = prefs.getString("ph");
    print("siccccccccccc-${size.height / 1.5}");
    Dialog fancyDialog = Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Consumer<Controller>(
        builder: (BuildContext context, Controller value, Widget? child) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
            ),
            height: value.incomingCustomer.length == 1 ||
                    value.incomingCustomer.length == 0
                ? size.height / 1.5
                : value.incomingCustomer.length == 2
                    ? size.height / 0.80
                    : size.height / 1,
            //1
            width: size.width / 1,
            child: Stack(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10, top: 65),
                  child: ListView.builder(
                      itemCount: value.incomingCustomer.length,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        String expString = value.incomingCustomer[index]
                                ["EXPIRY"]
                            .toString()
                            .trimLeft();
                        DateTime dateTime = DateTime.parse(expString);
                        String formattedexp =
                            DateFormat('dd-MMM-yyyy').format(dateTime);

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                color: Colors.black,
                              )),
                              width: size.width / 1.2,
                              padding: EdgeInsets.all(3),
                              child: Text(
                                // "FGDHDHTH HDFHDFH - HDFHDTHYF HGTEWEWAHL<L<K<",
                                "${value.incomingCustomer[index]["H_NAME"].toString().trimLeft().toUpperCase()}",
                                textAlign: TextAlign.left,
                                maxLines: 2,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            value.incomingCustomer[index]["H_ADDRESS"]
                                            .toString()
                                            .trimLeft() ==
                                        "" ||
                                    value.incomingCustomer[index]["H_ADDRESS"]
                                            .toString()
                                            .trimLeft()
                                            .toLowerCase() ==
                                        "null"
                                ? SizedBox()
                                : Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 5),
                                    child: Row(
                                      children: [
                                        Icon(Icons.location_on_outlined),
                                        SizedBox(
                                          width: size.width / 1.7,
                                          child: Text(
                                            textAlign: TextAlign.left,
                                            maxLines: 2,
                                            // "SDFGGGTHHJJJJJJJJSSS hgfdfghdgfhfgh",
                                            value.incomingCustomer[index]
                                                    ["H_ADDRESS"]
                                                .toString()
                                                .trimLeft(),
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                            value.incomingCustomer[index]["H_PLACE"]
                                            .toString()
                                            .trimLeft() ==
                                        "" ||
                                    value.incomingCustomer[index]["H_PLACE"]
                                            .toString()
                                            .trimLeft()
                                            .toLowerCase() ==
                                        "null"
                                ? SizedBox()
                                : Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 5),
                                    child: Row(children: [
                                      Icon(Icons.location_on_outlined),
                                      SizedBox(
                                        width: size.width / 1.7,
                                        child: Text(
                                          textAlign: TextAlign.left,
                                          maxLines: 2,
                                          // "SDFGGGTHHJJJJJJJJSSSjkkjhkjk",
                                          value.incomingCustomer[index]
                                                  ["H_PLACE"]
                                              .toString()
                                              .trimLeft(),
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ]),
                                  ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Row(
                                children: [
                                  Icon(Icons.phone_android),
                                  SizedBox(
                                    width: size.width / 1.7,
                                    child: Text(
                                      textAlign: TextAlign.left,
                                      maxLines: 2,
                                      // "SDFGGGTHHJJJJJJJJSSS",
                                      value.incomingCustomer[index]["H_MOBILE"]
                                          .toString()
                                          .trimLeft(),
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 15),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: size.width / 1.7,
                                    child: Text(
                                      textAlign: TextAlign.left,
                                      maxLines: 2,
                                      // "SDFGGGTHHJJJJJJJJSSS hgfdfghdgfhfgh",
                                      value.incomingCustomer[index]["PRODUCT"]
                                          .toString()
                                          .trimLeft(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue,
                                          fontSize: 15),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Row(children: [
                                SizedBox(
                                  width: size.width / 4.3,
                                  child: Text(
                                    textAlign: TextAlign.left,
                                    "Expiry",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Text(
                                  textAlign: TextAlign.left,
                                  // maxLines: 2,
                                  // "SDFGGGTHHJJJJJJJJSSS",
                                  " : $formattedexp",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 15),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ]),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(children: [
                                    SizedBox(
                                      width: size.width / 4.3,
                                      child: Text(
                                        textAlign: TextAlign.left,
                                        "Exp. Days",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Text(
                                      textAlign: TextAlign.left,
                                      " : ${value.incomingCustomer[index]["EXP_DAYS"].toString().trimLeft()}",
                                      style: TextStyle(
                                          color: value.incomingCustomer[index]
                                                      ["EXP_DAYS"] <
                                                  0
                                              ? Colors.red
                                              : Colors.black,
                                          fontSize: 15),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ]),
                                  Text(
                                    textAlign: TextAlign.left,
                                    value.incomingCustomer[index]["STATUS"]
                                        .toString()
                                        .trimLeft(),
                                    style: TextStyle(
                                        color: value.incomingCustomer[index]
                                                    ["EXP_DAYS"] <
                                                0
                                            ? Colors.red
                                            : Colors.green,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Row(children: [
                                SizedBox(
                                  width: size.width / 4.3,
                                  child: Text(
                                    textAlign: TextAlign.left,
                                    "Care Of",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Text(
                                  textAlign: TextAlign.left,
                                  " : ${value.incomingCustomer[index]["SERIES"].toString().trimLeft()}",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 15),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ]),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Row(children: [
                                SizedBox(
                                  width: size.width / 4.3,
                                  child: Text(
                                    textAlign: TextAlign.left,
                                    "REMARKS",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Text(
                                  textAlign: TextAlign.left,
                                  " : ${value.incomingCustomer[index]["NOTES"].toString().trimLeft() == "" || value.incomingCustomer[index]["NOTES"].toString().trimLeft().toLowerCase() == "null" ? "--" : value.incomingCustomer[index]["NOTES"].toString().trimLeft()}",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 15),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ]),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  InkWell(
                                    onTap: () async {
                                      await Provider.of<Controller>(context,
                                              listen: false)
                                          .getserviceCategoryList(context, '');
                                      SharedPreferences prefs =
                                          await SharedPreferences.getInstance();
                                      prefs.setString(
                                          "h_code",
                                          value.incomingCustomer[index]
                                                  ["H_CODE"]
                                              .toString()
                                              .trimLeft());
                                      prefs.setString(
                                          "h_name",
                                          value.incomingCustomer[index]
                                                  ["H_NAME"]
                                              .toString()
                                              .trimLeft());

                                      serdio.showServiceCategoryDialog(
                                          context, "incoming");
                                    },
                                    child: SizedBox(
                                      height: 40,
                                      width: 40,
                                      child: Image.asset(
                                        "assets/service.png",
                                        fit: BoxFit.fitHeight,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Divider()
                          ],
                        );
                      }),
                ),
                Container(
                  width: double.infinity,
                  height: 60,
                  alignment: Alignment.bottomCenter,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Incoming Call From",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600),
                        ),
                        Text(phh.toString(),
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ),
                Align(
                  // These values are based on trial & error method
                  alignment: Alignment(1.05, -1.05),
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.close,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
    showDialog(
        context: context, builder: (BuildContext context) => fancyDialog);
  }
  
}