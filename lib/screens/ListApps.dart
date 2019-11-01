import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:minimalist_launcher/models/app.dart';

class ListAppsPages extends StatefulWidget {
  @override
  _ListAppsPagesState createState() => _ListAppsPagesState();
}

class _ListAppsPagesState extends State<ListAppsPages> {
  bool _showSystemApps = true;
  bool _onlyLaunchableApps = true;

  @override
  void initState() {
    super.initState();
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
      ),
      body: _ListAppsPagesContent(
          includeSystemApps: _showSystemApps,
          onlyAppsWithLaunchIntent: _onlyLaunchableApps,
          key: GlobalKey()),
    );
  }
}

class _ListAppsPagesContent extends StatelessWidget {
  final bool includeSystemApps;
  final bool onlyAppsWithLaunchIntent;

  const _ListAppsPagesContent(
      {Key key,
      this.includeSystemApps: false,
      this.onlyAppsWithLaunchIntent: false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: DeviceApps.getInstalledApplications(
            includeAppIcons: true,
            includeSystemApps: includeSystemApps,
            onlyAppsWithLaunchIntent: onlyAppsWithLaunchIntent),
        builder: (context, data) {
          if (data.data == null) {
            return Center(child: CircularProgressIndicator());
          } else {
            List<Application> apps = data.data;
            apps.sort((a, b) => a.appName.compareTo(b.appName));
            return GridView.count(
              padding: EdgeInsets.all(30.0),
              crossAxisCount: 4,
              crossAxisSpacing: 20,
              mainAxisSpacing: 30.0,
              children: List.generate(apps.length, (index) {
                Application app = apps[index];
                return Column(
                  children: <Widget>[
                    Container(
                      child: app is ApplicationWithIcon
                          ? CircleAvatar(
                              backgroundColor: Colors.white,
                              child: Image.memory(
                                app.icon,
                                height: 50.0,
                                width: 50.0,
                              ),
                            )
                          : null,
                    ),
                    Text(
                      app.appName,
                      style: TextStyle(
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                );
              }),
            );
          }
        });
  }
}
