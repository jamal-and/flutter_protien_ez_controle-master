import 'package:flutter/material.dart';
import 'package:flutter_protien_ez_controle/models/colors.dart';
import 'package:provider/provider.dart';
import 'package:flutter_protien_ez_controle/models/data.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
class EditNameDialog extends StatefulWidget {
  @override
  _EditNameDialogState createState() => _EditNameDialogState();
}

class _EditNameDialogState extends State<EditNameDialog> {
  String us='';
  TextEditingController controller=TextEditingController();
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    us=Provider.of<Data>(context,listen: false).userName??'';
    controller=TextEditingController(text: us);
  }
  @override
  Widget build(BuildContext context) {

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
              'Edit your Name',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24,color: MyColors.textColor),
            ),
            SizedBox(height: 10,),
            TextField(
              maxLength: 18,
              controller: controller,

              onChanged: (v) {
                // Provider.of<Data>(context).proteinWillBeAdded = int.parse(v);
                //mv = int.parse(v);
              },
              style: TextStyle(fontSize: 20,color: MyColors.textColor),
              cursorColor: MyColors.accentColor,
              keyboardType: TextInputType.name,
              textAlign: TextAlign.center,

              decoration: InputDecoration(

                hintText: 'Your name here',
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: MyColors.accentColor),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: MyColors.accentColor),
                ),
                border: UnderlineInputBorder(
                    borderSide: BorderSide(color: MyColors.accentColor,)),
              ),
            ),
            SizedBox(height: 10,),
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
                    if (controller.text != null &&controller.text.isNotEmpty) {

                      await Provider.of<Data>(context, listen: false).setName(controller.text);
                     // await Provider.of<Data>(context, listen: false).setGoal(mv);
                      Navigator.pop(context);
                    } else {
                      showTopSnackBar(
                        context,
                        CustomSnackBar.error(
                          message:
                          "Please enter your name!",
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

