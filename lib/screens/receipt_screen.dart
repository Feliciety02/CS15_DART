import 'package:flutter/material.dart';
import '../logic/parking_service.dart';

class ReceiptScreen extends StatelessWidget {
  final ParkingTicket ticket;

  const ReceiptScreen({super.key, required this.ticket});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Receipt'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.receipt_long, size: 80, color: Colors.blue),
            const SizedBox(height: 24),
            _row('Plate Number', ticket.plateNumber),
            _row('Slot', ticket.slot),
            _row('Time In', ticket.timeIn.toString()),
            _row('Time Out', ticket.timeOut.toString()),
            const Divider(height: 40),
            _row(
              'Total Fee',
              '₱${ticket.totalFee!.toStringAsFixed(2)}',
              bold: true,
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                child: const Text('Done'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _row(String label, String value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
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
