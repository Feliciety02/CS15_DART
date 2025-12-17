import 'package:flutter/material.dart';
import '../main.dart';

class CheckInScreen extends StatefulWidget {
  const CheckInScreen({super.key});

  @override
  State<CheckInScreen> createState() => _CheckInScreenState();
}

class _CheckInScreenState extends State<CheckInScreen> {
  final plateController = TextEditingController();
  String? selectedSlot;

  @override
  void dispose() {
    plateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Check in')),
      body: FutureBuilder<List<String>>(
        future: parkingService.getAvailableSlots(),
        builder: (context, snapshot) {
          final slots = snapshot.data ?? [];

          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Text('Check in', style: Theme.of(context).textTheme.headlineSmall),
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
                      const Text('Plate number'),
                      const SizedBox(height: 8),
                      TextField(
                        controller: plateController,
                        decoration: const InputDecoration(
                          hintText: 'Enter plate number',
                          prefixIcon: Icon(Icons.confirmation_number),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 18),

                      const Text('Parking slot'),
                      const SizedBox(height: 10),

                      if (snapshot.connectionState == ConnectionState.waiting)
                        const Padding(
                          padding: EdgeInsets.only(top: 8),
                          child: Text('Loading slots...'),
                        )
                      else if (slots.isEmpty)
                        const Padding(
                          padding: EdgeInsets.only(top: 8),
                          child: Text('No available slots.'),
                        )
                      else
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: slots.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 6,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 1.6,
                          ),
                          itemBuilder: (context, index) {
                            final slot = slots[index];
                            final selected = selectedSlot == slot;

                            return GestureDetector(
                              onTap: () => setState(() => selectedSlot = slot),
                              child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: selected
                                      ? const Color(0xFF2563EB)
                                      : const Color(0xFF1B263B),
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(color: Colors.white10),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      slot,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      slot.startsWith('A')
                                          ? 'Floor A'
                                          : slot.startsWith('B')
                                              ? 'Floor B'
                                              : 'Floor C',
                                      style: const TextStyle(
                                        fontSize: 11,
                                        color: Colors.white60,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),

                      const SizedBox(height: 12),
                      const Text('Only available slots are shown.'),

                      const SizedBox(height: 16),
                      SizedBox(
                        width: 220,
                        child: ElevatedButton(
                          onPressed: () async {
                            final plate = plateController.text.trim();
                            if (plate.isEmpty || selectedSlot == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Enter plate and pick a slot'),
                                ),
                              );
                              return;
                            }

                            try {
                              await parkingService.checkIn(plate, selectedSlot!);
                              if (!mounted) return;

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Checked in to $selectedSlot'),
                                ),
                              );

                              Navigator.pop(context);
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(e.toString())),
                              );
                            }
                          },
                          child: const Text('Confirm check in'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
