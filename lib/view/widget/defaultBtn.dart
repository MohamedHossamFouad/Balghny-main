import 'package:flutter/material.dart';

Widget defaultButton({
  //required double width,
 // required Color background,
  required Function function,
  required String text,
}) =>
Container(
  margin: EdgeInsets.symmetric(horizontal: 20),
  child: SizedBox(
    height: 40,
    child: ElevatedButton(
      onPressed: () {
        //   Navigator.of(context).pushNamed("login");
      },
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.green),
          shape: MaterialStateProperty.all<
              RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)))),
      child: Text(
         text,
        style: TextStyle(
            fontSize: 20,
            color: Colors.white),
      ),
    ),
  ),
);