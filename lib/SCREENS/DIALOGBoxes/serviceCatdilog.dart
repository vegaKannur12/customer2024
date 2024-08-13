import 'package:customerapp/CONTROLLER/controller.dart';
import 'package:customerapp/SCREENS/NEWSERVICE/serviceaddbotom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DialogService {
  showServiceCategoryDialog(
      BuildContext context, String from) async {
    Size size = MediaQuery.of(context).size; 
    TextEditingController seacrh = TextEditingController();
    ServiceADDBottomSheet servicebottom = ServiceADDBottomSheet();
    String date = DateFormat('dd-MMM-yyyy').format(DateTime.now());
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // String? phh = prefs.getString("ph");
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
            height: size.height / 1,
            //1
            width: size.width,
            child: Stack(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 65),
                  child: value.isserCatList
                      ? Align(
                          alignment: Alignment.center,
                          child: SpinKitCircle(
                            color: Colors.black,
                          ),
                        )
                      : value.service_categ_list.isEmpty
                          ? Center(
                              child: Lottie.asset("assets/noitem.json",
                                  height: size.height * 0.3))
                          : ListView.builder(
                              itemCount: value.service_categ_list.length,
                              shrinkWrap: true,
                              itemBuilder: (BuildContext context, int index) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5),
                                      child: InkWell(
                                        onTap: () async {
                                          SharedPreferences prefs =
                                              await SharedPreferences
                                                  .getInstance();
                                          prefs.setString(
                                              "req_id",
                                              value.service_categ_list[index]
                                                      ["Req_ID"]
                                                  .toString()
                                                  .trimLeft());
                                          servicebottom
                                              .showServiceADDMoadlBottomsheet(
                                                  value.service_categ_list,
                                                  context,
                                                  size,
                                                  index,
                                                  date,from);
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(),
                                          width: size.width / 1.2,
                                          padding: EdgeInsets.all(7),
                                          child: Text(
                                            // "FGDHDHTH HDFHDFH - HDFHDTHYF HGTEWEWAHL<L<K<",
                                            "${value.service_categ_list[index]["Req_Name"].toString().trimLeft().toUpperCase()}",
                                            textAlign: TextAlign.left,
                                            maxLines: 2,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Divider(
                                      color: Colors.black45,
                                    )
                                  ],
                                );
                              }),
                ),
                Container(
                  width: double.infinity,
                  height: 60,
                  alignment: Alignment.bottomCenter,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Color.fromARGB(241, 235, 236, 236),
                      ),
                      child: TextFormField(
                        controller: seacrh,
                        //   decoration: const InputDecoration(,
                        onChanged: (val) {
                          // setState(() {
                            Provider.of<Controller>(context, listen: false)
                                .getserviceCategoryList(
                                    context, val.toString());
                          // });
                        },
                        decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Colors.black,
                          ),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.cancel),
                            onPressed: () {
                              // setState(() {
                                print("pressed");
                                seacrh.clear();
                                Provider.of<Controller>(context, listen: false)
                                    .getserviceCategoryList(context, "");
                                // Provider.of<Controller>(context, listen: false)
                                //     .searchRoom("");
                              // });
                            },
                          ),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          hintText: "Search Category",
                        ),
                      ),
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