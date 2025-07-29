import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NoteProvider with ChangeNotifier {
  List<String> _notes = [];

  List<String> get notes => _notes;

  Future<void> loadNotes() async {
    final prefs = await SharedPreferences.getInstance();
    _notes = prefs.getStringList('notes') ?? [];
    notifyListeners();
  }

  Future<void> addNote(String note) async {
    final prefs = await SharedPreferences.getInstance();
    _notes.add(note);
    await prefs.setStringList('notes', _notes);
    notifyListeners();
  }

  Future<void> updateNoteAt(int index, String updatedNote) async {
    if (index < 0 || index >= _notes.length) return;
    final prefs = await SharedPreferences.getInstance();
    _notes[index] = updatedNote;
    await prefs.setStringList('notes', _notes);
    notifyListeners();
  }

  Future<void> deleteNoteAt(int index) async {
    if (index < 0 || index >= _notes.length) return;
    final prefs = await SharedPreferences.getInstance();
    _notes.removeAt(index);
    await prefs.setStringList('notes', _notes);
    notifyListeners();
  }

  Future<void> clearNotes() async {
    final prefs = await SharedPreferences.getInstance();
    _notes.clear();
    await prefs.remove('notes');
    notifyListeners();
  }
}
