// ignore: file_names
// ignore_for_file: use_build_context_synchronously

import 'package:fall_detect_web_app/pages/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BaseScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;

  const BaseScaffold({
    super.key,
    required this.title,
    required this.body,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 0, 62, 113),
        title: Center(child: Text(title)),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () async {
              await FirebaseAuth.instance
                  .signOut(); // Deauthenticate the user when log out
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Homepage'),
              selected: selectedIndex == 0,
              onTap: () {
                Navigator.pop(context); // Close the drawer
                onItemTapped(0);
              },
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('Fall History'),
              selected: selectedIndex == 1,
              onTap: () {
                Navigator.pop(context); // Close the drawer
                onItemTapped(1);
              },
            ),
            ListTile(
              leading: const Icon(Icons.analytics_outlined),
              title: const Text('Activity'),
              selected: selectedIndex == 2,
              onTap: () {
                Navigator.pop(context); // Close the drawer
                onItemTapped(2);
              },
            ),
            ListTile(
              leading: const Icon(Icons.location_city_outlined),
              title: const Text('Location'),
              selected: selectedIndex == 3,
              onTap: () {
                Navigator.pop(context); // Close the drawer
                onItemTapped(3);
              },
            ),
            ListTile(
              leading: const Icon(Icons.person_2_outlined),
              title: const Text('Set Name'),
              selected: selectedIndex == 4,
              onTap: () {
                Navigator.pop(context); // Close the drawer
                onItemTapped(4);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings_applications_outlined),
              title: const Text('Settings'),
              selected: selectedIndex == 5,
              onTap: () {
                Navigator.pop(context); // Close the drawer
                onItemTapped(5);
              },
            ),
            ListTile(
              leading: const Icon(Icons.info_outline_rounded),
              title: const Text('About'),
              selected: selectedIndex == 6,
              onTap: () {
                Navigator.pop(context); // Close the drawer
                onItemTapped(6);
              },
            ),
          ],
        ),
      ),
      body: body,
    );
  }
}
