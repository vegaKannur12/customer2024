import 'package:customerapp/CONTROLLER/controller.dart';
import 'package:customerapp/SCREENS/DIALOGBoxes/incomdilog.dart';
import 'package:customerapp/SCREENS/DIALOGBoxes/saveservicelog.dart';
import 'package:customerapp/SCREENS/DIALOGBoxes/serviceCatdilog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:phone_state/phone_state.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SERvicePendingList extends StatefulWidget {
  String from;
  SERvicePendingList({super.key, required this.from});

  @override
  State<SERvicePendingList> createState() => _SERvicePendingListState();
}

class _SERvicePendingListState extends State<SERvicePendingList> {
  String? date;
  PhoneState status = PhoneState.nothing();
  DialogIncoming incomdio = DialogIncoming();
  DialogService serdio = DialogService();
  ServiceLOGBottomSheet srlo = ServiceLOGBottomSheet();
  @override
  void initState() {
    super.initState();
    setStream();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Provider.of<Controller>(context, listen: false)
      //     .getServiceCustomers(context, "","","");
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
    List<dynamic> serviceTypeOneList =
        Provider.of<Controller>(context, listen: false)
            .service_list
            .where((service) => service["STYPE"] == 1)
            .toList();
    print("service histry===$serviceTypeOneList");
    return Stack(
      children: [
        Scaffold(
          backgroundColor: const Color.fromARGB(255, 219, 243, 247),
          extendBody: true,
          appBar: AppBar(
            // forceMaterialTransparency: true,
            automaticallyImplyLeading: false,
            backgroundColor: const Color.fromARGB(255, 31, 164, 187),
            elevation: 0.0,
            actions: [
              IconButton(
                  onPressed: () {
                    // showIncomingAlert();
                    incomdio.showIncomingCallCustomDialog(context);
                  },
                  icon: Icon(Icons.shape_line))
            ],
          ),
          body: RefreshIndicator(
            onRefresh: _handleRefresh,
            child: SingleChildScrollView(
              child: Consumer<Controller>(
                builder: (context, value, child) => Column(
                  children: [
                    widget.from == "pending"
                        ? ListView.builder(
                            itemCount: value.customerList.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return customerWidget(
                                  size, value.customerList[index], context);
                            })
                        : Container(),
                    value.isserList
                        ? Align(
                            alignment: Alignment.center,
                            child: SpinKitCircle(
                              color: Colors.white,
                            ),
                          )
                        : value.service_list.isEmpty
                            ? Container(
                                height: size.height * 0.7,
                                child: Center(
                                    child: Lottie.asset("assets/datano.json",
                                        height: size.height * 0.3)))
                            : ListView.builder(
                                itemCount: value.service_list.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  String dateTimeString = value
                                      .service_list[index]["SERVICE_DATE"]
                                      .toString()
                                      .trimLeft();
                                  DateTime dateTime =
                                      DateTime.parse(dateTimeString);
                                  String formattedDate =
                                      "${dateTime.day.toString().padLeft(2, '0')}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.year}";
                                  String dateTimeString1 = value
                                      .service_list[index]["SERVICE_TIME"]
                                      .toString()
                                      .trimLeft();
                                  DateTime dateTime1 =
                                      DateTime.parse(dateTimeString1);
                                  DateFormat dateFormat =
                                      DateFormat("hh:mm:ss a");
                                  String formattedTime =
                                      dateFormat.format(dateTime1);
                                  return Consumer<Controller>(
                                      builder:
                                          (context, value, child) =>
                                              value.service_list[index]
                                                          ["STYPE"] ==
                                                      0
                                                  ? InkWell(
                                                      onTap: () {
                                                        srlo.showServiceLOGMoadlBottomsheet(
                                                            value.service_list[
                                                                    index]
                                                                ["SERVICE_ID"],
                                                            context,
                                                            size);
                                                      },
                                                      child: Container(
                                                        // width: size.width / 1.5,
                                                        // height: size.height /4,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(15),
                                                          border: Border.all(
                                                              color: Colors
                                                                  .black45),
                                                        ),
                                                        child: Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    10),
                                                            child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: [
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                        .symmetric(
                                                                        vertical:
                                                                            5),
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .end,
                                                                      children: [
                                                                        Text(
                                                                          "$formattedDate",
                                                                          textAlign:
                                                                              TextAlign.left,
                                                                          style: TextStyle(
                                                                              color: const Color.fromARGB(255, 39, 65, 40),
                                                                              // fontWeight: FontWeight.bold,
                                                                              fontSize: size.width >= 420 ? 20 : 15),
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                        ),
                                                                        Text(
                                                                          "( $formattedTime )",
                                                                          textAlign:
                                                                              TextAlign.left,
                                                                          style: TextStyle(
                                                                              color: const Color.fromARGB(255, 39, 65, 40),
                                                                              fontSize: size.width >= 420 ? 20 : 15),
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    padding:
                                                                        EdgeInsets
                                                                            .all(5),
                                                                    child:
                                                                        SizedBox(
                                                                      child:
                                                                          Text(
                                                                        textAlign:
                                                                            TextAlign.left,
                                                                        maxLines:
                                                                            2,
                                                                        // "SDFGGGTHHJJJJJJJJSSShngffhfghfghgfhgfh gsdggsdgsdg dgsdgdfgdfgdfgdfgdfgdfgdfgfdgdfgdfg",
                                                                        value
                                                                            .service_list[index]["Req_Name"]
                                                                            .toString()
                                                                            .trimLeft()
                                                                            .toUpperCase(),
                                                                        style: TextStyle(
                                                                            color: Colors
                                                                                .red,
                                                                            fontWeight: FontWeight
                                                                                .bold,
                                                                            fontSize: size.width >= 420
                                                                                ? 20
                                                                                : 17),
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                        .symmetric(
                                                                        vertical:
                                                                            5),
                                                                    child: Row(
                                                                      children: [
                                                                        Icon(Icons
                                                                            .description),
                                                                        SizedBox(
                                                                          width:
                                                                              size.width / 1.3,
                                                                          child:
                                                                              Text(
                                                                            textAlign:
                                                                                TextAlign.left,
                                                                            maxLines:
                                                                                2,
                                                                            // "SDFGGGTHHJJJJJJJJSSSgjgfjf,gjfgjgfjfgj, fhdfhdfhfhfghfghf",
                                                                            " ${value.service_list[index]["SERVICE_DESCRIPTION"].toString().trimLeft() == "" || value.service_list[index]["SERVICE_DESCRIPTION"].toString().trimLeft().toLowerCase() == "null" ? "" : "${value.service_list[index]["SERVICE_DESCRIPTION"].toString().trimLeft()} "} ",
                                                                            style:
                                                                                TextStyle(color: Colors.black, fontSize: size.width >= 420 ? 20 : 15),
                                                                            overflow:
                                                                                TextOverflow.ellipsis,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                        .symmetric(
                                                                        vertical:
                                                                            5),
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        Row(
                                                                          children: [
                                                                            SizedBox(
                                                                              width: size.width / 4.3,
                                                                              child: Text(
                                                                                "Status",
                                                                                style: TextStyle(color: Colors.black, fontSize: 15),
                                                                              ),
                                                                            ),
                                                                            SizedBox(
                                                                              width: size.width / 2,
                                                                              child: Text(
                                                                                " : ${value.service_list[index]['SERVICE_STATUS'].toString()}",
                                                                                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15, overflow: TextOverflow.ellipsis),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        Row(
                                                                          children: [
                                                                            Text(
                                                                              "Days : ",
                                                                              style: TextStyle(color: Colors.black, fontSize: 15),
                                                                            ),
                                                                            Text(
                                                                              // "100",
                                                                              value.service_list[index]['DAYS'].toString(),
                                                                              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 17),
                                                                            ),
                                                                          ],
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                        .symmetric(
                                                                        vertical:
                                                                            5),
                                                                    child: Row(
                                                                        children: [
                                                                          SizedBox(
                                                                            width:
                                                                                size.width / 4.3,
                                                                            child:
                                                                                Text(
                                                                              textAlign: TextAlign.left,
                                                                              "CALLED BY",
                                                                              style: TextStyle(
                                                                                color: Colors.black,
                                                                                fontSize: 15,
                                                                              ),
                                                                              overflow: TextOverflow.ellipsis,
                                                                            ),
                                                                          ),
                                                                          Text(
                                                                            textAlign:
                                                                                TextAlign.left,
                                                                            // maxLines: 2,
                                                                            // "SDFGGGTHHJJJJJJJJSSS",
                                                                            " : ${value.service_list[index]['SERVICE_CALLEDBY'].toString().trimLeft()}",
                                                                            style: TextStyle(
                                                                                color: Colors.black,
                                                                                fontSize: 15,
                                                                                fontWeight: FontWeight.bold),
                                                                            overflow:
                                                                                TextOverflow.ellipsis,
                                                                          ),
                                                                        ]),
                                                                  ),
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                        .symmetric(
                                                                        vertical:
                                                                            5),
                                                                    child: Row(
                                                                        children: [
                                                                          SizedBox(
                                                                            width:
                                                                                size.width / 4.3,
                                                                            child:
                                                                                Text(
                                                                              textAlign: TextAlign.left,
                                                                              "ENTRY BY",
                                                                              style: TextStyle(
                                                                                color: Colors.black,
                                                                                fontSize: 15,
                                                                              ),
                                                                              overflow: TextOverflow.ellipsis,
                                                                            ),
                                                                          ),
                                                                          Text(
                                                                            textAlign:
                                                                                TextAlign.left,
                                                                            // maxLines: 2,
                                                                            // "SDFGGGTHHJJJJJJJJSSS",
                                                                            " : ${value.service_list[index]['ENTERED_BY'].toString().trimLeft()}",
                                                                            style: TextStyle(
                                                                                color: Colors.black,
                                                                                fontSize: 15,
                                                                                fontWeight: FontWeight.bold),
                                                                            overflow:
                                                                                TextOverflow.ellipsis,
                                                                          ),
                                                                        ]),
                                                                  ),
                                                                ])),
                                                      ),
                                                    )
                                                  : Container());
                                }),
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    if (serviceTypeOneList.isNotEmpty)
                      Column(
                        children: [
                          Text(
                            "History",
                            style: TextStyle(
                                color: const Color.fromARGB(255, 49, 80, 50),
                                fontSize: 17,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: size.height * 0.02,
                          ),
                          ListView.builder(
                              itemCount: serviceTypeOneList.length,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                String dateTimeString =
                                    serviceTypeOneList[index]["SERVICE_DATE"]
                                        .toString()
                                        .trimLeft();
                                DateTime dateTime =
                                    DateTime.parse(dateTimeString);
                                String formattedDate =
                                    "${dateTime.day.toString().padLeft(2, '0')}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.year}";
                                String dateTimeString1 =
                                    serviceTypeOneList[index]["SERVICE_TIME"]
                                        .toString()
                                        .trimLeft();
                                DateTime dateTime1 =
                                    DateTime.parse(dateTimeString1);
                                DateFormat dateFormat =
                                    DateFormat("hh:mm:ss a");
                                String formattedTime =
                                    dateFormat.format(dateTime1);
                                return Consumer<Controller>(
                                    builder: (context, value, child) => InkWell(
                                          onTap: () {
                                            srlo.showServiceLOGMoadlBottomsheet(
                                                serviceTypeOneList[index]
                                                    ["SERVICE_ID"],
                                                context,
                                                size);
                                          },
                                          child: Container(
                                            // width: size.width / 1.5,
                                            // height: size.height /4,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              border: Border.all(
                                                  color: Colors.black45),
                                            ),
                                            child: Padding(
                                                padding: EdgeInsets.all(10),
                                                child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                vertical: 5),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: [
                                                            Text(
                                                              "$formattedDate",
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                              style: TextStyle(
                                                                  color: const Color
                                                                      .fromARGB(
                                                                      255,
                                                                      39,
                                                                      65,
                                                                      40),
                                                                  // fontWeight: FontWeight.bold,
                                                                  fontSize:
                                                                      size.width >=
                                                                              420
                                                                          ? 20
                                                                          : 15),
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                            Text(
                                                              "( $formattedTime )",
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                              style: TextStyle(
                                                                  color: const Color
                                                                      .fromARGB(
                                                                      255,
                                                                      39,
                                                                      65,
                                                                      40),
                                                                  fontSize:
                                                                      size.width >=
                                                                              420
                                                                          ? 20
                                                                          : 15),
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                        padding:
                                                            EdgeInsets.all(5),
                                                        child: SizedBox(
                                                          child: Text(
                                                            textAlign:
                                                                TextAlign.left,
                                                            maxLines: 2,
                                                            // "SDFGGGTHHJJJJJJJJSSShngffhfghfghgfhgfh gsdggsdgsdg dgsdgdfgdfgdfgdfgdfgdfgdfgfdgdfgdfg",
                                                            serviceTypeOneList[
                                                                        index]
                                                                    ["Req_Name"]
                                                                .toString()
                                                                .trimLeft()
                                                                .toUpperCase(),
                                                            style: TextStyle(
                                                                color:
                                                                    Colors.red,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize:
                                                                    size.width >=
                                                                            420
                                                                        ? 20
                                                                        : 17),
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                vertical: 5),
                                                        child: Row(
                                                          children: [
                                                            Icon(Icons
                                                                .description),
                                                            SizedBox(
                                                              width:
                                                                  size.width /
                                                                      1.3,
                                                              child: Text(
                                                                textAlign:
                                                                    TextAlign
                                                                        .left,
                                                                maxLines: 2,
                                                                // "SDFGGGTHHJJJJJJJJSSSgjgfjf,gjfgjgfjfgj, fhdfhdfhfhfghfghf",
                                                                " ${serviceTypeOneList[index]["SERVICE_DESCRIPTION"].toString().trimLeft() == "" || serviceTypeOneList[index]["SERVICE_DESCRIPTION"].toString().trimLeft().toLowerCase() == "null" ? "" : "${serviceTypeOneList[index]["SERVICE_DESCRIPTION"].toString().trimLeft()}, "} ",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        size.width >=
                                                                                420
                                                                            ? 20
                                                                            : 15),
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                vertical: 5),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Row(
                                                              children: [
                                                                SizedBox(
                                                                  width:
                                                                      size.width /
                                                                          4.3,
                                                                  child: Text(
                                                                    "Status",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize:
                                                                            15),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width:
                                                                      size.width /
                                                                          2,
                                                                  child: Text(
                                                                    " : ${serviceTypeOneList[index]['SERVICE_STATUS'].toString()}",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        fontSize:
                                                                            17,
                                                                        overflow:
                                                                            TextOverflow.ellipsis),
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
                                                                      fontSize:
                                                                          15),
                                                                ),
                                                                Text(
                                                                  serviceTypeOneList[
                                                                              index]
                                                                          [
                                                                          'DAYS']
                                                                      .toString(),
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          17),
                                                                ),
                                                              ],
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                vertical: 5),
                                                        child: Row(children: [
                                                          SizedBox(
                                                            width: size.width /
                                                                4.3,
                                                            child: Text(
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                              "CALLED BY",
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 15,
                                                              ),
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                          ),
                                                          Text(
                                                            textAlign:
                                                                TextAlign.left,
                                                            // maxLines: 2,
                                                            // "SDFGGGTHHJJJJJJJJSSS",
                                                            " : ${serviceTypeOneList[index]['SERVICE_CALLEDBY'].toString().trimLeft()}",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ]),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                vertical: 5),
                                                        child: Row(children: [
                                                          SizedBox(
                                                            width: size.width /
                                                                4.3,
                                                            child: Text(
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                              "ENTRY BY",
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 15,
                                                              ),
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                          ),
                                                          Text(
                                                            textAlign:
                                                                TextAlign.left,
                                                            // maxLines: 2,
                                                            // "SDFGGGTHHJJJJJJJJSSS",
                                                            " : ${serviceTypeOneList[index]['ENTERED_BY'].toString().trimLeft()}",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ]),
                                                      ),
                                                    ])),
                                          ),
                                        ));
                              }),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget customerWidget(
      Size size, Map<String, dynamic> list, BuildContext context) {
    String expString = list["EXPIRY"].toString().trimLeft();

    // Parse the string into a DateTime object
    DateTime dateTime = DateTime.parse(expString);

    // Format the date into 'dd-MMM-yyyy' format
    String formattedexp = DateFormat('dd-MMM-yyyy').format(dateTime);
    return Consumer<Controller>(
        builder: (context, value, child) => Container(
              // width: size.width / 1.5,
              // height: size.height /4,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 248, 242, 242),
              ),
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: size.width,
                      padding: EdgeInsets.all(5),
                      // color: Colors.green,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        // width: size.width / 4,
                        children: [
                          SizedBox(
                            width: size.width / 1.10,
                            child: Text(
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              // "SDFGGGTHHJJJJJJJJSSShngffhfghfghgfhgfh gsdggsdgsdg dgsdgdfgdfgdfgdfgdfgdfgdfgfdgdfgdfg",
                              list["H_NAME"]
                                  .toString()
                                  .trimLeft()
                                  .toUpperCase(),
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: size.width >= 420 ? 20 : 17),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Row(
                            children: [
                              Icon(Icons.location_on_outlined),
                              SizedBox(
                                width: size.width / 1.3,
                                child: Text(
                                  textAlign: TextAlign.left,
                                  maxLines: 2,
                                  // "SDFGGGTHHJJJJJJJJSSSgjgfjf,gjfgjgfjfgj, fhdfhdfhfhfghfghf",
                                  " ${list["H_ADDRESS"].toString().trimLeft() == "" || list["H_ADDRESS"].toString().trimLeft().toLowerCase() == "null" ? "" : "${list["H_ADDRESS"].toString().trimLeft()}, "} ${list["H_PLACE"].toString().trimLeft() == "" || list["H_PLACE"].toString().trimLeft().toLowerCase() == "null" ? "" : list["H_PLACE"].toString().trimLeft()}",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: size.width >= 420 ? 20 : 15),
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
                              Icon(Icons.phone_android),
                              SizedBox(
                                width: size.width / 1.3,
                                child: Text(
                                  textAlign: TextAlign.left,
                                  maxLines: 2,
                                  // "0989787765,7666666667,9999999999,4455555555,6543456787",
                                  list["H_MOBILE"].toString().trimLeft(),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: size.width >= 420 ? 20 : 15),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Text(
                            textAlign: TextAlign.left,
                            maxLines: 2,
                            // "0989787765,7666666667,9999999999,4455555555,6543456787",
                            list["PRODUCT"].toString().trimLeft(),
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                                fontSize: size.width >= 420 ? 20 : 15),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(children: [
                                SizedBox(
                                  width: size.width / 4.3,
                                  child: Text(
                                    textAlign: TextAlign.left,
                                    "Expiry Days",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Text(
                                  textAlign: TextAlign.left,
                                  " : ${list["EXP_DAYS"].toString().trimLeft()} days",
                                  style: TextStyle(
                                      color: list["EXP_DAYS"] < 0
                                          ? Colors.red
                                          : Colors.black,
                                      fontSize: 15),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ]),
                              Text(
                                textAlign: TextAlign.left,
                                // maxLines: 2,
                                // "SDFGGGTHHJJJJJJJJSSS",
                                list["STATUS"].toString().trimLeft(),
                                style: TextStyle(
                                    color: list["EXP_DAYS"] < 0
                                        ? Colors.red
                                        : Colors.green,
                                    fontWeight: FontWeight.bold,
                                    fontSize: size.width >= 420 ? 20 : 15),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ));
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
}
