import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_protien_ez_controle/models/colors.dart';
import 'package:flutter_protien_ez_controle/models/data.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:provider/provider.dart';
import 'package:rating_dialog/rating_dialog.dart';
import 'package:rate_my_app/rate_my_app.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:mailer/mailer.dart';
class MyRatingDialog extends StatelessWidget {
  const MyRatingDialog({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var myProvider = Provider.of<Data>(context);
    String username = 'tracker.protein@gmail.com';
    String password = 'Protein771';
    final smtpServer = gmail(username, password);
    return RatingDialog(
      initialRating: 2,
      textColor: MyColors.textColor,
      enableComment: false,
      // your app's name?
      title: 'Protein Tracker',
      // encourage your user to leave a high rating?
      message:
      'Your review will help us very much to get a good rank on Google Play, thank you very much for your time',
      // your app's logo?

      submitButton: 'Submit',
      onCancelled: () => print('cancelled'),
      onSubmitted: (response) async {
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
        print('rating: ${response.rating}, comment: ${response.comment}');
        final message = Message()
          ..from = Address(username, '${myProvider.userName ?? 'User Name'}')
          ..recipients.add('jamal2011922@gmail.com')
          ..subject =
              'Protein Tracker App Review from ${myProvider.userName ?? 'User Name'}'
          ..text = 'This is the plain text.\nThis is line 2 of the text part.'
          ..html =
              "<h1>${response.rating} Star\\s</h1>\n<p>${response.comment}</p>";
        if (response.rating < 4.0) {
          showTopSnackBar(
            context,
            CustomSnackBar.success(
              message: "Thank you for taking time to write this review, ",
            ),
          );
          try {
            final sendReport = await send(message, smtpServer);
            print('Message sent: ' + sendReport.toString());
          } on MailerException catch (e) {
            print('Message not sent. $e');
            for (var p in e.problems) {
              print('Problem: ${p.code}: ${p.msg}');
            }
          }
          // send their comments to your email or anywhere you wish
          // ask the user to contact you instead of leaving a bad review
        } else {
          RateMyApp rateMyApp = RateMyApp(
            preferencesPrefix: 'rateMyApp_',
            googlePlayIdentifier: 'com.jamal.protein',
          );
          rateMyApp.launchStore();
          try {
            final sendReport = await send(message, smtpServer);
            print('Message sent: ' + sendReport.toString());
          } on MailerException catch (e) {
            print('Message not sent. $e');
            for (var p in e.problems) {
              print('Problem: ${p.code}: ${p.msg}');
            }
          }
        }
      },
    );
  }
}
