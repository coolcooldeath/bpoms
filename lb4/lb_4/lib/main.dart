import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(
    new MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            appBar: AppBar(title: Text('LB2_3')),
            body: MyForm()
        )
    )
);

class MyForm extends StatelessWidget {
  MyForm({Key key, this.statusCode}) : super(key: key);

  final _formKey = GlobalKey<FormState>();

  final int statusCode;
  String ip = "";
  String port = "";
  String messageSend = "";
  String hash = "";

  static const platform = const MethodChannel('samples.flutter.dev/android_hash');

  Future<void> _getHash() async {
    String androidSHA256Hash;
    try {
      Map map = { "hash" : messageSend };
      final String result = await platform.invokeMethod<String>('getHash', map);
      androidSHA256Hash = result;
    } on PlatformException catch (e) {
      androidSHA256Hash = "Failed to get hash: '${e.message}'.";
    }
    hash = androidSHA256Hash;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(10.0),
        child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Text(
                  'IP or DNS name:',
                  style: TextStyle(fontSize: 20.0),
                ),
                // ignore: missing_return
                TextFormField(validator: (value)
                {
                  if (value.isEmpty) return 'Enter IP!';
                  try { ip = value.toString(); } catch(e) {
                    ip = null;
                    return e.toString();
                  }
                }),
                SizedBox(height: 20.0),
                Text(
                  'PORT:',
                  style: TextStyle(fontSize: 20.0),
                ),
                // ignore: missing_return
                TextFormField(validator: (value) {
                  if (value.isEmpty) return 'Enter Port!';
                  try { port = value.toString(); } catch(e) {
                    port = null;
                    return e.toString();
                  }
                }),
                SizedBox(height: 20.0),
                Text('Message:', style: TextStyle(fontSize: 20.0),),
                // ignore: missing_return
                TextFormField(validator: (value) {
                  if (value.isEmpty) return 'Enter Message!';
                  try { messageSend = value.toString(); } catch(e) {
                    messageSend = null;
                    return e.toString();
                  }
                }
                ),
                RaisedButton(onPressed: () async {
                  if(_formKey.currentState.validate()) Scaffold.of(context).
                  showSnackBar(
                      SnackBar(
                        content: Text('Success'),
                        backgroundColor: Colors.green,
                      )
                  );

                  _getHash();
                  HttpClient client = new HttpClient();
                  client.badCertificateCallback =((X509Certificate cert, String host, int port) => true);

                  String url = "https://" + ip + ":" + port + "/vhash";
                  Map map = { "data" : messageSend , "generHash" : hash.toLowerCase() };
                  HttpClientRequest request = await client.postUrl(Uri.parse(url));

                  request.headers.set('content-type', 'application/json');
                  request.add(utf8.encode(json.encode(map)));

                  HttpClientResponse response = await request.close();
                  String reply = await response.transform(utf8.decoder).join();
                  print(reply + "\n---DEFAULT VALUE: " + hash + "---\n");
                },
                  child: Text('Send'),
                  color: Colors.blue,
                  textColor: Colors.white,
                ),
              ],
            )
        )
    );
  }
}