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
  });
}

class ParkingService {
  // parking slots (same as Python repo)
  final List<String> _slots = [
    'A1','A2','A3','A4','A5','A6',
    'B1','B2','B3','B4','B5','B6',
    'C1','C2','C3','C4','C5','C6',
  ];

  final List<ParkingTicket> _activeTickets = [];

  /// get first available slot
  String? _getAvailableSlot() {
    final usedSlots = _activeTickets.map((t) => t.slot).toSet();
    for (final slot in _slots) {
      if (!usedSlots.contains(slot)) {
        return slot;
      }
    }
    return null;
  }

  /// CHECK IN
  Future<ParkingTicket> checkIn(String plateNumber) async {
    final slot = _getAvailableSlot();
    if (slot == null) {
      throw Exception('Parking is full');
    }

    final ticket = ParkingTicket(
      plateNumber: plateNumber,
      slot: slot,
      timeIn: DateTime.now(),
    );

    // save to database
    await ParkingDB.insertTicket(
      plate: plateNumber,
      slot: slot,
      timeIn: ticket.timeIn.toIso8601String(),
    );

    _activeTickets.add(ticket);
    return ticket;
  }

  /// CHECK OUT
  Future<ParkingTicket> checkOut(String plateNumber) async {
    final ticket = _activeTickets.firstWhere(
      (t) => t.plateNumber == plateNumber,
      orElse: () => throw Exception('Car not found'),
    );

    ticket.timeOut = DateTime.now();

    final duration = ticket.timeOut!.difference(ticket.timeIn);
    final hours = duration.inMinutes / 60;

    final billedHours = hours.ceil() < 1 ? 1 : hours.ceil();
    ticket.totalFee = billedHours * 30.0;

    // update database
    await ParkingDB.checkoutTicket(
      plate: plateNumber,
      timeOut: ticket.timeOut!.toIso8601String(),
      fee: ticket.totalFee!,
    );

    _activeTickets.remove(ticket);
    return ticket;
  }

  // dashboard helpers
  int get totalSlots => _slots.length;
  int get occupiedSlots => _activeTickets.length;
  int get availableSlots => totalSlots - occupiedSlots;
}
