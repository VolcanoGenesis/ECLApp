import 'package:flutter/material.dart';
import 'package:test1/components/myDrawer.dart';
import 'dart:async';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  Color _containerColor = Colors.blue;
  late Timer _colorTimer;
  late Timer _timeTimer;
  String _currentTime = '';

  @override
  void initState() {
    super.initState();
    _colorTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _containerColor =
            _containerColor == Colors.blue ? Colors.green : Colors.blue;
      });
    });

    _timeTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _currentTime = DateFormat('EEEE, hh:mm:ss a').format(DateTime.now());
      });
    });
  }

  @override
  void dispose() {
    _colorTimer.cancel();
    _timeTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavigationDrawer1(),
      appBar: AppBar(
        title: const Text('ECLSTAT 3.0'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Container(
              color: Colors.grey[200],
              child: RefreshIndicator(
                onRefresh: () async {
                  // Add refresh logic here
                },
                child: CustomScrollView(
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.all(16.0),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate([
                          _buildLifestyleScoreWidget(constraints),
                          const SizedBox(height: 20),
                          _buildWelcomeCard(constraints),
                          const SizedBox(height: 20),
                          _buildActivitySection(constraints),
                          const SizedBox(height: 20),
                          _buildTimeAndStatusSection(constraints),
                        ]),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildLifestyleScoreWidget(BoxConstraints constraints) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: constraints.maxWidth,
        minHeight: 120,
      ),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Daily lifestyle score',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Icon(Icons.sentiment_very_satisfied,
                            color: Colors.green, size: 28),
                        const SizedBox(width: 8),
                        const Text(
                          '100',
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Good',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              CircularProgressIndicator(
                value: 1.0,
                backgroundColor: Colors.grey[200],
                color: Colors.green,
                strokeWidth: 8,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeCard(BoxConstraints constraints) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: constraints.maxWidth,
        minHeight: 180,
      ),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Welcome back, Abhishek',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.health_and_safety,
                        color: Colors.green, size: 32),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Healthy',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildHealthIndicator(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHealthIndicator() {
    return Column(
      children: [
        Center(
          child: CustomPaint(
            size: const Size(20, 10),
            painter: ArrowPainter(),
          ),
        ),
        const SizedBox(height: 4),
        Container(
          height: 8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            gradient: const LinearGradient(
              colors: [Colors.green, Colors.yellow, Colors.orange],
              stops: [0.5, 0.75, 1.0],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActivitySection(BoxConstraints constraints) {
    return Column(
      children: [
        _buildActivityCard(
          'Activity Log',
          'You walked 5,000 steps today!',
          Icons.directions_walk,
        ),
        const SizedBox(height: 8),
        _buildActivityCard(
          'Diet Update',
          'You consumed a balanced diet today.',
          Icons.restaurant_menu,
        ),
        const SizedBox(height: 8),
        _buildActivityCard(
          'Health Check',
          'Your last check-up was on Oct 25, 2024.',
          Icons.medical_services,
        ),
      ],
    );
  }

  Widget _buildActivityCard(String title, String subtitle, IconData icon) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Colors.blue),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(subtitle),
      ),
    );
  }

  Widget _buildTimeAndStatusSection(BoxConstraints constraints) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            _currentTime,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
        ),
        Container(
          width: double.infinity,
          constraints: const BoxConstraints(minHeight: 50),
          child: AnimatedContainer(
            duration: const Duration(seconds: 1),
            decoration: BoxDecoration(
              color: _containerColor,
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12),
            alignment: Alignment.center,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.wifi, color: Colors.white),
                SizedBox(width: 8),
                Text(
                  'Connected to ECLStat 3.0',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class ArrowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(size.width / 2, size.height);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
