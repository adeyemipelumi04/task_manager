import 'dart:async';
import 'package:flutter/material.dart';


void main() {
  runApp(CountdownApp());
}

class CountdownApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CountdownHomePage(),
    );
  }
}

class CountdownHomePage extends StatefulWidget {
  @override
  _CountdownHomePageState createState() => _CountdownHomePageState();
}

class _CountdownHomePageState extends State<CountdownHomePage> {
  late TextEditingController _controller;
  late Timer _timer;
  int _secondsRemaining = 0;
  bool _isCountingDown = false;
  

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    if (_timer.isActive) _timer.cancel();
    super.dispose();
  }

  void _startCountdown() {
    if (_controller.text.isNotEmpty) {
      final days = int.tryParse(_controller.text);
      if (days != null && days > 0) {
        setState(() {
          _secondsRemaining = days * 24 * 60 * 60; // Convert days to seconds
          _isCountingDown = true;
        });

        _timer = Timer.periodic(Duration(seconds: 1), (timer) {
          if (_secondsRemaining > 0) {
            setState(() {
              _secondsRemaining--;
            });
          } else {
            timer.cancel();
            setState(() {
              _isCountingDown = false;
            });
            
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Countdown Completed!')),
            );
          }
        });
      }
    }
  }

  void _resetCountdown() {
    if (_timer.isActive) _timer.cancel();
    setState(() {
      _secondsRemaining = 0;
      _isCountingDown = false;
      _controller.clear();
    });
  }

 

  String _formatTime(int seconds) {
    final days = seconds ~/ (24 * 60 * 60);
    final hours = (seconds % (24 * 60 * 60)) ~/ (60 * 60);
    final minutes = (seconds % (60 * 60)) ~/ 60;
    final secs = seconds % 60;

    return '${days}d ${hours}h ${minutes}m ${secs}s';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Days Countdown Timer'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Enter countdown in days',
                border: OutlineInputBorder(),
              ),
              enabled: !_isCountingDown,
            ),
            SizedBox(height: 20),
            AnimatedSwitcher(
              duration: Duration(milliseconds: 500),
              child: Text(
                _secondsRemaining > 0
                    ? 'Time Remaining: ${_formatTime(_secondsRemaining)}'
                    : 'Countdown Completed!',
                key: ValueKey<int>(_secondsRemaining),
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: _secondsRemaining > 0 ? Colors.green : Colors.red,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _isCountingDown ? null : _startCountdown,
                  child: Text('Start Countdown'),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _resetCountdown,
                  child: Text('Reset'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
