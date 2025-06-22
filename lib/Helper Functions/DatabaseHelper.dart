// This file contains all the helper functions which are required for access of the local database


import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "contacts.db");
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE contacts(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT,
      phone TEXT
    )
  ''');
  }

  String normalizeIndianPhone(String phone) {
    final digits = phone.replaceAll(RegExp(r'\D'), ''); // remove non-digits
    if (digits.length >= 10) {
      return digits.substring(digits.length - 10); // keep last 10 digits
    }
    return digits; // fallback
  }


  Future<int> insertContact(String name, String phone) async {
    final db = await database;
    final normalizedPhone = normalizeIndianPhone(phone);

    // Check if this normalized number already exists
    final existing = await db.query(
      'contacts',
      where: 'phone = ?',
      whereArgs: [normalizedPhone],
    );

    if (existing.isNotEmpty) {
      return -1; // Duplicate
    }

    Map<String, dynamic> row = {
      'name': name,
      'phone': normalizedPhone,
    };

    return await db.insert('contacts', row);
  }

  Future<List<Map<String, dynamic>>> getContacts() async {
    final db = await database;
    return await db.query('contacts');
  }

  Future<int> updateContact(int id, String name, String phone) async {
    final db = await database;
    return await db.update(
      'contacts',
      {
        'name': name,
        'phone': phone,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteContact(int id) async {
    final db = await database;
    return db.delete(
      'contacts',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

}
