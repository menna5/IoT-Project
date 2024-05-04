import 'package:flutter/material.dart';

class ImageTextWidget extends StatelessWidget {
  final String imagePath;
  final String text;

  ImageTextWidget({required this.imagePath, required this.text});


  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Row(
      children: [
        Image.asset(imagePath,
          width: size.width*0.15,
        ),
        SizedBox(width: 15,),
        Container(
          width: size.width*0.50,
          height: 60,

          decoration: ShapeDecoration(
            color: Colors.transparent,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.white, width: 2.0),
              borderRadius: BorderRadius.circular(15.0),
            ),
          ),
          child: Text(text,style: TextStyle(
              color: Colors.black,fontSize: 22
          )),
        )
      ],
    );
  }
}
