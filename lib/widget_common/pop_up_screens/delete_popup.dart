import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/colors.dart';

class DeletePopScreen extends StatelessWidget {
  const DeletePopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(

      backgroundColor: Colors.white,
      //title: const Text('Popup example'),
      content: Container(
        width: 480,
        height: 360,
       // decoration: BoxDecoration(color: white),
        child: Column(
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            Container(
                width: 120,
                height: 120,
                child: Image.asset("assets/images/deactivate_pop_img.png")),

            SizedBox(
              height: 20,
            ),
            Text(
              "Are You Sure You Want To delete ?",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: popUpRedColor
              ),
            ),

            SizedBox(
              height: 20,
            ),

            Container(
              alignment: Alignment.topLeft,
              child: Text(
                "This Action Can Be Undone. (within 30 days! - if not overwritten)",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: popUpGrayColor
                ),
              ),
            ),

            SizedBox(
              height: 20,
            ),

            Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 115,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding:
                          const EdgeInsets.symmetric(vertical: 10, horizontal: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      side: const BorderSide(
                        color: popUpGrayColor,
                        width: 1,
                      ),
                    ),
                    onPressed: () {
                      Get.back(result: false);
                    },
                    child: const Text(
                      "Cancel",
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        color: popUpGrayColor,
                        
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                
                Container(
                  width: 115,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: popUpRedColor,
                      elevation: 0.1,
                      padding:
                          const EdgeInsets.symmetric(vertical: 10, horizontal: 7),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      Get.back(result: true);
                    }, // Use the provided onPressed callback
                    child: const Text(
                      "Delete",
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: white,
                          fontSize: 14),
                    ),
                  ),
                ),
          
                
                
              ],
            ),
          ),


          ],
        ),
      ),
    );
  }
}