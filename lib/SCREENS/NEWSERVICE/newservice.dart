import 'package:customerapp/CONTROLLER/controller.dart';
import 'package:customerapp/SCREENS/DIALOGBoxes/incomdilog.dart';
import 'package:customerapp/SCREENS/DIALOGBoxes/serviceCatdilog.dart';
import 'package:customerapp/SCREENS/NEWSERVICE/serviceaddbotom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:phone_state/phone_state.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

class AddNEWService extends StatefulWidget {
  const AddNEWService({super.key});

  @override
  State<AddNEWService> createState() => _AddNEWServiceState();
}

class _AddNEWServiceState extends State<AddNEWService> {
  String? date;
  PhoneState status = PhoneState.nothing();
  DialogIncoming incomdio=DialogIncoming();
  DialogService serdio=DialogService();
  @override
  void initState() {
    super.initState();
    setStream();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<Controller>(context, listen: false)
          .getServiceCustomers(context, "","","");
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
                                .getServiceCustomers(context, val.toString(),"","");
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
                                Provider.of<Controller>(context,
                                        listen: false)
                                    .getServiceCustomers(context, "","","");
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
                                color: Colors.white,
                              ),
                            ),
                          )
                        : Expanded(
                            child: value.customerList.isEmpty
                                ? Container(
                                    height: size.height * 0.7,
                                    child: Center(
                                        child: Lottie.asset(
                                            "assets/noitem.json",
                                            height: size.height * 0.3)))
                                : GridView.builder(
                                    shrinkWrap: true,
                                    physics: const ScrollPhysics(),
                                    itemCount: value.customerList.length,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount:
                                          size.width >= 420 ? 2 : 1,
                                      crossAxisSpacing: 8,
                                      mainAxisSpacing: 8,
                                      childAspectRatio: 0.9,
                                    ),
                                    itemBuilder: (context, index) {
                                      return customerWidget(size,
                                          value.customerList[index], context);
                                    }),
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
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.black45),
                // boxShadow: [
                //   BoxShadow(
                //     color: Colors.black38,
                //     blurRadius: 12,
                //     spreadRadius: 3,
                //   )
                // ],
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
                              " : ${list["NOTES"].toString().trimLeft() == "" || list["NOTES"].toString().trimLeft().toLowerCase() == "null" ? "--" : list["NOTES"].toString().trimLeft()}",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 15),
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
                                  prefs.setString("h_code",
                                      list["H_CODE"].toString().trimLeft());
                                  prefs.setString("h_name",
                                      list["H_NAME"].toString().trimLeft());
                                  serdio.showServiceCategoryDialog(context, "normal");
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
                        )
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
          .getServiceCustomers(context, "","","");
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
