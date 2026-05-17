import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/note.dart';
import 'web_database.dart';

class DatabaseHelper {
  // Singleton
  DatabaseHelper._internal();

  static final DatabaseHelper instance = DatabaseHelper._internal();

  static Database? _database;
  static bool _webInitialized = false;

  // Table name
  static const String tableNotes = 'notes';

  // Column names
  static const String colId = 'id';
  static const String colTitle = 'title';
  static const String colContent = 'content';
  static const String colTag = 'tag';
  static const String colPinned = 'pinned';
  static const String colLocked = 'locked';
  static const String colPassword = 'password';
  static const String colUpdatedAt = 'updatedAt';

  // Get database (mobile only)
  Future<Database> get database async {
    if (kIsWeb) {
      throw UnsupportedError('Use WebDatabase for web platform');
    }
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  // Initialize database (mobile only)
  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'notes.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  // Create table
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableNotes (
        $colId INTEGER PRIMARY KEY AUTOINCREMENT,
        $colTitle TEXT NOT NULL,
        $colContent TEXT NOT NULL,
        $colTag TEXT,
        $colPinned INTEGER DEFAULT 0,
        $colLocked INTEGER DEFAULT 0,
        $colPassword TEXT,
        $colUpdatedAt TEXT NOT NULL
      )
    ''');
  }

  // =========================
  // CRUD OPERATIONS
  // =========================

  // Insert note
  Future<int> insertNote(Note note) async {
    if (kIsWeb) {
      return await _webDb.insertNote(note);
    }

    final dbClient = await database;
    return await dbClient.insert(
      tableNotes,
      note.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Get all notes
  Future<List<Note>> getAllNotes() async {
    if (kIsWeb) {
      return await _webDb.getAllNotes();
    }

    final dbClient = await database;
    final result = await dbClient.query(
      tableNotes,
      orderBy: '$colPinned DESC, $colUpdatedAt DESC',
    );
    return result.map((e) => Note.fromMap(e)).toList();
  }

  // Get note by ID
  Future<Note?> getNoteById(int id) async {
    if (kIsWeb) {
      return await _webDb.getNoteById(id);
    }

    final dbClient = await database;
    final result = await dbClient.query(
      tableNotes,
      where: '$colId = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (result.isNotEmpty) {
      return Note.fromMap(result.first);
    }
    return null;
  }

  // Update note
  Future<int> updateNote(Note note) async {
    if (kIsWeb) {
      return await _webDb.updateNote(note);
    }

    final dbClient = await database;
    return await dbClient.update(
      tableNotes,
      note.toMap(),
      where: '$colId = ?',
      whereArgs: [note.id],
    );
  }

  // Delete note
  Future<int> deleteNote(int id) async {
    if (kIsWeb) {
      return await _webDb.deleteNote(id);
    }

    final dbClient = await database;
    return await dbClient.delete(
      tableNotes,
      where: '$colId = ?',
      whereArgs: [id],
    );
  }

  // Delete all notes
  Future<int> deleteAllNotes() async {
    if (kIsWeb) {
      return await _webDb.deleteAllNotes();
    }

    final dbClient = await database;
    return await dbClient.delete(tableNotes);
  }

  // Search notes
  Future<List<Note>> searchNotes(String keyword) async {
    if (kIsWeb) {
      return await _webDb.searchNotes(keyword);
    }

    final dbClient = await database;
    final result = await dbClient.query(
      tableNotes,
      where: '$colTitle LIKE ? OR $colContent LIKE ?',
      whereArgs: ['%$keyword%', '%$keyword%'],
      orderBy: '$colUpdatedAt DESC',
    );
    return result.map((e) => Note.fromMap(e)).toList();
  }

  // Close database
  Future<void> closeDatabase() async {
    if (kIsWeb) return;

    final dbClient = await database;
    await dbClient.close();
    _database = null;
  }

  // =========================
  // WEB DATABASE HELPER
  // =========================

  WebDatabase get _webDb => WebDatabase.instance;
}