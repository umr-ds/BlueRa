import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:BlueRa/screens/Home.dart';
import 'package:BlueRa/connectors/Database.dart';
import 'package:BlueRa/connectors/Location.dart';
import 'package:BlueRa/connectors/Username.dart';
import 'package:BlueRa/data/Channel.dart';
import 'package:BlueRa/data/Message.dart';
import 'package:BlueRa/data/Globals.dart';
import 'package:BlueRa/screens/BluetoothSettings.dart';
import 'package:BlueRa/screens/UserSettings.dart';

void main() {
  runApp(new BlueRa());
}

class BlueRa extends StatelessWidget {
  final DBConnector dbHelper = DBConnector.instance;

  @override
  Widget build(BuildContext context) {

    UserLocationStream().initLocation();

    BluetoothOffScreenState.reconnect();

    UsernameConnector.read();

    dbHelper.queryAllRows().then((rows) {
      for (Map<String, dynamic> row in rows) {
        String channelName = row[DBConnector.columnName];
        bool attending = row[DBConnector.columnAttending].toLowerCase() == "true";
        String messagesJson = row[DBConnector.columnMessages];
        Iterable jsonObjects = json.decode(messagesJson);
        List<Message> messages = jsonObjects.map((item) => Message.fromJson(item)).toList();
        ValueNotifier<Channel> _chn = ValueNotifier<Channel>(Channel(channelName, attending, messages));
        if (Channel.getChannel(_chn.value.name) != null) {
          continue;
        }
        channels.value.add(_chn);
        channels.notifyListeners();
      }
    });
    return new MaterialApp(
      title: "BlueRa",
      home: localUser == null ? UserSettingsScreen() : HomeScreen(),
    );
  }
}
