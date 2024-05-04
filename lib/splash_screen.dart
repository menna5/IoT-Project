import 'package:flutter/material.dart';
import 'package:untitled7/Homescreen.dart';

class SplashScreen extends StatelessWidget {
  static const String routeName = 'splash';


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(

        image: DecorationImage(
          image: AssetImage('assets/images/Onboard.png'),
          fit: BoxFit.fill

        )
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [

            Container(
              margin: EdgeInsets.all(32),
              child: Text('Stay ahead of the weather with our accurate forecasts',
                style: TextStyle(
                  color: Color(0xFF494A4B),
                  fontSize: 22,
              
                ),
              
              
              ),
            ),
             SizedBox(height: 50,),
             GestureDetector(
               onTap: (){
                 Navigator.pushReplacementNamed(context, HomeScreen.routeName);
               },
               child: Container(
                  padding: EdgeInsets.all(12),

                  margin: EdgeInsets.only(
                    left: 40 , right: 40 ,bottom: 60
                  ),
                  width: double.infinity,
                  height: 55,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: Color(0xFF0C5285),
                  ),
                  child: Text('Get Started',style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),textAlign: TextAlign.center,
                  ),

                ),
             ),


          ],
        ),
      ),
    );
  }
}
