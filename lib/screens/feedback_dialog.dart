import 'package:flutter/material.dart';
import 'package:flutter_protien_ez_controle/models/colors.dart';
import 'package:flutter_protien_ez_controle/models/data.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

class SendFeedBackDialog extends StatefulWidget {
  @override
  _SendFeedBackDialogState createState() => _SendFeedBackDialogState();
}

class _SendFeedBackDialogState extends State<SendFeedBackDialog> {
  TextEditingController controller=TextEditingController();
  TextEditingController emailController=TextEditingController();
  bool isLoading=false;
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    emailController=TextEditingController(text: Provider.of<Data>(context,listen: false).userName);
  }
  launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  String encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }


  _launchURLMail({@required String name,@required String body}) async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'tracker.protein@gmail.com',
      query: encodeQueryParameters(<String, String>{
        'subject': 'From $name',
        'body':'$body'
      }),
    );
    // var url =
    //     "mailto:tracker.protein@gmail.com?subject=From $name&body=$body";
    if (await canLaunch(emailLaunchUri.toString())) {
      await launch(emailLaunchUri.toString());
    } else {
      throw 'Could not launch ${emailLaunchUri.toString()}';
    }
  }
  String name;
  String body;
  @override
  Widget build(BuildContext context) {


    return isLoading?
    Center(
      child: Container(
        height: 100,
        child: LoadingIndicator(
            indicatorType: Indicator.ballZigZag , /// Required, The loading type of the widget
            colors:  [MyColors.accentColor,MyColors.fireColor],       /// Optional, The color collections
            strokeWidth: 2,                     /// Optional, The stroke of the line, only applicable to widget which contains line
  /// Optional, the stroke backgroundColor
        ),
      )
    ):AlertDialog(
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
              style: TextStyle(fontSize: 24,color: MyColors.textColor,fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8,),
            Text(
              'Thank you for your time to write this feedback',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14,color: MyColors.textColor.withOpacity(0.8)),
            ),
            SizedBox(height: 8,),
            TextField(
              textAlign: TextAlign.center,
              maxLength: 100,


              controller: emailController,
              onChanged: (v) {
                name=v;
              },
              style: TextStyle(fontSize: 16,color: MyColors.textColor),
              cursorColor: MyColors.accentColor,
              keyboardType: TextInputType.emailAddress,


              decoration: InputDecoration(
                labelStyle: TextStyle(color:MyColors.accentColor ),
                contentPadding: EdgeInsets.symmetric(vertical: 0,horizontal: 12),
                counterText: '',
                labelText: 'Name',
                hintText: 'what we should call you',
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
            SizedBox(height: 8,),
            TextField(
              textAlign: TextAlign.center,
              autofocus: true,
              maxLength: 400,
              minLines: 3,
              maxLines: 7,
              controller: controller,
              onChanged: (v) {
                // Provider.of<Data>(context).proteinWillBeAdded = int.parse(v);
                //mv = int.parse(v);
                body=v;
              },
              style: TextStyle(fontSize: 16,color: MyColors.textColor),
              cursorColor: MyColors.accentColor,
              keyboardType: TextInputType.multiline,

              decoration: InputDecoration(
                labelText: 'Message',labelStyle: TextStyle(color:MyColors.accentColor ),
                contentPadding: EdgeInsets.symmetric(vertical: 16,horizontal: 12),

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
                    if (controller.text != null &&controller.text.isNotEmpty &&emailController.text.isNotEmpty &&emailController.text!=null) {
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
                      _launchURLMail(name: name, body: body);
                    //   try {
                    //     setState(() {
                    //       isLoading=true;
                    //     });
                    //
                    //   } on MailerException catch (e) {
                    //     print('Message not sent. $e');
                    //     showTopSnackBar(
                    //       context,
                    //       CustomSnackBar.error(
                    //         message:
                    //         "Feedback sent failed, please try again later",
                    //       ),
                    //     );
                    //     for (var p in e.problems) {
                    //       print('Problem: ${p.code}: ${p.msg}');
                    //     }
                    //   }
                    //   Navigator.pop(context);
                    // } else {
                    //   showTopSnackBar(
                    //     context,
                    //     CustomSnackBar.error(
                    //       message:
                    //       "Empty Feedback!. Please fill your feedback",
                    //     ),
                    //   );
                    }else{
                      showTopSnackBar(context, CustomSnackBar.error(
                        message:
                        "Your Name and message can't be empty",
                      ),);
                      return;
                    }
                  Navigator.pop(context);
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

