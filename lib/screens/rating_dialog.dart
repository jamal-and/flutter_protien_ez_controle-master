import 'package:flutter/material.dart';
import 'package:flutter_protien_ez_controle/models/colors.dart';
import 'package:rating_dialog/rating_dialog.dart';
import 'package:rate_my_app/rate_my_app.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class MyRatingDialog extends StatelessWidget {
  const MyRatingDialog({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RatingDialog(
      initialRating: 2,
      starSize: 30,
      enableComment: false,
      // your app's name?
      title: Text('Protein Tracker'),
      // encourage your user to leave a high rating?
      message: Text(
          'Your review will help us very much to get a good rank on Google Play, thank you very much for your time'),
      // your app's logo?

      submitButtonText: 'Submit',
      onCancelled: () => print('cancelled'),
      onSubmitted: (response) async {
        if (response.rating < 4.0) {
          showTopSnackBar(
            context,
            CustomSnackBar.success(
              message: "Thank you for taking time to write this review, ",
            ),
          );

          // send their comments to your email or anywhere you wish
          // ask the user to contact you instead of leaving a bad review
        } else {
          RateMyApp rateMyApp = RateMyApp(
            preferencesPrefix: 'rateMyApp_',
            googlePlayIdentifier: 'com.jamal.protein',
          );
          rateMyApp.launchStore();
        }
      },
    );
  }
}
