import 'package:customerapp/CONTROLLER/controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:phone_state/phone_state.dart';
import 'package:provider/provider.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({super.key});

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  String? date;
  PhoneState status = PhoneState.nothing();

  @override
  void initState() {
    super.initState();
    setStream();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<Controller>(context, listen: false)
          .getServiceCustomers(context, "");
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
        // await Provider.of<Controller>(context, listen: false)
        //     .addnumberTolist(event.number.toString());

        // String numb = "9745970942";
        // String mobileNumber = numb.substring(numb.length - 10);
        // await Provider.of<Controller>(context, listen: false)
        //     .getIncomingCall(context, mobileNumber);
        // showIncomingCallCustomDialog(context,size);

        if (event.number != "null" &&
            event.number != " " &&
            event.number != "NULL" &&
            event.number != "") {
          String mobileNumber =
              event.number!.substring(event.number!.length - 10);
          Provider.of<Controller>(context, listen: false)
              .getIncomingCall(context, mobileNumber);
          showIncomingCallCustomDialog(context);
        }
      }
    });
  }

  TextEditingController seacrh = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                // showIncomingAlert();
                showIncomingCallCustomDialog(context);
              },
              icon: Icon(Icons.shape_line))
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Consumer<Controller>(
            builder: (context, value, child) => Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Color.fromARGB(241, 235, 236, 236),
                  ),
                  child: TextFormField(
                    controller: seacrh,
                    //   decoration: const InputDecoration(,
                    onChanged: (val) {
                      setState(() {
                        Provider.of<Controller>(context, listen: false)
                            .getServiceCustomers(context, val.toString());
                      });
                    },
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Colors.black,
                      ),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.cancel),
                        onPressed: () {
                          setState(() {
                            print("pressed");
                            seacrh.clear();
                            Provider.of<Controller>(context, listen: false)
                                .getServiceCustomers(context, "");
                            // Provider.of<Controller>(context, listen: false)
                            //     .searchRoom("");
                          });
                        },
                      ),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      hintText: "Search Customer",
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                value.isCustLoading
                    ? const Expanded(
                        child: Align(
                          alignment: Alignment.center,
                          child: SpinKitCircle(
                            color: Colors.black,
                          ),
                        ),
                      )
                    : Expanded(
                        child: value.customerList.isEmpty
                            ? Container(
                                height: size.height * 0.7,
                                child: Center(
                                    child: Lottie.asset("assets/noitem.json",
                                        height: size.height * 0.3)))
                            : GridView.builder(
                                shrinkWrap: true,
                                physics: const ScrollPhysics(),
                                itemCount: value.customerList.length,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: size.width >= 420 ? 2 : 1,
                                  crossAxisSpacing: 8,
                                  mainAxisSpacing: 8,
                                  childAspectRatio: 1.13,
                                ),
                                itemBuilder: (context, index) {
                                  return customerWidget(
                                      size, value.customerList[index], context);
                                }),
                      ),
              ],
            ),
          ),
        ),
      ),
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
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.black45),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black38,
                    blurRadius: 12,
                    spreadRadius: 3,
                  )
                ],
              ),
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      // width: size.width / 1.5,
                      padding: EdgeInsets.all(5),
                      // color: Colors.green,
                      child: SizedBox(
                        // width: size.width / 4,
                        child: Text(
                          textAlign: TextAlign.left,
                          maxLines: 2,
                          // "SDFGGGTHHJJJJJJJJSSShngffhfghfghgfhgfh gsdggsdgsdg dgsdgdfgdfgdfgdfgdfgdfgdfgfdgdfgdfg",
                          list["H_NAME"].toString().trimLeft().toUpperCase(),
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: size.width >= 420 ? 20 : 17),
                          overflow: TextOverflow.ellipsis,
                        ),
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
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  textAlign: TextAlign.left,
                                  // maxLines: 2,
                                  // "SDFGGGTHHJJJJJJJJSSS",
                                  list["STATUS"].toString().trimLeft(),
                                  style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                      fontSize: size.width >= 420 ? 20 : 15),
                                  overflow: TextOverflow.ellipsis,
                                )
                              ]),
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
                              style:
                                  TextStyle(color: Colors.black, fontSize: 15),
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
                              " : ${list["SERIES"].toString().trimLeft()}",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 15),
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
                              " : ${list["NOTES"].toString().trimLeft()==""||list["NOTES"].toString().trimLeft().toLowerCase()=="null"?"--":list["NOTES"].toString().trimLeft()}",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 15),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ]),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ));
  }

  void showIncomingCallCustomDialog(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
            height: value.incomingCustomer.length == 1
                ? size.width / 1.5
                : value.incomingCustomer.length == 2
                    ? size.width / 0.80
                    : size.width / 1,
            //1
            width: size.width / 1,
            child: Stack(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10, top: 55),
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
                            SizedBox(
                              width: size.width / 1.2,
                              child: Text(
                                // "FGDHDHTH HDFHDFH - HDFHDTHYF HGTEWEWAHL<L<K<",
                                "${value.incomingCustomer[index]["H_NAME"].toString().trimLeft().toUpperCase()} ( ${value.incomingCustomer[index]["H_CODE"].toString().trimLeft()} )",
                                textAlign: TextAlign.left,
                                maxLines: 2
                                // "SDFGGGTHHJJJJJJJJSSS",
                                ,
                                style: TextStyle(
                                    color: Colors.red,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.phone_android),
                                      Text(
                                        textAlign: TextAlign.left,
                                        // maxLines: 2,
                                        // "SDFGGGTHHJJJJJJJJSSS",
                                        value.incomingCustomer[index]
                                                ["H_MOBILE"]
                                            .toString()
                                            .trimLeft(),
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 15),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                  Text(
                                    textAlign: TextAlign.left,
                                    value.incomingCustomer[index]["STATUS"]
                                        .toString()
                                        .trimLeft(),
                                    style: TextStyle(
                                        color: Colors.green,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                    overflow: TextOverflow.ellipsis,
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Row(children: [
                                Text(
                                  textAlign: TextAlign.left,
                                  "Expiry : ",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  textAlign: TextAlign.left,
                                  // maxLines: 2,
                                  // "SDFGGGTHHJJJJJJJJSSS",
                                  formattedexp,
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 15),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ]),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Row(children: [
                                Text(
                                  textAlign: TextAlign.left,
                                  "Expiry Days : ",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  textAlign: TextAlign.left,
                                  value.incomingCustomer[index]["EXP_DAYS"]
                                      .toString()
                                      .trimLeft(),
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 15),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ]),
                            ),
                            Divider()
                          ],
                        );
                      }),
                ),
                Container(
                  width: double.infinity,
                  height: 50,
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
                    child: Text(
                      "Incoming Call From",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600),
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

  // showIncomingAlert() async {
  //   return await showDialog(
  //     context: context,
  //     barrierDismissible: false, // user must tap button!
  //     builder: (BuildContext context) {
  //       return Consumer<Controller>(
  //         builder: (BuildContext context, Controller value, Widget? child) {
  //           return AlertDialog(
  //             title: Row(
  //               mainAxisAlignment: MainAxisAlignment.end,
  //               children: [
  //                 IconButton(
  //                     onPressed: () {
  //                       Navigator.of(context, rootNavigator: true).pop(false);
  //                     },
  //                     icon: Icon(Icons.close))
  //               ],
  //             ),
  //             // title: const Text('AlertDialog Title'),
  //             content: SingleChildScrollView(
  //               scrollDirection: Axis.vertical,
  //               child: Column(
  //                 mainAxisAlignment: MainAxisAlignment.start,
  //                 mainAxisSize: MainAxisSize.min,
  //                 children: <Widget>[
  //                   Column(
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       mainAxisSize: MainAxisSize.min,
  //                       children: [
  //                         Row(
  //                           mainAxisAlignment: MainAxisAlignment.center,
  //                           children: [Text("Incoming Call from")],
  //                         ),
  //                         SizedBox(
  //                           height: 10,
  //                         ),
  //                         Container(
  //                           padding: EdgeInsets.all(5),
  //                           color: Colors.green,
  //                           child: Text(
  //                             "${value.incomingCustomer[0]["H_NAME"].toString().trimLeft().toUpperCase()} ( ${value.incomingCustomer[0]["H_CODE"].toString().trimLeft()} )",
  //                             textAlign: TextAlign.left,
  //                             maxLines: 2
  //                             // "SDFGGGTHHJJJJJJJJSSS",
  //                             ,
  //                             style: TextStyle(
  //                                 color: Colors.black,
  //                                 fontWeight: FontWeight.bold,
  //                                 fontSize: 18),
  //                             overflow: TextOverflow.ellipsis,
  //                           ),
  //                         ),
  //                         Column(
  //                           crossAxisAlignment: CrossAxisAlignment.start,
  //                           mainAxisSize: MainAxisSize.min,
  //                           children: [
  //                             Text(
  //                               textAlign: TextAlign.left,
  //                               // maxLines: 2,
  //                               // "SDFGGGTHHJJJJJJJJSSS",
  //                               value.incomingCustomer[0]["H_ADDRESS"]
  //                                   .toString()
  //                                   .trimLeft(),
  //                               style: TextStyle(
  //                                   color: Colors.black, fontSize: 15),
  //                               overflow: TextOverflow.ellipsis,
  //                             ),
  //                             Text(
  //                               textAlign: TextAlign.left,
  //                               // maxLines: 2,
  //                               // "SDFGGGTHHJJJJJJJJSSS",
  //                               value.incomingCustomer[0]["H_PLACE"]
  //                                   .toString()
  //                                   .trimLeft(),
  //                               style: TextStyle(
  //                                   color: Colors.black, fontSize: 15),
  //                               overflow: TextOverflow.ellipsis,
  //                             ),
  //                             Row(
  //                               mainAxisAlignment:
  //                                   MainAxisAlignment.spaceBetween,
  //                               children: [
  //                                 Row(
  //                                   children: [
  //                                     Icon(Icons.phone_android),
  //                                     Text(
  //                                       textAlign: TextAlign.left,
  //                                       // maxLines: 2,
  //                                       // "SDFGGGTHHJJJJJJJJSSS",
  //                                       value.incomingCustomer[0]["H_MOBILE"]
  //                                           .toString()
  //                                           .trimLeft(),
  //                                       style: TextStyle(
  //                                           color: Colors.black, fontSize: 15),
  //                                       overflow: TextOverflow.ellipsis,
  //                                     ),
  //                                   ],
  //                                 ),
  //                                 Text(
  //                                   textAlign: TextAlign.left,
  //                                   // maxLines: 2,
  //                                   // "SDFGGGTHHJJJJJJJJSSS",
  //                                   value.incomingCustomer[0]["STATUS"]
  //                                       .toString()
  //                                       .trimLeft(),
  //                                   style: TextStyle(
  //                                       color: Colors.green, fontSize: 15),
  //                                   overflow: TextOverflow.ellipsis,
  //                                 )
  //                               ],
  //                             ),
  //                           ],
  //                         ),
  //                       ]),
  //                   // Text("${value.incomingCustomer[0]["H_CODE"].toString()}"),
  //                   //  Text("${value.incomingCustomer[0]["H_CODE"].toString()}"),
  //                   //   Text("${value.incomingCustomer[0]["H_CODE"].toString()}"),
  //                   //    Text("${value.incomingCustomer[0]["H_CODE"].toString()}"),
  //                   //     Text("${value.incomingCustomer[0]["H_CODE"].toString()}"),

  //                   //      Text("${value.incomingCustomer[0]["H_CODE"].toString()}"),
  //                 ],
  //               ),
  //             ),
  //             actions: <Widget>[
  //               TextButton(
  //                 child: const Text('Ok'),
  //                 onPressed: () {
  //                   Navigator.pop(context);
  //                 },
  //               ),
  //             ],
  //           );
  //         },
  //       );
  //     },
  //   );
  // }

  Future<void> _handleRefresh() async {
    // Simulate network fetch or database query
    await Future.delayed(Duration(seconds: 2));
    // Update the list of items and refresh the UI
    setState(() {
      Provider.of<Controller>(context, listen: false)
          .getServiceCustomers(context, "");
      print("Table Refreshed----");
      // items = List.generate(20, (index) => "Refreshed Item ${index + 1}");
    });
  }
}
