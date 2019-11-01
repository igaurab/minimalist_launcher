import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences prefs;
int sharedPrefCounter;

class AppDrawer extends StatefulWidget {
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: SharedPreferences.getInstance(),
      builder: (context, pref) {
        if (pref == null) {
          return Container(
            child: Text("Pref is null"),
          );
        } else {
          sharedPrefCounter = pref.data.getInt('prefCounter');
          print(" PREF DATA: ${pref.data.getInt('prefCounter')}");
          prefs = pref.data;
          List<String> packageNames = [];
          for (var i = 0; i <= sharedPrefCounter; i++) {
            packageNames.add(prefs.getString('$i'));
          }
          print("Packages name: $packageNames");
          return Material(
            child: FutureBuilder(
              future: DeviceApps.getAppLists(
                packageNames
              ),
              builder: (context, data) {
                if (data.hasData == null) {
                  return Text("No Package Data has ");
                }
                List<Application> apps = data.data;
                apps.sort((a, b) => a.appName.compareTo(b.appName));
                return ListView.builder(
                    itemBuilder: (context, position) {
                      Application app = apps[position];
                      return Column(
                        children: <Widget>[
                          ListTile(
                            leading: app is ApplicationWithIcon
                                ? CircleAvatar(
                                    backgroundImage: MemoryImage(app.icon),
                                    backgroundColor: Colors.white,
                                  )
                                : null,
                            onTap: () {
                              DeviceApps.openApp(app.packageName);
                            },
                            title: Text("${app.appName}"),
                          ),
                          Divider(
                            height: 1.0,
                          )
                        ],
                      );
                    },
                    itemCount: apps.length);
              },
            ),
          );
        }
      },
    );
  }
}