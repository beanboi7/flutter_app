import 'package:flutter/material.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/screens/sign_in/sign_in_screen.dart';
import 'package:shop_app/size_config.dart';

import '../components/splash_content.dart';
import '../../../components/default_button.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  int currentPage = 0;
  List<Map<String, String>> splashData = [
    {
      "text": "Welcome to Heartfulness, From Stress Management \nto Stress Realization!",
      "image": "assets/images/heartfulness.jpeg"
    },
    {
      "text":
          "Learning to relax is vital for well-being.\n It reduces tension in all \nparts of your body and helps you to \nstay balanced even in stressful situations.",
      "image": "assets/images/relax.png"
    },
    {
      "text": "With regular Heartfulness Meditation, \nyour mind will become centered\n and shift to deeper levels of \n feeling, intuition and consciousness.",
      "image": "assets/images/meditate.png"
    },
    {
      "text":
      "Cleaning fosters lightness of being, \n joy and a carefree attitude, \nas emotional burdens, habits, \n and complexities are removed.",
      "image": "assets/images/cleaning.png"
    },
    {
      "text":
      "Through a simple bedtime prayerful intention,\n you can connect humbly with your inner self,\n listen to your heart’s voice,\n and weave your destiny.",
      "image": "assets/images/connect.png"
    },
  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 3,
              child: PageView.builder(
                onPageChanged: (value) {
                  setState(() {
                    currentPage = value;
                  });
                },
                itemCount: splashData.length,
                itemBuilder: (context, index) => SplashContent(
                  image: splashData[index]["image"],
                  text: splashData[index]['text'],
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(20)),
                child: Column(
                  children: <Widget>[
                    Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        splashData.length,
                        (index) => buildDot(index: index),
                      ),
                    ),
                    Spacer(),
                    DefaultButton(
                      text: "Continue",
                      press: () {
                        Navigator.pushNamed(context, SignInScreen.routeName);
                      },
                    ),
                    Spacer(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  AnimatedContainer buildDot({int index}) {
    return AnimatedContainer(
      duration: kAnimationDuration,
      margin: EdgeInsets.only(right: 5),
      height: 6,
      width: currentPage == index ? 20 : 6,
      decoration: BoxDecoration(
        color: currentPage == index ? Colors.lightGreen : Color(0xFFD8D8D8),
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}
