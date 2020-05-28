
import 'package:flutter/material.dart';

class AppTitle extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return  RichText(
        text: const TextSpan(
            text: 'In',
            style: const TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
                color: Colors.deepOrange),
            children:const  <TextSpan>[
          const TextSpan(
              text: 'cHaT',
              style: const TextStyle(
                  fontSize: 23.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber))
        ]));
  }
}