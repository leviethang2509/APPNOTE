import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/note.dart';
import '../providers/note_provider.dart';
import '../providers/theme_provider.dart';
import '../utils/app_toast.dart';
import '../widgets/note_card.dart';
import 'note_editor_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selectedTag = 'All';

  DateTime? fromDate;
  DateTime? toDate;

  final List<String> tags = [
    'All',
    'Work',
    'Contacts',
    'Shopping',
    'Books',
    'Meeting',
  ];

  @override
  Widget build(BuildContext context) {
    final noteProvider = context.watch<NoteProvider>();
    final themeProvider = context.watch<ThemeProvider>();

    final bool isDark = themeProvider.isDark;

    final Color backgroundColor =
    isDark ? const Color(0xFF101727) : Colors.white;

    final Color cardColor =
    isDark ? const Color(0xFF1B2435) : Colors.grey.shade200;

    final Color textColor = isDark ? Colors.white : Colors.black;

    List<Note> notes = noteProvider.notes;

    // Filter by tag
    if (selectedTag != 'All') {
      notes = notes.where((note) => note.tag == selectedTag).toList();
    }

    // Filter by date
    if (fromDate != null) {
      notes = notes.where(
            (note) => note.updatedAt.isAfter(
          fromDate!.subtract(const Duration(days: 1)),
        ),
      ).toList();
    }

    if (toDate != null) {
      notes = notes.where(
            (note) => note.updatedAt.isBefore(
          toDate!.add(const Duration(days: 1)),
        ),
      ).toList();
    }

    return Scaffold(
      backgroundColor: backgroundColor,

      // =========================
      // APP BAR
      // =========================

      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        centerTitle: true,
        title: Column(
          children: [
            Text(
              'Simple Note App',
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Lê Việt Thắng - 2224802010263',
              style: TextStyle(
                color: textColor.withOpacity(0.6),
                fontSize: 12,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              context.read<ThemeProvider>().toggleTheme();
            },
            icon: Icon(
              isDark ? Icons.light_mode : Icons.dark_mode,
              color: textColor,
            ),
          ),
        ],
      ),

      // =========================
      // BODY
      // =========================

      body: Column(
        children: [
          // SEARCH
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              style: TextStyle(color: textColor),
              decoration: InputDecoration(
                hintText: 'Search notes...',
                hintStyle: TextStyle(
                  color: textColor.withOpacity(0.5),
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: textColor.withOpacity(0.7),
                ),
                filled: true,
                fillColor: cardColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: noteProvider.searchNotes,
            ),
          ),

          // FILTERS
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                // TAG DROPDOWN
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedTag,
                        dropdownColor: cardColor,
                        style: TextStyle(color: textColor),
                        iconEnabledColor: textColor,
                        isExpanded: true,
                        items: tags.map((tag) {
                          return DropdownMenuItem(
                            value: tag,
                            child: Text(tag),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedTag = value!;
                          });
                        },
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // CLEAR FILTER
                IconButton(
                  onPressed: () {
                    setState(() {
                      selectedTag = 'All';
                      fromDate = null;
                      toDate = null;
                    });

                    noteProvider.clearSearch();

                    AppToast.show('Filters cleared');
                  },
                  icon: Icon(
                    Icons.refresh,
                    color: textColor,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // DATE FILTERS
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: _buildDateButton(
                    label: fromDate == null
                        ? 'From Date'
                        : DateFormat('dd/MM/yyyy').format(fromDate!),
                    textColor: textColor,
                    backgroundColor: cardColor,
                    onTap: () async {
                      final pickedDate = await showDatePicker(
                        context: context,
                        initialDate: fromDate ?? DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2035),
                      );

                      if (pickedDate != null) {
                        setState(() {
                          fromDate = pickedDate;
                        });
                      }
                    },
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: _buildDateButton(
                    label: toDate == null
                        ? 'To Date'
                        : DateFormat('dd/MM/yyyy').format(toDate!),
                    textColor: textColor,
                    backgroundColor: cardColor,
                    onTap: () async {
                      final pickedDate = await showDatePicker(
                        context: context,
                        initialDate: toDate ?? DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2035),
                      );

                      if (pickedDate != null) {
                        setState(() {
                          toDate = pickedDate;
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // NOTES LIST
          Expanded(
            child: notes.isEmpty
                ? Center(
              child: Text(
                'No Notes Found',
                style: TextStyle(
                  color: textColor.withOpacity(0.7),
                  fontSize: 16,
                ),
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.only(bottom: 90),
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final note = notes[index];

                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: NoteCard(
                    note: note,

                    // OPEN NOTE
                    onTap: () async {
                      if (note.locked &&
                          note.password != null &&
                          note.password!.isNotEmpty) {
                        final unlocked =
                        await _showPasswordDialog(note);

                        if (!unlocked) return;
                      }

                      if (!mounted) return;

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              NoteEditorScreen(existing: note),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),

      // =========================
      // FLOATING ACTION BUTTON
      // =========================

      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF3566CC),
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const NoteEditorScreen(),
            ),
          );
        },
      ),
    );
  }

  // =========================
  // DATE BUTTON
  // =========================

  Widget _buildDateButton({
    required String label,
    required Color textColor,
    required Color backgroundColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          style: TextStyle(color: textColor),
        ),
      ),
    );
  }

  // =========================
  // PASSWORD DIALOG
  // =========================

  Future<bool> _showPasswordDialog(Note note) async {
    final TextEditingController controller = TextEditingController();

    String? errorText;

    return await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Enter Password'),

              content: TextField(
                controller: controller,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Password',
                  errorText: errorText,
                ),
              ),

              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: const Text('Cancel'),
                ),

                ElevatedButton(
                  onPressed: () {
                    final inputPassword = controller.text.trim();

                    if (inputPassword == note.password) {
                      AppToast.show('Unlocked successfully');

                      Navigator.pop(context, true);
                    } else {
                      AppToast.show('Wrong password');

                      setState(() {
                        errorText = 'Incorrect password';
                      });
                    }
                  },
                  child: const Text('Unlock'),
                ),
              ],
            );
          },
        );
      },
    ) ??
        false;
  }
}