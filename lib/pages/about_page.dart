import 'package:fall_detect_web_app/components/about_tile.dart';
import 'package:flutter/material.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 50.0),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.2,
              child: const Center(
                child: Column(
                  children: [
                    Text(
                      'About Us',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 15.0),
                    SizedBox(
                      child: Text(
                        'Afiq, Jovan and Javier. The creator of the Silver Shiled. Silver Shiled is created for families in Singapore to monitor their elderlies when they are away from home. \n\nNOTE: Allow this application to run in the background. Do not terminate the application as notification of a fall detected will not be shown if application is terminated',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 50.0),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              height: MediaQuery.of(context).size.height * 0.45,
              width: MediaQuery.of(context).size.width * 0.75,
              child: Scrollbar(
                controller: _scrollController,
                thumbVisibility: false,
                child: ListView(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  children: const [
                    AboutTile(
                        title: "Current Status",
                        body:
                            "You can check the current status of the user in the 'Current Status Page'. This is where it will show if the device has detected a fall. \n\nInformation that are available in the 'Current Status Page' are: \n. Time when page is opened, \n. LOCATION of the device and \n. STATUS of the device (Fall Detected / OK)"),
                    AboutTile(
                        title: "Fall History",
                        body:
                            "All previous fall detected are stored in the 'Fall History Page'. This page is mainly use for viewing past falls and can be used for medical analysis with doctors. You are also able to delete certain fall history if you see that the fall detected was a false alarm. \n\nInformation that are available in the 'Fall History Page' are: \n. TIME of the fall and \n. LOCATION where the fall occured"),
                    AboutTile(
                        title: "Activity Level",
                        body:
                            "You can check the movements of the user in the 'Active Level Page'. In this page there would be one graph showing the overal accelration of the user. Do use this page to check on the user if a fall is detected. \n\n NOTE: If a fall is detected and no movements are shown, a fall has most likely occured. Whereas if movements are shown, a fall may not have occured. However stil do contact them to check on their status and call an ambulance if necessary. \n\n\n MORE INFORMATION \n\n The 'Activity Level Page' acceleration graph visually represent the body movements. If the graph shows a dip (bends downward) it generally means that the person is either falling or is moving downwards very fast. Whereas if the graph shows a spike (bends upwards) it generally means that the user experience greater force (eg. Just impacted the ground from a fall, or a landed from a jump). \n\n'STEPS to see if a fall is detected'. \n\nWhen a fall detected notification is observesed, check if the graph shows dips followed by spike (large), then most likely a fall has occured"),
                    AboutTile(
                        title: "Location",
                        body:
                            "You can check the location of the user in the 'Location Page'. In this page, there will be 2 types of markers, the RED and BLUE. \n\n The RED marker indicates the current location of the user. While the BLUE marker is all the places where a fall is detected"),
                    AboutTile(
                        title: "Set Name",
                        body:
                            "You can assign a name to the device in the 'Set Name Page'. In this page you can assign the a name to the device which will be used for notification purposes. This is to allow better clarification of who's device has detected a fall. \n\n NOTE: If no names have been set, the device ID will be used as an identifier for the fall detected notification."),
                    AboutTile(
                        title: "Setings",
                        body:
                            "You can adjust the sensitivity level of the device in the 'Settings Page'. There will be a slider that you can adjust ranging from low, medium to high sensitivity. This sensitivity is used in the detection of falls. \n\n For example, high sensitivity will detect falls more easily but may detect more false falls. While the low sensitivity will detect more drastic falls and will detect lesser false falls."),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
