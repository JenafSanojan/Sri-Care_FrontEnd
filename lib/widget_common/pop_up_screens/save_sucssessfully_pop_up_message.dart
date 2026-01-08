import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/colors.dart';

class SaveSuccessFullyPopUp extends StatelessWidget {
  const SaveSuccessFullyPopUp({Key? key}) : super(key: key);

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
                child: Image.asset("assets/images/user_added_successfully_img.png")),

            SizedBox(
              height: 20,
            ),
            Text(
              "Saved Successfully!",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: popUpGreenColor
              ),
            ),

            SizedBox(
              height: 20,
            ),



            SizedBox(
              height: 20,
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
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
                        Get.back(result: 200);
                      },
                      child: const Text(
                        "Close",
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: popUpGrayColor,

                          fontSize: 14,
                        ),
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
