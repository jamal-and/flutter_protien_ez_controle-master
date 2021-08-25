import 'package:flutter/material.dart';
import 'package:flutter_protien_ez_controle/models/colors.dart';
import 'package:provider/provider.dart';
import 'package:flutter_protien_ez_controle/models/data.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class EditGoalDialog extends StatefulWidget {
  @override
  _EditGoalDialogState createState() => _EditGoalDialogState();
}

class _EditGoalDialogState extends State<EditGoalDialog> {
  @override
  Widget build(BuildContext context) {
    int mv;
    TextEditingController controller=TextEditingController();
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)
      ),
      backgroundColor: MyColors.background,
      content: Container(

        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(height: 10,),
            Text(
              'Edit your goal',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24,color: MyColors.textColor),
            ),
            SizedBox(height: 10,),
            TextField(
              controller: controller,
              maxLength: 3,

                onChanged: (v) {
                  // Provider.of<Data>(context).proteinWillBeAdded = int.parse(v);
                  mv = int.parse(v);
                },
                style: TextStyle(fontSize: 20,color: MyColors.textColor ),
                cursorColor: MyColors.accentColor,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  counterText: '',
                  hintText: 'Your new goal here',
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: MyColors.accentColor,),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: MyColors.accentColor,),
                  ),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: MyColors.accentColor,)),
                  ),
                ),
            SizedBox(height: 10,),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                style: TextButton.styleFrom(primary: MyColors.accentColor,),
                onPressed: () async{
                  controller.text=await Provider.of<Data>(context, listen: false).getDefaultGoal();
                },
                child: Text('Default'),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  style: TextButton.styleFrom(primary: MyColors.accentColor,),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('cancel'),
                ),
                GestureDetector(
                  onTap: () async {
                    //showBigPictureNotification();
                    //showNotification();
                    if (controller.text != null&& int.parse(controller.text)>0) {
                      await Provider.of<Data>(context, listen: false)
                          .setGoal(int.parse(controller.text));
                      Navigator.pop(context);
                    } else {
                      showTopSnackBar(
                        context,
                        CustomSnackBar.error(
                          message:
                          "Please enter valid goal!",
                        ),
                      );
                    }

                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: MyColors.accentColor,),
                    child: Text('Change', style: TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w600,color: Colors.black87),),
                  ),
                ),

              ],
            )
          ],
        ),
      ),
    );
  }
}

