import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screen/home.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Color(0xFF130F40),
    ),
  );
  runApp(
    Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border(
            right: BorderSide(
              color: Color(0xFFF2304D),
              width: 4.0,
            ),
          ),
        ),
        child: MaterialApp(
          initialRoute: '/',
          routes: {
            '/': (context) => Home(),
          },
        ),
      ),
    ),
  );
}
