// lib/providers/transaction_provider.dart

import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/my_transaction.dart';

class TransactionProvider with ChangeNotifier {
  static const String _dbName = 'expenses.db';
  static const String _tableName = 'transactions';
  Database? _database;
  List<MyTransaction> _transactions = [];

  List<MyTransaction> get transactions => [..._transactions];

  TransactionProvider() {
    fetchAndSetTransactions(); // โหลดข้อมูลเมื่อ Provider ถูกสร้าง
  }

  // กระบวนการที่ 2: การเปิด/สร้างฐานข้อมูล[cite: 37]
  Future<void> _initDatabase() async {
    if (_database != null) return;
    try {
      final dbPath = await getDatabasesPath();
      final path = join(dbPath, _dbName);
      _database = await openDatabase(
        path,
        version: 1,
        onCreate: (db, version) {
          print('Creating table $_tableName...');
          return db.execute(
            'CREATE TABLE $_tableName(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, amount REAL, date TEXT, type TEXT)',
          );
        },
      );
      print('Database initialized at $path');
    } catch (e) {
      print('Error initializing database: $e');
    }
  }

  // กระบวนการที่ 3: เพิ่มข้อมูล (Insert)[cite: 37, 38]
  Future<void> addTransaction(
    String title,
    double amount,
    DateTime date,
    TransactionType type,
  ) async {
    await _initDatabase();
    if (_database == null) return;

    final newTransaction = MyTransaction(
      title: title,
      amount: amount,
      date: date,
      type: type,
    );

    final id = await _database!.insert(_tableName, newTransaction.toMap());
    print('Inserted transaction with id: $id');
    await fetchAndSetTransactions(); // ดึงข้อมูลล่าสุดทันทีหลังเพิ่ม[cite: 38, 40]
  }

  // กระบวนการที่ 4: อ่านข้อมูล (Read)[cite: 39, 40]
  Future<void> fetchAndSetTransactions() async {
    await _initDatabase();
    if (_database == null) return;

    final dataList = await _database!.query(_tableName, orderBy: 'date DESC');
    _transactions = dataList.map((item) => MyTransaction.fromMap(item)).toList();
    print('Fetched ${_transactions.length} transactions.');
    notifyListeners(); // แจ้ง UI ให้รีเฟรช[cite: 40]
  }

  // กระบวนการที่ 5: แก้ไขข้อมูล (Update)[cite: 41, 42]
  Future<void> updateTransaction(int id, MyTransaction newTransaction) async {
    await _initDatabase();
    if (_database == null) return;

    await _database!.update(
      _tableName,
      newTransaction.toMap(),
      where: 'id = ?',
      whereArgs: [id],
    );
    await fetchAndSetTransactions();
  }

  // กระบวนการที่ 6: ลบข้อมูล (Delete)[cite: 41, 42]
  Future<void> deleteTransaction(int id) async {
    await _initDatabase();
    if (_database == null) return;

    await _database!.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
    await fetchAndSetTransactions();
  }
}