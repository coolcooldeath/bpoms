import 'dart:async';
import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sensors/sensors.dart';

import 'entropy_functions/Entropy.dart';

class HashGenerator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Hash',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'LB5 - Generate your hash'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HashGeneratorPageState createState() => _HashGeneratorPageState();
}

class _HashGeneratorPageState extends State<MyHomePage> {

  final _textHexController = TextEditingController();
  final _textEntropyController = TextEditingController();
  final _textInputController = TextEditingController();
  int length = 0;

  Stopwatch stopwatch = new Stopwatch();
  List<int> times = [];

  @override
  void dispose() {

    _textInputController.dispose();
    _textEntropyController.dispose();
    _textHexController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: [
            TextField(
              controller: _textInputController,
              onChanged: onTextChanged,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp("[a-z]")),
              ],
              maxLength: 32,
              style: TextStyle(fontSize: 24),
              decoration: InputDecoration(
                hintText: 'Enter string(only small letters)',
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Padding(
                  padding: EdgeInsets.all(5),
                  child: ElevatedButton(
                      onPressed: onSubmit,
                      child: Text(
                          "Submit string",
                          style: TextStyle(fontSize: 22)
                      )
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(5),
                  child: ElevatedButton(
                      onPressed: onRandom,
                      child: Text(
                          "Random HEX",
                          style: TextStyle(fontSize: 22)
                      )
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.all(5),
                  child: ElevatedButton(
                      onPressed: accelerometer,
                      child: Text(
                          "Start Accelerometer Generator",
                          style: TextStyle(fontSize: 22)
                      )
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(5),
              child: ElevatedButton(
                  onPressed: reset,
                  child: Text(
                      "Reset Entropy",
                      style: TextStyle(fontSize: 22)
                  )
              ),
            ),
            Divider(thickness: 3.0),
            TextField(
              controller: _textHexController,
              style: TextStyle(fontSize: 22),
              maxLines: 5,
              enabled: false,
              decoration: InputDecoration(
                hintText: 'Result Hex String',
              ),
            ),
            TextField(
              controller: _textEntropyController,
              style: TextStyle(fontSize: 22),
              maxLines: 1,
              enabled: false,
              decoration: InputDecoration(
                hintText: 'Entropy (result)',
              ),
            ),
          ],
        ),
      )
    );
  }

  void onTextChanged(String value) {
    if (value.length == length + 1) {
      if (length > 0) {
        stopwatch.stop();
        times.add(stopwatch.elapsedMilliseconds);
      }
      stopwatch.reset();
      length++;
      stopwatch.start();
    }
  }

  void onSubmit() {

    String hex = hexStringFromIntList(times);
    _textHexController.text = hex;
    print(hex);

    double calc_entropy = entropy(times);
    _textEntropyController.text = calc_entropy.toString();
    print("Submit string Entropy - " + calc_entropy.toString());

    _textInputController.clear();
    length = 0;
    times.clear();
  }

  void onRandom() {
    List<int> random = getRandomList();
    String hex = hexStringFromIntList(random);
    _textHexController.text = hex;
    print(hex);

    double calc_entropy = entropy(random);
    _textEntropyController.text = calc_entropy.toString();
    print("Random Entropy - " + calc_entropy.toString());
  }

  void reset() {
    _textInputController.clear();
    _textEntropyController.clear();
    _textHexController.clear();
    length = 0;
    times.clear();
  }

  void accelerometer() {
    List<AccelerometerEvent> events = [];
    Stopwatch accelerometerTimer = new Stopwatch();
    accelerometerTimer.start();

    StreamSubscription<AccelerometerEvent> subscription;
    subscription = accelerometerEvents.listen((AccelerometerEvent current) {
      if (events.length == 32) {

        subscription.cancel();
        var normalizedList = events.map((e) => (e.x * e.y * e.z * 31).abs().ceil()).toList();
        String hex = hexStringFromIntList(normalizedList);
        _textHexController.text = hex;
        print(hex);

        double calc_entropy = entropy(normalizedList);
        _textEntropyController.text = calc_entropy.toString();
        print("Accelerometer Entropy - " + calc_entropy.toString());
      }
      if (accelerometerTimer.elapsedMilliseconds > 100) {

        if (events.isEmpty || isMoving(events.last, current, 0.2)) {
          events.add(current);
        }
        accelerometerTimer.reset();
      }

    });
  }

  bool isMoving(AccelerometerEvent previous, AccelerometerEvent current, double precision) {

    return (previous.x - current.x).abs() > precision
        || (previous.y - current.y).abs() > precision
        || (previous.z - current.z).abs() > precision;
  }
}
