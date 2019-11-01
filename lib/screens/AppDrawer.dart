import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:minimalist_launcher/screens/ListApps.dart';
import 'package:minimalist_launcher/screens/checkToRedirect.dart';
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
          prefs = pref.data;
          List<String> packageNames = prefs.getKeys().toList();
          return Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return CheckToRedirect();
                }),
              ),
              child: Icon(
                Icons.menu,
                color: Colors.white,
              ),
            ),
            body: FutureBuilder(
              future: DeviceApps.getAppLists(packageNames),
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
