import 'package:app_final_mobile/pages/login.dart';
import 'package:app_final_mobile/pages/register.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
          gradient:
              LinearGradient(colors: [Color(0xffB81736), Color(0xff281737)])),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 150.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FaIcon(
                  FontAwesomeIcons.calendarCheck,
                  size: 40,
                  color: Colors.white,
                ),
                SizedBox(height: 5),
                Text(
                  'DailyDrift',
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 100),
          Text(
            'Bem vindo!',
            style: TextStyle(
              fontSize: 30,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const LoginPage()));
            },
            child: Container(
              height: 50,
              width: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.white),
              ),
              child: Center(
                child: Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 25),
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const RegisterPage()));
            },
            child: Container(
              height: 50,
              width: 300,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.white),
              ),
              child: Center(
                child: Text(
                  'Register',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ),
          Spacer(),
          const Text(
            'Faça login com uma rede social',
            style: TextStyle(
              fontSize: 15,
              color: Colors.white,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              FaIcon(
                FontAwesomeIcons.instagram,
                size: 25,
                color: Colors.white,
              ),
              SizedBox(
                width: 5,
              ),
              FaIcon(
                FontAwesomeIcons.twitter,
                size: 25,
                color: Colors.white,
              ),
              SizedBox(
                width: 5,
              ),
              FaIcon(
                FontAwesomeIcons.facebook,
                size: 25,
                color: Colors.white,
              ),
            ]),
          ),
          SizedBox(
            height: 10,
          )
        ],
      ),
    ));
  }
}
