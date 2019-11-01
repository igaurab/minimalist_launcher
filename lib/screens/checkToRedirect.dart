import 'package:flutter/material.dart';
import 'package:minimalist_launcher/screens/ListApps.dart';
import 'package:random_string/random_string.dart' as rs;

class CheckToRedirect extends StatefulWidget {
  @override
  _CheckToRedirectState createState() => _CheckToRedirectState();
}

class _CheckToRedirectState extends State<CheckToRedirect> {
  String randomString;
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    randomString = rs.randomString(7);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Are You Sure?',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            children: <Widget>[
              Text(
                  'You have to type down the random strings given below to use other apps'),
              SizedBox(
                height: 20.0,
              ),
              Text(
                randomString,
                style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 10.0),
              ),
              SizedBox(
                height: 20.0,
              ),
              Form(
                key: _formKey,
                child: TextFormField(
                  validator: (value) {
                    if (value != randomString) {
                      return 'Strings dont match';
                    } else if (value.isEmpty) {
                      return 'Empty submission';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'Enter the text above...',
                    hintStyle: TextStyle(
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2,
                        fontSize: 14.0),
                  ),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              RaisedButton(
                color: Colors.blueAccent,
                onPressed: () {
                  final form = _formKey.currentState;
                  if (form.validate()) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ListAppsPages()),
                    );
                  }
                },
                child: Text(
                  "Proceed",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
