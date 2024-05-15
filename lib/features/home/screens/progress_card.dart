import 'package:core_micron/core/error_text.dart';
import 'package:core_micron/core/loader.dart';
import 'package:core_micron/features/home/controller/home_controller.dart';
import 'package:core_micron/model/employee_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../main.dart';

class ProgressCard extends StatefulWidget {
  const ProgressCard({super.key});

  @override
  State<ProgressCard> createState() => _ProgressCardState();
}

class _ProgressCardState extends State<ProgressCard> {
  void editEmployee(
      {required WidgetRef ref,
      required String id,
      required EmployeeModel employeeModel}) {
    ref
        .read(homeControllerProvider.notifier)
        .editEmployee(id: id, employeeModel: employeeModel, context: context);
  }

  void delete({required WidgetRef ref,required String id}){
    ref.read(homeControllerProvider.notifier).deleteEmployee(id: id, context: context);
  }
  TextEditingController nameController =TextEditingController();
  TextEditingController numberController =TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Consumer(
            builder: (context, ref, child) {
              return ref.watch(getEmployeesProvider).when(
                    data: (data) {
                      return ListView.separated(
                        itemBuilder: (context, index) => ListTile(
                          tileColor: Colors.grey.shade100,
                          leading: Text(
                            "SNo:${index + 1}",
                            style: TextStyle(fontSize: w * 0.04),
                          ),
                          subtitle: Text("Phone No: ${data[index].phone}"),
                          title: Text(data[index].name.toString()),
                          style: ListTileStyle.list,
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  nameController.text = data[index].name!;
                                  numberController.text = data[index].phone!.toString();
                               showDialog(
                                   context: context,
                                   builder: (context) => AlertDialog(
                                     title: Text("Edit Employee"),
                                     content:  Column(
                                       mainAxisSize: MainAxisSize.min,
                                       children: [
                                         TextField(
                                           controller: nameController,
                                           decoration: const InputDecoration(
                                               label: Text('Employee Name'),
                                               focusedBorder: OutlineInputBorder(
                                                   borderSide: BorderSide(color: Colors.black)
                                               ),
                                               enabledBorder: OutlineInputBorder(
                                                   borderSide: BorderSide(color: Colors.black)

                                               )
                                           ),
                                         ),
                                         SizedBox(
                                           height: w*0.02,
                                         ),
                                         TextField(
                                           controller: numberController,
                                           maxLength: 10,
                                           keyboardType: TextInputType.number,
                                           decoration: InputDecoration(
                                               label: Text('Phone Number'),
                                               focusedBorder: OutlineInputBorder(
                                                   borderSide: BorderSide(color: Colors.black)
                                               ),
                                               enabledBorder: OutlineInputBorder(
                                                   borderSide: BorderSide(color: Colors.black)

                                               )
                                           ),
                                         ),
                                         Consumer(builder: (context, ref, child) =>    Padding(
                                           padding:  EdgeInsets.only(top: w*0.04),
                                           child: GestureDetector(
                                             onTap: () {
                                                    editEmployee(ref: ref, id: data[index].id!, employeeModel: data[index].copyWith(
                                                      name: nameController.text,
                                                      phone: int.parse(numberController.text.trim())
                                                    ));
                                             },
                                             child: Container(
                                               height: w*0.13,
                                               width: w*0.4,
                                               decoration: BoxDecoration(
                                                   color: Colors.black,
                                                   borderRadius: BorderRadius.circular(w*0.03)
                                               ),
                                               child: Center(child: Text("Update",style: TextStyle(color: Colors.white,fontSize: w*0.07),)),
                                             ),
                                           ),
                                         )),
                                       ],
                                     ),
                                   ),
                               );
                                },
                                child: Icon(
                                  Icons.edit,
                                  color: Colors.blue,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  delete(ref: ref, id: data[index].id!);
                                },
                                child: Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
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
          )
        ],
      ),
    );
  }
}
