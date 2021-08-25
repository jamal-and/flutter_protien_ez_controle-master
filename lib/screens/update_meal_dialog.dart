import 'package:flutter/material.dart';
import 'package:flutter_protien_ez_controle/models/colors.dart';
import 'package:provider/provider.dart';
import 'package:flutter_protien_ez_controle/models/data.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
class UpdateMealDialog extends StatefulWidget {
  UpdateMealDialog({this.text,this.hour,this.date,this.number});
  @override
  _UpdateMealDialogState createState() => _UpdateMealDialogState();
  final String text;
  final String hour;
  final String date;
  final int number;
}

class _UpdateMealDialogState extends State<UpdateMealDialog> {
  String us='';
  TextEditingController numberController;
  TextEditingController textController;
  @override
  void initState() {
    super.initState();
    numberController=TextEditingController(text: widget.number.toString());
    textController=TextEditingController(text: widget.text.toString());
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
              'Update this meal',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24,color:MyColors.textColor),
            ),
            SizedBox(height: 16,),
            TextField(
              maxLength: 3,
              controller: numberController,

              onChanged: (v) {
                // Provider.of<Data>(context).proteinWillBeAdded = int.parse(v);
                //mv = int.parse(v);
              },
              style: TextStyle(fontSize: 20,color: MyColors.textColor),
              cursorColor: MyColors.accentColor,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,

              decoration: InputDecoration(
                labelText: 'Protein with gram',
                counterText: '',
                labelStyle: TextStyle(color:MyColors.accentColor ),

                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: MyColors.accentColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: MyColors.accentColor,),
                ),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: MyColors.accentColor,)),
              ),
            ),
            SizedBox(height: 10,),
            TextField(
              maxLength: 30,
              controller: textController,

              onChanged: (v) {
                // Provider.of<Data>(context).proteinWillBeAdded = int.parse(v);
                //mv = int.parse(v);
              },
              style: TextStyle(fontSize: 20,color: MyColors.textColor),
              cursorColor: MyColors.accentColor,
              keyboardType: TextInputType.name,
              textAlign: TextAlign.center,

              decoration: InputDecoration(

                labelText: 'Food Name',

                labelStyle: TextStyle(color:MyColors.accentColor ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: MyColors.accentColor,),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: MyColors.accentColor,),
                ),
                border: OutlineInputBorder(

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
                    if (numberController.text != null &&numberController.text.isNotEmpty &&int.parse(numberController.text)>0) {
                      await Provider.of<Data>(context, listen: false).updateSingleProtein(
                          number:int.parse(numberController.text),
                      text: textController.text.isNotEmpty?textController.text:'No food name',
                      hour: widget.hour,
                      date: widget.date);
                      // await Provider.of<Data>(context, listen: false).setGoal(mv);
                      Navigator.pop(context);
                    } else {
                      showTopSnackBar(
                        context,
                        CustomSnackBar.error(
                          message:
                          "Please enter valid protein value!",
                        ),
                      );
                    }

                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: MyColors.accentColor,),
                    child: Text('update', style: TextStyle(
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

