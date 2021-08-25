import 'package:flutter/material.dart';
import 'package:flutter_protien_ez_controle/models/colors.dart';
import 'package:provider/provider.dart';
import 'package:flutter_protien_ez_controle/models/data.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class AddProteinDateDialog extends StatefulWidget {
  AddProteinDateDialog(this.date);
  final String date;
  @override
  _AddProteinDateDialogState createState() => _AddProteinDateDialogState();
}

class _AddProteinDateDialogState extends State<AddProteinDateDialog> {
  @override
  Widget build(BuildContext context) {
    int mv;
    String day;
    switch(DateTime.parse(widget.date).weekday){
      case 1:day= 'Monday';break;
      case 2:day= 'Tuesday';break;
      case 3:day= 'Wednesday';break;
      case 4:day= 'Thursday';break;
      case 5:day= 'Friday';break;
      case 6:day= 'Saturday';break;
      case 7:day= 'Sunday';break;

    }
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
              'Add protein for $day',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24,color: MyColors.textColor),
            ),
            SizedBox(height: 10,),
            TextField(
              maxLength: 3,

              onChanged: (v) {
                // Provider.of<Data>(context).proteinWillBeAdded = int.parse(v);
                mv = int.parse(v);
              },
              style: TextStyle(fontSize: 20,color: MyColors.textColor),
              cursorColor: MyColors.accentColor,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                counterText: '',
                hintText: 'Protein amount in g',
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
                    if (mv != null && mv>0) {
                      await Provider.of<Data>(context, listen: false)
                          .addProteinWithDate(mv,widget.date);
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
                    child: Text('ADD', style: TextStyle(
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

