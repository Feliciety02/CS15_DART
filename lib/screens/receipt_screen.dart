import 'package:flutter/material.dart';
import '../logic/parking_service.dart';

class ReceiptScreen extends StatelessWidget {
  final ParkingTicket ticket;

  const ReceiptScreen({super.key, required this.ticket});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Receipt')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text('Receipt', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 16),

          Card(
            elevation: 10,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                children: [
                  const Icon(Icons.receipt_long, size: 60, color: Colors.lightBlueAccent),
                  const SizedBox(height: 16),

                  _row('Plate', ticket.plateNumber),
                  _row('Slot', ticket.slot),
                  _row('Time in', ticket.timeIn.toString()),
                  _row('Time out', ticket.timeOut.toString()),
                  const Divider(height: 28),
                  _row('Total fee', '₱${ticket.totalFee?.toStringAsFixed(2)}', bold: true),
                ],
              ),
            ),
          ),

          const SizedBox(height: 18),
          ElevatedButton(
            onPressed: () {
              Navigator.popUntil(context, (route) => route.isFirst);
            },
            child: const Text('Back to dashboard'),
          ),
        ],
      ),
    );
  }

  Widget _row(String label, String value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(label, style: const TextStyle(color: Colors.white70)),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
