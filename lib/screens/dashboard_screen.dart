import 'package:flutter/material.dart';
import '../database/parking_db.dart';
import '../main.dart';
import 'checkin_screen.dart';
import 'checkout_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<Map<String, dynamic>> active = [];
  List<Map<String, dynamic>> completed = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final a = await ParkingDB.getActiveTickets();
    final c = await ParkingDB.getCompletedTickets();

    if (!mounted) return;
    setState(() {
      active = a;
      completed = c;
    });
  }

  @override
  Widget build(BuildContext context) {
    final occupied = active.length;
    final total = 18;
    final available = total - occupied;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Automated Parking System'),
        actions: [
          TextButton(
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CheckInScreen()),
              );
              _loadData();
            },
            child: const Text('Check In'),
          ),
          TextButton(
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CheckOutScreen()),
              );
              _loadData();
            },
            child: const Text('Check Out'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text('Dashboard', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 18),

            Row(
              children: [
                Expanded(child: _statCard('Rate per hour', '₱30.00')),
                const SizedBox(width: 12),
                Expanded(child: _statCard('Total slots', total.toString())),
                const SizedBox(width: 12),
                Expanded(child: _statCard('Available', available.toString())),
                const SizedBox(width: 12),
                Expanded(child: _statCard('Occupied', occupied.toString())),
              ],
            ),

            const SizedBox(height: 18),

            _sectionCard(
              title: 'Active sessions',
              rightButton: ElevatedButton(
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CheckInScreen()),
                  );
                  _loadData();
                },
                child: const Text('New check in'),
              ),
              child: active.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: Text('No active sessions.'),
                    )
                  : Column(
                      children: active.map(_activeTile).toList(),
                    ),
            ),

            _sectionCard(
              title: 'Paid sessions',
              rightButton: ElevatedButton(
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CheckOutScreen()),
                  );
                  _loadData();
                },
                child: const Text('Check out and pay'),
              ),
              child: completed.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: Text('No paid sessions yet.'),
                    )
                  : Column(
                      children: completed.map(_paidTile).toList(),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statCard(String label, String value) {
    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(color: Colors.white70)),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionCard({
    required String title,
    required Widget rightButton,
    required Widget child,
  }) {
    return Card(
      elevation: 10,
      margin: const EdgeInsets.only(top: 18),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                rightButton,
              ],
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }

  Widget _activeTile(Map<String, dynamic> t) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1B263B),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          const Icon(Icons.local_parking, color: Colors.green),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  t['plate'],
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text('Slot: ${t['slot']}'),
                Text('Time in: ${t['time_in']}'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _paidTile(Map<String, dynamic> t) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1B263B),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.blue),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  t['plate'],
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text('Slot: ${t['slot']}'),
                Text('Time out: ${t['time_out']}'),
                Text('Paid: ₱${t['fee']}'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
