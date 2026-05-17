import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/note.dart';
import '../providers/note_provider.dart';
import '../providers/theme_provider.dart';
import '../utils/app_toast.dart';

class NoteEditorScreen extends StatefulWidget {
  final Note? existing;

  const NoteEditorScreen({
    super.key,
    this.existing,
  });

  @override
  State<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends State<NoteEditorScreen> {
  final TextEditingController titleController = TextEditingController();

  final TextEditingController contentController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final List<String> tags = [
    'Work',
    'Contacts',
    'Shopping',
    'Books',
    'Meeting',
  ];

  String selectedTag = 'Work';

  bool isPinned = false;
  bool isLocked = false;

  @override
  void initState() {
    super.initState();

    final note = widget.existing;

    if (note != null) {
      titleController.text = note.title;
      contentController.text = note.content;

      selectedTag = note.tag;

      isPinned = note.pinned;
      isLocked = note.locked;

      passwordController.text = note.password ?? '';
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final noteProvider = context.read<NoteProvider>();

    final bool isDark =
        context.watch<ThemeProvider>().isDark;

    final Color backgroundColor =
    isDark ? const Color(0xFF101727) : Colors.white;

    final Color cardColor =
    isDark ? const Color(0xFF1B2435) : Colors.grey.shade200;

    final Color textColor =
    isDark ? Colors.white : Colors.black;

    return Scaffold(
      backgroundColor: backgroundColor,

      // =========================
      // APP BAR
      // =========================

      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,

        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: textColor,
          ),
        ),

        title: Text(
          widget.existing == null
              ? 'New Note'
              : 'Edit Note',
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        ),

        actions: [
          if (widget.existing != null)
            IconButton(
              onPressed: () async {
                final confirmDelete =
                await _showDeleteDialog();

                if (!confirmDelete) return;

                await noteProvider.deleteNote(
                  widget.existing!.id!,
                );

                AppToast.show(
                  'Note deleted successfully',
                );

                if (mounted) {
                  Navigator.pop(context);
                }
              },
              icon: Icon(
                Icons.delete_outline,
                color: textColor,
              ),
            ),
        ],
      ),

      // =========================
      // BODY
      // =========================

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // TITLE
              TextField(
                controller: titleController,
                style: TextStyle(
                  color: textColor,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                decoration: InputDecoration(
                  hintText: 'Title',
                  hintStyle: TextStyle(
                    color: textColor.withOpacity(0.5),
                  ),
                  border: InputBorder.none,
                ),
              ),

              const SizedBox(height: 12),

              // TAG + OPTIONS
              Row(
                children: [
                  // TAG DROPDOWN
                  Expanded(
                    child: Container(
                      padding:
                      const EdgeInsets.symmetric(
                        horizontal: 12,
                      ),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius:
                        BorderRadius.circular(12),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedTag,
                          dropdownColor: cardColor,
                          style: TextStyle(
                            color: textColor,
                          ),
                          iconEnabledColor:
                          textColor,
                          isExpanded: true,
                          items: tags.map((tag) {
                            return DropdownMenuItem(
                              value: tag,
                              child: Text(tag),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedTag =
                                  value ?? 'Work';
                            });
                          },
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  // PIN BUTTON
                  IconButton(
                    onPressed: () {
                      setState(() {
                        isPinned = !isPinned;
                      });
                    },
                    icon: Icon(
                      isPinned
                          ? Icons.push_pin
                          : Icons.push_pin_outlined,
                      color: isPinned
                          ? Colors.orange
                          : textColor,
                    ),
                  ),

                  // LOCK BUTTON
                  IconButton(
                    onPressed: () {
                      setState(() {
                        isLocked = !isLocked;

                        if (!isLocked) {
                          passwordController.clear();
                        }
                      });
                    },
                    icon: Icon(
                      isLocked
                          ? Icons.lock
                          : Icons.lock_open,
                      color: isLocked
                          ? Colors.redAccent
                          : textColor,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // PASSWORD FIELD
              if (isLocked)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                  ),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius:
                    BorderRadius.circular(12),
                  ),
                  child: TextField(
                    controller: passwordController,
                    obscureText: true,
                    style: TextStyle(
                      color: textColor,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText:
                      'Enter password...',
                      hintStyle: TextStyle(
                        color:
                        textColor.withOpacity(0.5),
                      ),
                      icon: Icon(
                        Icons.password,
                        color: textColor,
                      ),
                    ),
                  ),
                ),

              const SizedBox(height: 16),

              // CONTENT
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius:
                    BorderRadius.circular(16),
                  ),
                  child: TextField(
                    controller: contentController,
                    maxLines: null,
                    expands: true,
                    textAlignVertical:
                    TextAlignVertical.top,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 16,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText:
                      'Write your note here...',
                      hintStyle: TextStyle(
                        color:
                        textColor.withOpacity(0.5),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      // =========================
      // SAVE BUTTON
      // =========================

      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF3566CC),
        onPressed: () async {
          await _saveNote(noteProvider);
        },
        icon: const Icon(
          Icons.save,
          color: Colors.white,
        ),
        label: const Text(
          'Save',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  // =========================
  // SAVE NOTE
  // =========================

  Future<void> _saveNote(
      NoteProvider provider,
      ) async {
    final title = titleController.text.trim();

    final content =
    contentController.text.trim();

    final password =
    passwordController.text.trim();

    // Validation
    if (title.isEmpty && content.isEmpty) {
      AppToast.show(
        'Please enter note content',
      );
      return;
    }

    if (isLocked && password.isEmpty) {
      AppToast.show(
        'Please enter a password',
      );
      return;
    }

    final note = Note(
      id: widget.existing?.id,
      title: title,
      content: content,
      tag: selectedTag,
      pinned: isPinned,
      locked: isLocked,
      password:
      isLocked ? password : null,
      updatedAt: DateTime.now(),
    );

    // Add or update
    if (widget.existing == null) {
      await provider.addNote(note);

      AppToast.show(
        'Note created successfully',
      );
    } else {
      await provider.updateNote(note);

      AppToast.show(
        'Note updated successfully',
      );
    }

    if (mounted) {
      Navigator.pop(context);
    }
  }

  // =========================
  // DELETE DIALOG
  // =========================

  Future<bool> _showDeleteDialog() async {
    return await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Delete Note?',
          ),
          content: const Text(
            'This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  context,
                  false,
                );
              },
              child: const Text(
                'Cancel',
              ),
            ),

            ElevatedButton(
              onPressed: () {
                Navigator.pop(
                  context,
                  true,
                );
              },
              child: const Text(
                'Delete',
              ),
            ),
          ],
        );
      },
    ) ??
        false;
  }
}