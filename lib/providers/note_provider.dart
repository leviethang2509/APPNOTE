import 'package:flutter/material.dart';

import '../database/db_helper.dart';
import '../models/note.dart';

class NoteProvider extends ChangeNotifier {
  final DatabaseHelper _db = DatabaseHelper.instance;

  // =========================
  // VARIABLES
  // =========================

  List<Note> _notes = [];

  String _searchQuery = '';

  bool _isLoading = false;

  // =========================
  // GETTERS
  // =========================

  bool get isLoading => _isLoading;

  List<Note> get notes {
    List<Note> filteredNotes = [..._notes];

    // SEARCH FILTER
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();

      filteredNotes = filteredNotes.where((note) {
        return note.title.toLowerCase().contains(query) ||
            note.content.toLowerCase().contains(query) ||
            note.tag.toLowerCase().contains(query);
      }).toList();
    }

    // SORT PINNED + LATEST
    filteredNotes.sort((a, b) {
      if (a.pinned != b.pinned) {
        return a.pinned ? -1 : 1;
      }

      return b.updatedAt.compareTo(a.updatedAt);
    });

    return filteredNotes;
  }

  // =========================
  // LOAD NOTES
  // =========================

  Future<void> loadNotes() async {
    _setLoading(true);

    try {
      _notes = await _db.getAllNotes();
    } catch (e) {
      debugPrint('Load Notes Error: $e');
    }

    _setLoading(false);
  }

  // =========================
  // ADD NOTE
  // =========================

  Future<void> addNote(Note note) async {
    try {
      await _db.insertNote(note);

      await loadNotes();
    } catch (e) {
      debugPrint('Add Note Error: $e');
    }
  }

  // =========================
  // UPDATE NOTE
  // =========================

  Future<void> updateNote(Note note) async {
    try {
      await _db.updateNote(note);

      await loadNotes();
    } catch (e) {
      debugPrint('Update Note Error: $e');
    }
  }

  // =========================
  // DELETE NOTE
  // =========================

  Future<void> deleteNote(int id) async {
    try {
      await _db.deleteNote(id);

      _notes.removeWhere(
            (note) => note.id == id,
      );

      notifyListeners();
    } catch (e) {
      debugPrint('Delete Note Error: $e');
    }
  }

  // =========================
  // DELETE ALL NOTES
  // =========================

  Future<void> deleteAllNotes() async {
    try {
      await _db.deleteAllNotes();

      _notes.clear();

      notifyListeners();
    } catch (e) {
      debugPrint('Delete All Notes Error: $e');
    }
  }

  // =========================
  // SEARCH NOTES
  // =========================

  void searchNotes(String query) {
    _searchQuery = query;

    notifyListeners();
  }

  // =========================
  // CLEAR SEARCH
  // =========================

  void clearSearch() {
    _searchQuery = '';

    notifyListeners();
  }

  // =========================
  // TOGGLE PIN
  // =========================

  Future<void> togglePin(Note note) async {
    try {
      final updatedNote = Note(
        id: note.id,
        title: note.title,
        content: note.content,
        tag: note.tag,
        pinned: !note.pinned,
        locked: note.locked,
        password: note.password,
        updatedAt: DateTime.now(),
      );

      await updateNote(updatedNote);
    } catch (e) {
      debugPrint('Toggle Pin Error: $e');
    }
  }

  // =========================
  // TOGGLE LOCK
  // =========================

  Future<void> toggleLock(Note note) async {
    try {
      final updatedNote = Note(
        id: note.id,
        title: note.title,
        content: note.content,
        tag: note.tag,
        pinned: note.pinned,
        locked: !note.locked,
        password: note.password,
        updatedAt: DateTime.now(),
      );

      await updateNote(updatedNote);
    } catch (e) {
      debugPrint('Toggle Lock Error: $e');
    }
  }

  // =========================
  // GET NOTE BY ID
  // =========================

  Note? getNoteById(int id) {
    try {
      return _notes.firstWhere(
            (note) => note.id == id,
      );
    } catch (e) {
      return null;
    }
  }

  // =========================
  // SET LOADING
  // =========================

  void _setLoading(bool value) {
    _isLoading = value;

    notifyListeners();
  }
}