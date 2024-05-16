import 'package:core_micron/core/error_text.dart';
import 'package:core_micron/core/loader.dart';
import 'package:core_micron/features/home/controller/home_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../main.dart';

class NewCardEntry extends StatefulWidget {
  const NewCardEntry({super.key});

  @override
  State<NewCardEntry> createState() => _NewCardEntryState();
}

class _NewCardEntryState extends State<NewCardEntry> {
  bool search = false;
  var selectedMonth;
  DateTime dateTime = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Consumer(
            builder: (context, ref, child) {
              return ref.watch(getMonthProvider).when(
                    data: (data) {
                      print(data);
                      return Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                                height: w * 0.16,
                                width: w * 0.5,
                                child: DropdownButtonFormField(
                                  value: selectedMonth,
                                  decoration: InputDecoration(
                                      focusedBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.black),
                                          borderRadius:
                                              BorderRadius.circular(w * 0.01)),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.black),
                                          borderRadius:
                                              BorderRadius.circular(w * 0.01)),
                                      hintText: "Choose Month"),
                                  items: List.generate(
                                      data.length,
                                      (index) => DropdownMenuItem(
                                            child: Text(data[index]),
                                            value: data[index],
                                          )),
                                  onChanged: (value) {
                                    selectedMonth = value;
                                    print(selectedMonth);
                                    DateFormat format = DateFormat("MMMM yyyy");

                                    dateTime = format.parse(selectedMonth);
                                    print(dateTime);
                                  },
                                )),
                          ),
                          GestureDetector(
                            onTap: () {
                              search = true;
                              setState(() {});
                            },
                            child: Container(
                              height: w * 0.1,
                              width: w * 0.4,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(w * 0.02),
                                  color: Color(0xff022E44)),
                              child: Center(
                                child: Text(
                                  "Search",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: w * 0.04),
                                ),
                              ),
                            ),
                          )
                        ],
                      );
                    },
                    error: (error, stackTrace) =>
                        ErrorText(error: error.toString()),
                    loading: () => loader(),
                  );
            },
          ),
        search==true?  Consumer(
            builder: (context, ref, child) {
              print("datetime --$dateTime");
              return ref.watch(getEmployeeByMonthProvider(dateTime)).when(
                    data: (data) {
                      print("------------------");
                      print(data);
                      return data.isEmpty
                          ? Text("No data")
                          : ListView.separated(
                              itemBuilder: (context, index) => ListTile(
                                tileColor: Colors.grey.shade100,
                                leading: Text(
                                  "SNo:${index + 1}",
                                  style: TextStyle(fontSize: w * 0.04),
                                ),
                                subtitle:
                                    Text("Phone No: ${data[index].phone}"),
                                title: Text(data[index].name.toString()),
                                style: ListTileStyle.list,
                              ),
                              separatorBuilder: (context, index) => SizedBox(
                                height: w * 0.02,
                              ),
                              itemCount: data.length,
                              shrinkWrap: true,
                            );
                    },
                    error: (error, stackTrace) =>
                        ErrorText(error: error.toString()),
                    loading: () => loader(),
                  );
            },
          ):Text("No data Found")
        ],
      ),
    );
  }
}
