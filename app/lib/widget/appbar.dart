import 'package:flutter/material.dart';

// ignore: camel_case_types
class MyBar extends StatelessWidget implements PreferredSizeWidget {
  final isBack;
  MyBar({this.isBack = false, Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 20, left: 8),
      child: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              Icons.radio,
              color: Colors.white,
              size: 30,
            ),
            SizedBox(width: 10),
            Text(
              'Radiokam',
              style: TextStyle(
                fontFamily: 'Lexend Deca',
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [],
        centerTitle: false,
        elevation: 0,
      ),
    );
  }

  @override
  Size get preferredSize {
    return new Size.fromHeight(kToolbarHeight);
  }
}
