import 'package:flutter/material.dart';
import 'package:device_apps/device_apps.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:minimalist_launcher/screens/AppDrawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences prefs;

class AppSelectorPage extends StatefulWidget {
  @override
  _AppSelectorPageState createState() => _AppSelectorPageState();
}

class _AppSelectorPageState extends State<AppSelectorPage> {
  bool _showSystemApps;
  bool _onlyLaunchableApps;

  @override
  void initState() {
    super.initState();
    _showSystemApps = true;
    _onlyLaunchableApps = true;
    _initPreference();
  }

  _initPreference() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text("All applications"),
        actions: <Widget>[
          PopupMenuButton(
            itemBuilder: (context) {
              return <PopupMenuItem<String>>[
                PopupMenuItem<String>(
                    value: 'system_apps', child: Text('Toogle')),
              ];
            },
            onSelected: (key) {
              if (key == "system_apps") {
                setState(() {
                  _showSystemApps = !_showSystemApps;
                });
              }
            },
          )
        ],
        leading: IconButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AppDrawer()),
          ),
          icon: Icon(
            Icons.done_outline,
            color: Colors.blueAccent,
          ),
        ),
      ),
      body: _AppSelectorPageContent(
          includeSystemApps: _showSystemApps,
          onlyAppsWithLaunchIntent: _onlyLaunchableApps,
          key: GlobalKey()),
    );
  }
}

class _AppSelectorPageContent extends StatefulWidget {
  final bool includeSystemApps;
  final bool onlyAppsWithLaunchIntent;

  const _AppSelectorPageContent(
      {Key key,
      this.includeSystemApps: false,
      this.onlyAppsWithLaunchIntent: false})
      : super(key: key);

  @override
  __AppSelectorPageContentState createState() =>
      __AppSelectorPageContentState();
}

class __AppSelectorPageContentState extends State<_AppSelectorPageContent> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: DeviceApps.getInstalledApplications(
            includeAppIcons: true,
            includeSystemApps: widget.includeSystemApps,
            onlyAppsWithLaunchIntent: widget.onlyAppsWithLaunchIntent),
        builder: (context, data) {
          if (data.data == null) {
            return Center(child: CircularProgressIndicator());
          } else {
            List<Application> apps = data.data;
            apps.sort((a, b) => a.appName.compareTo(b.appName));
            //TODO: Add a blue border if the app is already in the prefrences
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
                          setState(() {
                            print("L: ${prefs.getKeys().length}");
                            if (prefs.containsKey(app.packageName)) {
                              prefs.remove('${app.packageName}');
                              print(
                                  "Removed ${app.packageName} to pref, total: ${prefs.getKeys().length}");
                            } else if (prefs.getKeys().length <= 5) {
                              prefs.setString(app.packageName, app.appName);
                              print(
                                  "Added ${app.packageName} to pref, total: ${prefs.getKeys().length}");
                            } else {
                              Fluttertoast.showToast(
                                  msg: "You can add only 6 apps",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIos: 1,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            }
                          });
                        },
                        title: Text("${app.appName}"),
                        trailing: prefs.containsKey(app.packageName)
                            ? Icon(Icons.done_all,
                                color: Colors.blueAccent, size: 20.0)
                            : null,
                      ),
                      Divider(
                        height: 1.0,
                      ),
                    ],
                  );
                },
                itemCount: apps.length);
          }
        });
  }
}
