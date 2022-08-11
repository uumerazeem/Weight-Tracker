import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:interview_test/models/dataModel.dart';
import 'package:interview_test/providers/data_provider.dart';
import 'package:interview_test/utils/app_colors.dart';
import 'package:interview_test/utils/shared_preference.dart';
import 'package:interview_test/views/auth_screen.dart';
import 'package:interview_test/widgets/single_action_button.dart';
import 'package:interview_test/widgets/text_box.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);
  TextEditingController weight = TextEditingController();
  PreferenceService preferenceService = PreferenceService();

  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(builder: (context, dataProvider, _) {
      print(dataProvider.loading.toString());
      return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColor.primaryColor,
          title: const Text("Weight Tracker"),
          actions: [
            GestureDetector(
              onTap: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => AuthScreen()));
                preferenceService.clear();
              },
              child: Padding(
                padding: EdgeInsets.only(right: 10),
                child: Icon(Icons.logout_outlined),
              ),
            )
          ],
        ),
        floatingActionButton: ElevatedButton(
          onPressed: () {
            weight.clear();
            showDialog(
                context: context,
                builder: (context) {
                  return Dialog(
                      child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Add Data",
                          style: TextStyle(
                              fontSize: 22, color: AppColor.primaryColor),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: TextBoxAccounts(
                            boxHint: "Enter Weight",
                            obsecure: false,
                            controller: weight,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        SingleActionButton(
                            buttonName: "Save",
                            onPressed: () {
                              if (weight.text == null ||
                                  weight.text == "" ||
                                  weight.text.isEmpty) {
                                Fluttertoast.showToast(msg: "Enter Weight");
                              } else {
                                Navigator.pop(context);
                                dataProvider.createData(weight.text);
                              }
                            })
                      ],
                    ),
                  ));
                });
          },
          child: Icon(Icons.add),
          style: ElevatedButton.styleFrom(
            primary: AppColor.primaryColor,
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(20),
          ),
        ),
        body: dataProvider.loading == true
            ? const Center(
                child: CircularProgressIndicator(
                  color: AppColor.primaryColor,
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      "Data List",
                      style: TextStyle(fontSize: 40, color: Colors.black),
                    ),
                  ),
                  FutureBuilder<List<DataModel>>(
                    future: dataProvider.getdata(),
                    builder: (BuildContext context, snapshot) {
                      if (snapshot.hasError) {
                        return Text("Something went wrong");
                      }

                      if (snapshot.hasData) {
                        return ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              DataModel data = snapshot.data![index];

                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              width: 2, color: Colors.grey))),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Weight : ${data.weight}",
                                              style: TextStyle(
                                                fontSize: 18,
                                              ),
                                            ),
                                            Text(
                                              "Date : ${DateFormat.yMMMd().format(DateTime.tryParse(data.date!)!.toUtc())}",
                                              style: TextStyle(
                                                fontSize: 18,
                                              ),
                                            ),
                                          ]),
                                      Row(
                                        children: [
                                          GestureDetector(
                                              onTap: () {
                                                weight.clear();
                                                showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return Dialog(
                                                          child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(20.0),
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            Text(
                                                              "Edit Data",
                                                              style: TextStyle(
                                                                  fontSize: 22,
                                                                  color: AppColor
                                                                      .primaryColor),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .symmetric(
                                                                      vertical:
                                                                          10),
                                                              child:
                                                                  TextBoxAccounts(
                                                                boxHint:
                                                                    "Enter New Weight",
                                                                obsecure: false,
                                                                controller:
                                                                    weight,
                                                                keyboardType:
                                                                    TextInputType
                                                                        .number,
                                                              ),
                                                            ),
                                                            SingleActionButton(
                                                                buttonName:
                                                                    "Save",
                                                                onPressed: () {
                                                                  if (weight.text ==
                                                                          null ||
                                                                      weight.text ==
                                                                          "" ||
                                                                      weight
                                                                          .text
                                                                          .isEmpty) {
                                                                    Fluttertoast
                                                                        .showToast(
                                                                            msg:
                                                                                "Enter Weight");
                                                                  } else {
                                                                    Navigator.pop(
                                                                        context);
                                                                    dataProvider.editData(
                                                                        data
                                                                            .id!,
                                                                        weight
                                                                            .text);
                                                                  }
                                                                })
                                                          ],
                                                        ),
                                                      ));
                                                    });
                                              },
                                              child: Icon(Icons.edit)),
                                          SizedBox(
                                            width: 15,
                                          ),
                                          GestureDetector(
                                              onTap: () {
                                                dataProvider
                                                    .deleteData(data.id!);
                                              },
                                              child: Icon(Icons.cancel)),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            });
                      }

                      if (snapshot.connectionState == ConnectionState.done) {
                        return SizedBox();
                      } else {
                        return SizedBox();
                      }
                    },
                  ),
                ],
              ),
      );
    });
  }
}
