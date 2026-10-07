// lib/models/my_transaction.dart

enum TransactionType { income, expense }

class MyTransaction {
  final int? id;
  final String title;
  final double amount;
  final DateTime date;
  final TransactionType type;

  MyTransaction({
    this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.type,
  });

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id, // ป้องกันการส่ง id เป็น null ไปเปลี่ยน Primary Key[cite: 36, 42]
      'title': title,
      'amount': amount,
      'date': date.toIso8601String(),
      'type': type.name, // บันทึกเป็น 'income' หรือ 'expense'[cite: 36]
    };
  }

  factory MyTransaction.fromMap(Map<String, dynamic> map) {
    return MyTransaction(
      id: map['id'] as int,
      title: map['title'] as String,
      amount: (map['amount'] as num).toDouble(), // แปลงผ่าน num เพื่อรองรับกรณีค่าใน DB เป็น integer[cite: 36]
      date: DateTime.parse(map['date'] as String),
      type: TransactionType.values.byName(map['type'] as String),
    );
  }
}