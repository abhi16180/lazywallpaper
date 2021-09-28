//@dart=2.9
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:lazywall/screens/home.dart';

void main() {
  runApp(GetMaterialApp(
    theme: ThemeData(
      brightness: Brightness.light,
      fontFamily: 'prod',
    ),
    home: App(),
  ));
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return Home();
  }
}
