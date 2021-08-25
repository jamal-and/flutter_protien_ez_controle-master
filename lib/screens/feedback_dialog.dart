import 'package:flutter/material.dart';
import 'package:flutter_protien_ez_controle/models/colors.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'dart:io';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
class SendFeedBackDialog extends StatefulWidget {
  @override
  _SendFeedBackDialogState createState() => _SendFeedBackDialogState();
}

class _SendFeedBackDialogState extends State<SendFeedBackDialog> {
  TextEditingController controller=TextEditingController();

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
              'Feedback',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24,color: MyColors.textColor),
            ),
            SizedBox(height: 10,),
            TextField(
              textAlign: TextAlign.center,
              autofocus: true,
              maxLength: 400,
              minLines: 2,
              maxLines: 7,
              controller: controller,
              onChanged: (v) {
                // Provider.of<Data>(context).proteinWillBeAdded = int.parse(v);
                //mv = int.parse(v);
              },
              style: TextStyle(fontSize: 20,color: MyColors.textColor),
              cursorColor: MyColors.accentColor,
              keyboardType: TextInputType.multiline,

              decoration: InputDecoration(
                hintText: 'Your Message here...',
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
                    if (controller.text != null &&controller.text.isNotEmpty) {
                      try {
                        final result = await InternetAddress.lookup('google.com');
                        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
                          print('connected');
                        }
                      } on SocketException catch (_) {
                        showTopSnackBar(
                          context,
                          CustomSnackBar.error(
                            message:
                            "No Internet. Please check your internet connection and try again",
                          ),
                        );
                        return;
                      }
                      String username = 'tracker.protein@gmail.com';
                      String password = 'Protein771';

                      final smtpServer = gmail(username, password);
                      // Use the SmtpServer class to configure an SMTP server:
                      // final smtpServer = SmtpServer('smtp.domain.com');
                      // See the named arguments of SmtpServer for further configuration
                      // options.

                      // Create our message.
                      final message = Message()
                        ..from = Address(username, 'User Name')
                        ..recipients.add('jamal2011922@gmail.com')
                        ..subject = 'Protein Tracker App Feedback'
                        ..text = 'This is the plain text.\nThis is line 2 of the text part.'
                        ..html = "<h1>FeedBack from user</h1>\n<p>${controller.text}</p>";
                      try {
                        final sendReport = await send(message, smtpServer);
                        print('Message sent: ' + sendReport.toString());
                        showTopSnackBar(
                          context,
                          CustomSnackBar.success(
                            message:
                            "Feedback sent successfully!",
                          ),
                        );
                      } on MailerException catch (e) {
                        print('Message not sent. $e');
                        showTopSnackBar(
                          context,
                          CustomSnackBar.error(
                            message:
                            "Feedback sent failed, please try again later",
                          ),
                        );
                        for (var p in e.problems) {
                          print('Problem: ${p.code}: ${p.msg}');
                        }
                      }
                      Navigator.pop(context);
                    } else {
                      showTopSnackBar(
                        context,
                        CustomSnackBar.error(
                          message:
                          "Empty Feedback!. Please fill your feedback",
                        ),
                      );
                    }

                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: MyColors.accentColor,),
                    child: Text('Send', style: TextStyle(
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

