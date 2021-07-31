import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_protien_ez_controle/models/data.dart';

class EditNameDialog extends StatefulWidget {
  @override
  _EditNameDialogState createState() => _EditNameDialogState();
}

class _EditNameDialogState extends State<EditNameDialog> {
  TextEditingController controller=TextEditingController();

  @override
  Widget build(BuildContext context) {

    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)
      ),
      backgroundColor: Color(0xff243c5e),
      content: Container(

        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(height: 10,),
            Text(
              'Edit your Name',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 10,),
            TextField(
              maxLength: 18,
              controller: controller,
              onChanged: (v) {
                // Provider.of<Data>(context).proteinWillBeAdded = int.parse(v);
                //mv = int.parse(v);
              },
              style: TextStyle(fontSize: 20),
              cursorColor: Color(0xff70E1F1),
              keyboardType: TextInputType.name,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: 'Your name here',
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xff70E1F1),),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xff70E1F1),),
                ),
                border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xff70E1F1),)),
              ),
            ),
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  style: TextButton.styleFrom(primary: Color(0xff70E1F1),),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('cancel'),
                ),
                GestureDetector(
                  onTap: () async {
                    //showBigPictureNotification();
                    //showNotification();
                    if (controller.text != null) {

                      await Provider.of<Data>(context, listen: false).setName(controller.text);
                     // await Provider.of<Data>(context, listen: false).setGoal(mv);
                      Navigator.pop(context);
                    } else {
                      final snackBar = SnackBar(
                          content: Text('You forgot put a name!'));
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }

                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color(0xff70E1F1),),
                    child: Text('Change', style: TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w600,color: Color(0xff223D5D)),),
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

