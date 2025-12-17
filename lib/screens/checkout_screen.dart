import 'package:flutter/material.dart';
import '../database/parking_db.dart';
import '../main.dart';
import 'receipt_screen.dart';

class CheckOutScreen extends StatefulWidget {
  const CheckOutScreen({super.key});

  @override
  State<CheckOutScreen> createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  String? selectedPlate;

  Future<List<Map<String, dynamic>>> _loadActive() async {
    return ParkingDB.getActiveTickets();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Check out and pay')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _loadActive(),
        builder: (context, snapshot) {
          final active = snapshot.data ?? [];

          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Text(
                'Check Out and Pay',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              const Text('Select a parked vehicle to review details and complete payment.'),
              const SizedBox(height: 16),

              Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Parked vehicles', style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 12),

                      if (snapshot.connectionState == ConnectionState.waiting)
                        const Text('Loading parked vehicles...')
                      else if (active.isEmpty)
                        const Text('No active parked vehicles.')
                      else
                        Column(
                          children: active.map((t) {
                            final plate = t['plate'] as String;
                            final chosen = selectedPlate == plate;

                            return GestureDetector(
                              onTap: () => setState(() => selectedPlate = plate),
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: chosen
                                      ? const Color(0xFF2563EB).withOpacity(0.35)
                                      : const Color(0xFF1B263B),
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(color: Colors.white10),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      chosen ? Icons.radio_button_checked : Icons.radio_button_off,
                                      color: chosen ? Colors.lightBlueAccent : Colors.white54,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            plate,
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
                              ),
                            );
                          }).toList(),
                        ),

                      const SizedBox(height: 16),
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (selectedPlate == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Select a vehicle first')),
                              );
                              return;
                            }

                            try {
                              final ticket = await parkingService.checkOut(selectedPlate!);
                              if (!mounted) return;

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ReceiptScreen(ticket: ticket),
                                ),
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(e.toString())),
                              );
                            }
                          },
                          child: const Text('Complete check out and pay'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 12),
              const Center(
                child: Text(
                  'Rate per hour is fixed. Minimum billing is one hour.',
                  style: TextStyle(color: Colors.white60),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
