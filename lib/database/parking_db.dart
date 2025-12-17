import 'db_helper.dart';

class ParkingDB {
  /// insert new check in
  static Future<void> insertTicket({
    required String plate,
    required String slot,
    required String timeIn,
  }) async {
    final db = await DBHelper.database;

    await db.insert(
      'parking_tickets',
      {
        'plate': plate,
        'slot': slot,
        'time_in': timeIn,
        'time_out': null,
        'fee': null,
      },
    );
  }

  /// get active (not checked out) ticket
  static Future<Map<String, dynamic>?> getActiveTicket(
    String plate,
  ) async {
    final db = await DBHelper.database;

    final result = await db.query(
      'parking_tickets',
      where: 'plate = ? AND time_out IS NULL',
      whereArgs: [plate],
      limit: 1,
    );

    if (result.isEmpty) return null;
    return result.first;
  }

  /// update ticket on checkout
  static Future<void> checkoutTicket({
    required String plate,
    required String timeOut,
    required double fee,
  }) async {
    final db = await DBHelper.database;

    await db.update(
      'parking_tickets',
      {
        'time_out': timeOut,
        'fee': fee,
      },
      where: 'plate = ? AND time_out IS NULL',
      whereArgs: [plate],
    );
  }
}
