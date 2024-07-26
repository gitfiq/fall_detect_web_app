import 'package:fall_detect_web_app/components/base_scaffold.dart';
import 'package:fall_detect_web_app/data/user_id.dart';
import 'package:fall_detect_web_app/pages/about_page.dart';
import 'package:fall_detect_web_app/pages/activity_page.dart';
import 'package:fall_detect_web_app/pages/current_status.dart';
import 'package:fall_detect_web_app/pages/fall_history_page.dart';
import 'package:fall_detect_web_app/pages/location_page.dart';
import 'package:fall_detect_web_app/pages/set_name_page.dart';
import 'package:fall_detect_web_app/pages/settings_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final UserId? userId;

  const HomePage({super.key, required this.userId});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0; // Index for selected tab
  String title = "Homepage";

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
      title = _getTitle(index);
    });
  }

  String _getTitle(int index) {
    switch (index) {
      case 0:
        return "Homepage";
      case 1:
        return "Fall History";
      case 2:
        return "Activity Level";
      case 3:
        return "Location";
      case 4:
        return "Set Name";
      case 5:
        return "Settings";
      case 6:
        return "About";
      default:
        return "Homepage";
    }
  }

  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return CurrentStatus(
          deviceId: '${widget.userId?.deviceId}',
        );
      case 1:
        return FallHistoryPage(
          deviceId: '${widget.userId?.deviceId}',
        );
      case 2:
        return ActivityPage(
          deviceId: '${widget.userId?.deviceId}',
        );
      case 3:
        return LocationPage(
          deviceId: '${widget.userId?.deviceId}',
        );
      case 4:
        return SetNamePage(
          deviceId: '${widget.userId?.deviceId}',
        );
      case 5:
        return SettingsPage(
          deviceId: '${widget.userId?.deviceId}',
        );
      case 6:
        return const AboutPage();
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: title,
      selectedIndex: selectedIndex,
      onItemTapped: _onItemTapped,
      body: _getPage(selectedIndex),
    );
  }
}
