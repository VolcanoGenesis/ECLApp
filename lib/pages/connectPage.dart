import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:test1/components/myDrawer.dart';

class ConnectPage extends StatefulWidget {
  const ConnectPage({super.key});

  @override
  _ConnectPageState createState() => _ConnectPageState();
}

class _ConnectPageState extends State<ConnectPage> {
  List<dynamic> _dataList = [];
  String _error = '';
  bool _loading = false;

  Future<void> fetchData() async {
    setState(() {
      _loading = true;
    });

    try {
      final response =
          await http.get(Uri.parse('http://13.60.221.46:3000/getData'));

      if (response.statusCode == 200) {
        setState(() {
          _dataList = jsonDecode(response.body); // Assuming API returns a list
          _loading = false;
          print(_dataList);
        });
      } else {
        setState(() {
          _error = 'Failed to load data';
          _loading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Error: $e';
        _loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const NavigationDrawer1(),
        appBar: AppBar(
          title: const Text('ECLSTAT 3.0'),
          centerTitle: true,
          actions: const [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'BPHC',
                style: TextStyle(fontSize: 12),
              ),
            ),
          ],
        ),
        body: Center(
          child: _loading
              ? const CircularProgressIndicator()
              : _dataList.isNotEmpty
                  ? ListView.builder(
                      itemCount: _dataList.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(
                            DateFormat('yyyy-MM-dd HH:mm').format(
                                DateTime.parse(_dataList[index]['timestamp'])
                                    .add(
                                        const Duration(hours: 5, minutes: 30))),
                            style: const TextStyle(fontSize: 18),
                          ),
                          subtitle: Text(
                            'Mean Intensity: ${_dataList[index]['meanIntensity']} Glucose Level: ${_dataList[index]['glucoseLevel']}', // Display meanIntensity
                          ),
                        );
                      },
                    )
                  : Text(_error),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: fetchData,
          child: const Text('Fetch Data'),
        ));
  }
}
