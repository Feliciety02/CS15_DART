import '../database/parking_db.dart';

class ParkingTicket {
  final String plateNumber;
  final String slot;
  final DateTime timeIn;
  DateTime? timeOut;
  double? totalFee;

  ParkingTicket({
    required this.plateNumber,
    required this.slot,
    required this.timeIn,
    this.timeOut,
    this.totalFee,
  });
}

class ParkingService {
  final List<String> _slots = [
    'A1','A2','A3','A4','A5','A6',
    'B1','B2','B3','B4','B5','B6',
    'C1','C2','C3','C4','C5','C6',
  ];

  Future<List<String>> getAvailableSlots() async {
    final active = await ParkingDB.getActiveTickets();
    final used = active.map((t) => (t['slot'] as String)).toSet();
    return _slots.where((s) => !used.contains(s)).toList();
  }

  Future<int> getTotalSlots() async => _slots.length;

  Future<int> getOccupiedCount() async {
    final active = await ParkingDB.getActiveTickets();
    return active.length;
  }

  Future<int> getAvailableCount() async {
    final occupied = await getOccupiedCount();
    return _slots.length - occupied;
  }

  Future<ParkingTicket> checkIn(String plateNumber, String slot) async {
    final available = await getAvailableSlots();
    if (!available.contains(slot)) {
      throw Exception('Slot already occupied');
    }

    final ticket = ParkingTicket(
      plateNumber: plateNumber,
      slot: slot,
      timeIn: DateTime.now(),
    );

    await ParkingDB.insertTicket(
      plate: plateNumber,
      slot: slot,
      timeIn: ticket.timeIn.toIso8601String(),
    );

    return ticket;
  }

  Future<ParkingTicket> checkOut(String plateNumber) async {
    final active = await ParkingDB.getActiveTicket(plateNumber);
    if (active == null) {
      throw Exception('Car not found or already checked out');
    }

    final slot = active['slot'] as String;
    final timeInStr = active['time_in'] as String;
    final timeIn = DateTime.parse(timeInStr);

    final timeOut = DateTime.now();
    final hours = timeOut.difference(timeIn).inMinutes / 60;
    final billedHours = hours.ceil() < 1 ? 1 : hours.ceil();
    final fee = billedHours * 30.0;

    await ParkingDB.checkoutTicket(
      plate: plateNumber,
      timeOut: timeOut.toIso8601String(),
      fee: fee,
    );

    return ParkingTicket(
      plateNumber: plateNumber,
      slot: slot,
      timeIn: timeIn,
      timeOut: timeOut,
      totalFee: fee,
    );
  }
}
