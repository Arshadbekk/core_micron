import 'package:awesome_bottom_bar/awesome_bottom_bar.dart';
import 'package:core_micron/core/utils.dart';
import 'package:core_micron/features/home/controller/home_controller.dart';
import 'package:core_micron/features/home/screens/new_card_entry.dart';
import 'package:core_micron/features/home/screens/progress_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../main.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {


  List pages=[
    NewCardEntry(),
    ProgressCard()

  ];
  int visit=0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("CMIS",style: TextStyle(
          color: Colors.white
        ),),
        backgroundColor: Colors.black,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                _showPopUp(context);
              },
              child: Row(
                children: [
                  Text("Employee",style: TextStyle(
                    color: Colors.white,
                    fontSize: w*0.04
                  ),),
                  Icon(Icons.add,color: Colors.white,)
                ],
              ),
            ),
          ),

        ],
      ),
      body: pages[visit],
      bottomNavigationBar: BottomBarDefault(

        items: [
          TabItem(icon: Icons.add, title: "New Card Entry"),
          TabItem(icon: Icons.category_outlined, title: "Progress Card"),

        ],
        backgroundColor: Colors.white,
        color: Colors.grey,
        colorSelected: Colors.red,
        indexSelected: visit,
        onTap: (index) {
          visit=index;
          setState(() {

          });
          print(visit);
        },
      ),
    );
  }
}
void _showPopUp(BuildContext context) {
  TextEditingController nameController = TextEditingController();
  TextEditingController noController = TextEditingController();
  showDialog(
    context: context,
    builder: (context) {
      void addEmployee({required WidgetRef ref,required String name,required int phone}){
        ref.read(homeControllerProvider.notifier).addEmployee(name: name, phone: phone, context: context);
      }
      return AlertDialog(
        title: Text("Add Employee"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
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
              controller: noController,
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
               if(nameController.text.isEmpty){
                 showSnackBar(context, "Enter name");
               }else if(noController.text.isEmpty){
                 showSnackBar(context, "Enter Number");
               }else{
                 addEmployee(ref: ref, name: nameController.text.trim(), phone: int.parse(noController.text.trim()));

               }
             },
             child: Container(
               height: w*0.13,
               width: w*0.4,
               decoration: BoxDecoration(
                   color: Colors.black,
                   borderRadius: BorderRadius.circular(w*0.03)
               ),
               child: Center(child: Text("Add",style: TextStyle(color: Colors.white,fontSize: w*0.07),)),
             ),
           ),
         )),
          ],
        ),
      );
    },
  );
}