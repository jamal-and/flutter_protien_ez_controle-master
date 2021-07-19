import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_protien_ez_controle/models/data.dart';


class EditWeightDialog extends StatefulWidget {
  @override
  _EditWeightDialogState createState() => _EditWeightDialogState();
}

class _EditWeightDialogState extends State<EditWeightDialog> {
  @override
  Widget build(BuildContext context) {
    int mv;
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
              'Edit your wight',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 10,),
            TextField(
                onChanged: (v) {
                  // Provider.of<Data>(context).proteinWillBeAdded = int.parse(v);
                  mv = int.parse(v);
                },
                style: TextStyle(fontSize: 20),
                cursorColor: Color(0xff70E1F1),
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: 'Your new weight here',
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xfff27095)),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xfff27095)),
                  ),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xfff27095)),
                  ),
                )),
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  style: TextButton.styleFrom(primary: Color(0xfff27095)),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('cancel'),
                ),
                GestureDetector(
                  onTap: () async {
                    //showBigPictureNotification();
                    //showNotification();
                    if (mv != null) {
                      await Provider.of<Data>(context, listen: false)
                          .editWeight(mv);
                      Navigator.pop(context);
                    } else {
                      final snackBar = SnackBar(
                          content: Text('You forgot put a number!'));
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }

                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color(0xfff27095),),
                    child: Text('Change', style: TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w600),),
                  ),
                ),
                // ElevatedButton(
                //   style: ElevatedButton.styleFrom(primary: Color(0xfff27095)),
                //   onPressed: () {
                //     if(mv!=null) {
                //       Provider.of<Data>(context,listen: false).addProtein(mv);
                //       Navigator.pop(context);
                //     }else{
                //       final snackBar = SnackBar(content: Text('You forgot put a number!'));
                //       ScaffoldMessenger.of(context).showSnackBar(snackBar);
                //     }
                //   },
                //   child: Text('Add'),
                // ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

