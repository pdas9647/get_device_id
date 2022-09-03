import 'package:flutter/material.dart';
import 'package:get_device_id/services/user_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'services/read_device_id.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  UserSettings userSettings = UserSettings();
  bool isLoading = false;

  Future<void> getDeviceID() async {
    setState(() {
      isLoading = true;
    });
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    userSettings.deviceID.value =
        await readDeviceID(sharedPreferences: sharedPreferences);
    print('Device ID in Splash: ${userSettings.deviceID.value}');
    sharedPreferences.setString(
        userSettings.deviceID.key, userSettings.deviceID.value);
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDeviceID();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Get Device ID')),
      body: isLoading
          ? const CircularProgressIndicator()
          : Center(
              child: Text(userSettings.deviceID.value ?? 'Device ID not found'),
            ),
    );
  }
}
