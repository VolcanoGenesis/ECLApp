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
  Set<int> _selectedIndices = {}; // Track selected items
  String _error = '';
  bool _loading = false;
  final ScrollController _scrollController = ScrollController();

  Future<void> fetchData() async {
    if (_loading) return; // Prevent multiple simultaneous requests

    setState(() {
      _loading = true;
      _error = '';
    });

    try {
      final response = await http
          .get(Uri.parse('http://13.60.221.46:3000/getData'))
          .timeout(const Duration(seconds: 10));

      if (!mounted) return;

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          _dataList = data..sort(_sortByTimestamp);
          _loading = false;
        });
      } else {
        _handleError('Server error: ${response.statusCode}');
      }
    } catch (e) {
      _handleError(e.toString());
    }
  }

  void _handleError(String message) {
    if (!mounted) return;
    setState(() {
      _error = 'Failed to load data: $message';
      _loading = false;
    });
    _showErrorSnackbar(message);
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'Retry',
          onPressed: fetchData,
          textColor: Colors.white,
        ),
      ),
    );
  }

  int _sortByTimestamp(dynamic a, dynamic b) {
    DateTime dateA = DateTime.parse(a['timestamp']);
    DateTime dateB = DateTime.parse(b['timestamp']);
    return dateB.compareTo(dateA);
  }

  void _deleteSelectedRecords() {
    setState(() {
      _dataList = _dataList
          .asMap()
          .entries
          .where((entry) => !_selectedIndices.contains(entry.key))
          .map((entry) => entry.value)
          .toList();
      _selectedIndices.clear();
    });
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavigationDrawer1(),
      appBar: AppBar(
        title: const Text(
          'ECLSTAT 3.0',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _selectedIndices.isEmpty ? null : _deleteSelectedRecords,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: fetchData,
        child: _buildBody(),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _loading ? null : fetchData,
        icon: const Icon(Icons.refresh),
        label: const Text('Reload'),
      ),
    );
  }

  Widget _buildBody() {
    if (_loading && _dataList.isEmpty) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading data...'),
          ],
        ),
      );
    }

    if (_error.isNotEmpty && _dataList.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(_error),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: fetchData,
              child: const Text('Try Again'),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          elevation: 4,
          child: Column(
            children: [
              _buildTableHeader(),
              _buildTableBody(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
      ),
      child: const Padding(
        padding: EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Text(
                'Timestamp',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            Expanded(
              child: Text(
                'Mean\nIntensity',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            Expanded(
              child: Text(
                'Glucose\nLevel',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTableBody() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _dataList.length,
      itemBuilder: (context, index) {
        final entry = _dataList[index];
        final DateTime timestamp = DateTime.parse(entry['timestamp'])
            .add(const Duration(hours: 5, minutes: 30));

        return GestureDetector(
          onTap: () {
            setState(() {
              if (_selectedIndices.contains(index)) {
                _selectedIndices.remove(index);
              } else {
                _selectedIndices.add(index);
              }
            });
          },
          child: Container(
            color: _selectedIndices.contains(index)
                ? Colors.blue.withOpacity(0.2)
                : null,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      DateFormat('yyyy-MM-dd\nHH:mm').format(timestamp),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      entry['meanIntensity'].toString(),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      entry['glucoseLevel'].toString(),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
