import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/colors.dart';

class DeactivePop extends StatelessWidget {
  const DeactivePop(BuildContext context, {super.key});

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
            const AutoSizeText(
              "Are You Sure You Want To Deactivate your Account",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: popUpRedColor
              ),
              maxLines: 2,
              textAlign: TextAlign.center,
            ),

            SizedBox(
              height: 20,
            ),

            Container(
              alignment: Alignment.center,
              child: const AutoSizeText(
                "This Action Cannot Be Undone!",
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: popUpGrayColor
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
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
                      onPressed: () {Get.back(result: 500);},
                      child: const AutoSizeText(
                        "Cancel",
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: popUpGrayColor,
                          fontSize: 14,
                        ),
                        maxLines: 1,
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
                        Get.back(result: 200);
                      }, // Use the provided onPressed callback
                      child: const AutoSizeText(
                        "Delete",
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            color: white,
                            fontSize: 14
                        ),
                        maxLines: 1,
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
