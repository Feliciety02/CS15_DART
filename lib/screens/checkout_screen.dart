import 'package:flutter/material.dart';
import '../main.dart';
import 'receipt_screen.dart';

class CheckOutScreen extends StatefulWidget {
  const CheckOutScreen({super.key});

  @override
  State<CheckOutScreen> createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  final TextEditingController plateController = TextEditingController();

  @override
  void dispose() {
    plateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Check Out'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Icon(
              Icons.car_crash,
              size: 80,
              color: Colors.red,
            ),
            const SizedBox(height: 30),
            TextField(
              controller: plateController,
              decoration: InputDecoration(
                labelText: 'Plate Number',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.confirmation_number),
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  if (plateController.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please enter a plate number'),
                      ),
                    );
                    return;
                  }

                  try {
                    final ticket = await parkingService
                        .checkOut(plateController.text.trim());

                    if (!mounted) return;

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ReceiptScreen(ticket: ticket),
                      ),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(e.toString()),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                child: const Text('Confirm Check Out'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
