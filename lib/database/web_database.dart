import 'dart:convert';
import 'dart:html' show window;

import 'package:flutter/foundation.dart';

import '../models/note.dart';
import 'db_helper.dart';

/// Web-based database using localStorage to persist note data.
class WebDatabase {
  WebDatabase._internal();
  static final WebDatabase instance = WebDatabase._internal();

  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;
    _initialized = true;
    _store.loadFromLocalStorage();
  }

  Future<int> insertNote(Note note) async {
    await initialize();
    final id = _store.add(note.toMap());
    _store.persist();
    debugPrint('[WebDatabase] insertNote: ${note.title} -> id=$id');
    return id;
  }

  Future<List<Note>> getAllNotes() async {
    await initialize();
    final maps = _store.getAll();
    final notes =
        maps.map((m) => Note.fromMap(Map<String, dynamic>.from(m))).toList();
    debugPrint('[WebDatabase] getAllNotes: ${notes.length} notes');
    return notes;
  }

  Future<Note?> getNoteById(int id) async {
    await initialize();
    final map = _store.getById(id);
    if (map != null) return Note.fromMap(Map<String, dynamic>.from(map));
    return null;
  }

  Future<int> updateNote(Note note) async {
    await initialize();
    _store.put(note.toMap(), note.id!);
    _store.persist();
    debugPrint('[WebDatabase] updateNote: id=${note.id}');
    return 1;
  }

  Future<int> deleteNote(int id) async {
    await initialize();
    _store.delete(id);
    _store.persist();
    debugPrint('[WebDatabase] deleteNote: id=$id');
    return 1;
  }

  Future<int> deleteAllNotes() async {
    await initialize();
    _store.clear();
    _store.persist();
    debugPrint('[WebDatabase] deleteAllNotes');
    return 1;
  }

  Future<List<Note>> searchNotes(String keyword) async {
    await initialize();
    final kw = keyword.toLowerCase();
    return _store
        .getAll()
        .map((m) => Note.fromMap(Map<String, dynamic>.from(m)))
        .where((n) =>
            n.title.toLowerCase().contains(kw) ||
            n.content.toLowerCase().contains(kw))
        .toList();
  }

  _LocalStore get _store => _LocalStore.instance;
}

/// Singleton localStorage-backed store.
/// Uses dart:html (available in Flutter web builds).
class _LocalStore {
  _LocalStore._internal();
  static final _LocalStore instance = _LocalStore._internal();

  static const String _storageKey = 'simple_notes_data';

  int _nextId = 1;
  final Map<int, Map<String, dynamic>> _data = {};

  static final bool _isWeb = kIsWeb;

  void loadFromLocalStorage() {
    _data.clear();
    _nextId = 1;

    if (!_isWeb) return;

    try {
      final raw = window.localStorage[_storageKey];
      if (raw != null && raw.isNotEmpty) {
        final decoded = jsonDecode(raw) as Map<String, dynamic>;
        _nextId = decoded['nextId'] as int? ?? 1;
        final items = decoded['items'] as List<dynamic>? ?? [];
        for (final item in items) {
          final map = Map<String, dynamic>.from(item as Map);
          final id = map['id'] as int;
          _data[id] = map;
        }
        debugPrint('[LocalStore] loaded ${_data.length} notes');
      } else {
        debugPrint('[LocalStore] no saved data (key not found)');
      }
    } catch (e) {
      debugPrint('[LocalStore] load error: $e');
    }
  }

  void persist() {
    if (!_isWeb) return;

    try {
      final items = _data.values.toList();
      final payload = jsonEncode({'nextId': _nextId, 'items': items});
      window.localStorage[_storageKey] = payload;
      debugPrint('[LocalStore] persisted ${items.length} notes');
    } catch (e) {
      debugPrint('[LocalStore] persist error: $e');
    }
  }

  int add(Map<String, dynamic> data) {
    final record = Map<String, dynamic>.from(data);

    // Check if id is already set
    final existingId = record['id'];
    if (existingId != null && existingId is int) {
      _data[existingId] = record;
      return existingId;
    }

    final id = _nextId++;
    record['id'] = id;
    _data[id] = record;
    return id;
  }

  List<Map<String, dynamic>> getAll() => _data.values.toList();

  Map<String, dynamic>? getById(int id) => _data[id];

  void put(Map<String, dynamic> data, int key) {
    final record = Map<String, dynamic>.from(data);
    record['id'] = key;
    _data[key] = record;
  }

  void delete(int key) => _data.remove(key);

  void clear() {
    _data.clear();
    _nextId = 1;
    window.localStorage.remove(_storageKey);
    debugPrint('[LocalStore] cleared all data');
  }
}