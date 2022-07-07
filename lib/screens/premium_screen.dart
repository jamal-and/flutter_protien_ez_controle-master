import 'package:flutter/material.dart';
import 'package:flutter_protien_ez_controle/models/colors.dart';
import 'package:flutter_protien_ez_controle/models/data.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:provider/provider.dart';

class PremiumScreen extends StatefulWidget {
  static String id = 'premiumscreen';

  const PremiumScreen({Key key}) : super(key: key);

  @override
  _PremiumScreenState createState() => _PremiumScreenState();
}

class _PremiumScreenState extends State<PremiumScreen>
    with SingleTickerProviderStateMixin {
  void _buyProduct(ProductDetails prod) {
    InAppPurchaseConnection _iap = InAppPurchaseConnection.instance;
    final PurchaseParam purchaseParam = PurchaseParam(productDetails: prod);
    _iap
        .buyNonConsumable(purchaseParam: purchaseParam)
        .then((value) => setState(() {}));
  }

  double _height = 40;
  double _width = 300;
  void _updateState() {
    setState(() {
      _width = MediaQuery.of(context).size.width * 0.9;
      _height = null;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(milliseconds: 000)).then((value) => _updateState());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: Provider.of<Data>(context).darkTheme
            ? ThemeData.dark().iconTheme
            : ThemeData.light().iconTheme,

        title: Text(
          'Premium Features',
          style: TextStyle(color: MyColors.textColor),
        ),
        elevation: 0,
        backgroundColor:
            Colors.transparent, //Colors.indigo,//Color(0xff0E284C),
      ),
      backgroundColor: MyColors.background,
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //SizedBox(height: 16,),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  decoration: BoxDecoration(
                      color: MyColors.textColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8)),
                  child: Text(
                    'MOST POPULAR',
                    style: TextStyle(
                        color: MyColors.textColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  'Monthly',
                  style: TextStyle(
                      color: MyColors.textColor,
                      fontSize: 32,
                      fontWeight: FontWeight.bold),
                ),

                SizedBox(
                  height: 24,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      Provider.of<Data>(context, listen: false).hasFreeTrial
                          ? 'FREE TRIAL'
                          : '${Provider.of<Data>(context, listen: false).products[0].price}',
                      style: TextStyle(
                          color: MyColors.textColor,
                          fontSize: 48,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      Provider.of<Data>(context, listen: false).hasFreeTrial
                          ? ''
                          : '',
                      style: TextStyle(
                          color: MyColors.textColor,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  decoration: BoxDecoration(
                      color: MyColors.textColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8)),
                  child: Text(
                    Provider.of<Data>(context, listen: false).hasFreeTrial
                        ? '7 days free trial then ${Provider.of<Data>(context, listen: false).products[0].price} /month'
                        : '7 days free trial used',
                    style: TextStyle(
                        color: MyColors.textColor,
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          Spacer(),
          AnimatedSize(
            vsync: this,
            duration: Duration(milliseconds: 800),
            curve: Curves.decelerate,
            child: Container(
              height: _height,
              padding: EdgeInsets.symmetric(horizontal: 16),
              width: _width,
              margin: EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                  color: MyColors.darkBackGround,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  )),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 24,
                  ),
                  Text(
                    'Complete features that you will get',
                    style: TextStyle(
                        color: MyColors.textColor.withOpacity(0.9),
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  FeatureItem(
                    icon: Icons.star,
                    title: 'Better Performance',
                    subTitle: 'This will make your app run faster',
                  ),
                  FeatureItem(
                    icon: Icons.restaurant_outlined,
                    title: 'Meal List',
                    subTitle: 'Add Protein Fast From Meal List',
                  ),
                  FeatureItem(
                    icon: Icons.reply_outlined,
                    title: 'Add Protein For Previous Days',
                    subTitle: 'Don\'t miss your progress.',
                  ),
                  FeatureItem(
                    icon: Icons.dashboard_customize_outlined,
                    title: 'Edit Your Meals',
                    subTitle: 'Save your time.',
                  ),
                  FeatureItem(
                    icon: Icons.block,
                    title: 'No Ads',
                    subTitle: 'Don\'nt waste your time with ads.',
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  for (var prod
                      in Provider.of<Data>(context, listen: false).products)
                    GestureDetector(
                      onTap: () {
                        _buyProduct(prod);
                        //Navigator.pop(context);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        width: MediaQuery.of(context).size.width * 0.8,
                        decoration: BoxDecoration(
                            color: MyColors.accentColor,
                            borderRadius: BorderRadius.circular(50)),
                        child: Center(
                            child: Text(
                          Provider.of<Data>(context, listen: false).hasFreeTrial
                              ? 'START FOR FREE'
                              : Provider.of<Data>(context, listen: false)
                                      .isPurchased
                                  ? 'Already Premium!'
                                  : 'Upgrade Premium',
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: MyColors.textColor),
                        )),
                      ),
                    ),
                  SizedBox(
                    height: 16,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Center(
                        child: Text(
                            'cancel any time from Google Play subscriptions',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 12,
                                color: MyColors.textColor.withOpacity(0.9)))),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class FeatureItem extends StatelessWidget {
  const FeatureItem({Key key, this.title, this.icon, this.subTitle})
      : super(key: key);
  final icon;
  final title;
  final subTitle;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          SizedBox(
            width: 0,
          ),
          Icon(
            icon,
            size: 34,
            color: MyColors.textColor.withOpacity(0.9),
          ),
          SizedBox(
            width: 16,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$title',
                style: TextStyle(
                    color: MyColors.textColor.withOpacity(0.9),
                    fontSize: 12,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 2,
              ),
              Text(
                '$subTitle',
                style: TextStyle(
                    color: MyColors.textColor.withOpacity(0.54), fontSize: 12),
              )
            ],
          )
        ],
      ),
    );
  }
}
