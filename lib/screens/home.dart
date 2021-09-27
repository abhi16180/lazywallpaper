import 'package:flutter/material.dart';
import 'package:fluid_bottom_nav_bar/fluid_bottom_nav_bar.dart';
import 'package:lazywall/screens/wallpapers.dart';
import 'package:lazywall/screens/about.dart';
import 'package:permission_handler/permission_handler.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Widget _child;
  @override
  void initState() {
    requestPermission();
    super.initState();
    _child = const WallPapers();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: _child,
        bottomNavigationBar: FluidNavBar(
          style: const FluidNavBarStyle(
            barBackgroundColor: Colors.greenAccent,
            iconBackgroundColor: Colors.white,
            iconSelectedForegroundColor: Colors.black,
          ),
          icons: [
            FluidNavBarIcon(icon: Icons.home),
            FluidNavBarIcon(icon: Icons.settings)
          ],
          animationFactor: 0.4,
          onChange: _handleNavigationChange,
        ),
      ),
    );
  }

  void _handleNavigationChange(int index) {
    setState(() {
      switch (index) {
        case 0:
          _child = const WallPapers();
          break;
        case 1:
          _child = const About();
          break;
      }
      _child = AnimatedSwitcher(
        switchInCurve: Curves.easeOut,
        switchOutCurve: Curves.easeIn,
        duration: const Duration(milliseconds: 400),
        child: _child,
      );
    });
  }

  requestPermission() async {
    var status =
        await PermissionHandler().requestPermissions([PermissionGroup.storage]);
  }
}
