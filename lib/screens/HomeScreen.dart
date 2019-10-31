import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Application> apps = [];
  String formattedDate;
  @override
  void initState() {
    super.initState();
    _getInstalledApplications();
    _getCurrentDateTime();
  }

  _getCurrentDateTime() {
    DateTime now = DateTime.now();
    formattedDate = DateFormat('kk:mm \n EEE d MMM').format(now);
  }

  _getInstalledApplications() async {
    apps = await DeviceApps.getInstalledApplications(
        includeSystemApps: true,
        includeAppIcons: true,
        onlyAppsWithLaunchIntent: true);
    for (var app in apps) {
      print("${app.appName}: ${app.packageName}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        GestureDetector(
          onDoubleTap: () {},
          child: Container(
            color: Colors.blue[200],
          ),
        ),
        Center(
            child: Text(
          formattedDate,
          textAlign: TextAlign.center,
          style: new TextStyle(
              fontWeight: FontWeight.bold, fontSize: 25.0, color: Colors.white),
        )),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              height: 90,
              width: MediaQuery.of(context).size.width - 80,
              decoration: BoxDecoration(
                  color: Colors.grey[100].withOpacity(0.7),
                  borderRadius: BorderRadius.circular(20.0)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      //TODO: Add intent to phone
                      print("Phone");
                      //
                      DeviceApps.openApp("com.android.dialer");
                    },
                    child: Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.circular(20.0)),
                      child: Icon(Icons.phone),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      DeviceApps.openApp("com.android.contacts");
                      print("Contact");
                    },
                    child: Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                          color: Colors.blueAccent,
                          borderRadius: BorderRadius.circular(20.0)),
                      child: Icon(Icons.contacts),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      DeviceApps.openApp("com.google.android.apps.messaging");
                      print("Messages");
                    },
                    child: Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                          color: Colors.yellowAccent,
                          borderRadius: BorderRadius.circular(20.0)),
                      child: Icon(Icons.message),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      DeviceApps.openApp("com.android.camera2");
                      print("Camera");
                    },
                    child: Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                          color: Colors.greenAccent,
                          borderRadius: BorderRadius.circular(20.0)),
                      child: Icon(Icons.camera),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
