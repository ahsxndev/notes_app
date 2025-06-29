import 'package:flutter/material.dart';
import 'package:notes_app/database/notes_database.dart';
import 'package:notes_app/widgets/note_dialog.dart';
import '../widgets/note_card.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> with SingleTickerProviderStateMixin {
  List<Map<String, dynamic>> notes = [];

  late AnimationController _fabController;
  late Animation<double> _fabAnimation;

  @override
  void initState() {
    super.initState();
    fetchNotes();

    _fabController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true); // Continuous pulse

    _fabAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(
        parent: _fabController,
        curve: Curves.easeInOut,
      ),
    );
  }




  @override
  void dispose() {
    _fabController.dispose();
    super.dispose();
  }

  Future<void> fetchNotes() async {
    final fetchNotes = await NotesDatabase.instance.getNotes();
    setState(() {
      notes = fetchNotes;
    });
  }

  final List<Color> noteColors = [
    const Color(0xFFF3E5F5), const Color(0xFFFFF3E0), const Color(0xFFE1F5FE),
    const Color(0xFFFCE4EC), const Color(0xFF89CFF0), const Color(0xFFFFABAB),
    const Color(0xFFB2F9FC), const Color(0xFFFF059A), const Color(0xFFFFE4B5),
    const Color(0xFF98FB98), const Color(0xFFFFD700), const Color(0xFFAFEEEE),
    const Color(0xFFFFB6C1), const Color(0xFFFAFAD2), const Color(0xFFD3D3D3),
  ];

  void showNoteDialog({int? id, String? title, String? content, int colorIndex = 0}) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return NoteDialog(
          colorIndex: colorIndex,
          noteColors: noteColors,
          noteId: id,
          title: title,
          content: content,
          onNoteSaved: (newTitle, newDescription, selectedColorIndex, currentDate) async {
            if (id == null) {
              await NotesDatabase.instance.addNote(
                  newTitle, newDescription, currentDate, selectedColorIndex);
            } else {
              await NotesDatabase.instance.updateNotes(
                  newTitle, newDescription, currentDate, selectedColorIndex, id);
            }
            fetchNotes();
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleSpacing: 24,
        title: const Text(
          'My Notes',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 28,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      floatingActionButton: ScaleTransition(
        scale: _fabAnimation,
        child: FloatingActionButton.extended(
          onPressed: () => showNoteDialog(),
          backgroundColor: Colors.black87,
          foregroundColor: Colors.white,
          icon: const Icon(Icons.add),
          label: const Text('Add Note'),
          elevation: 6,
        ),
      ),



      body: notes.isEmpty
          ? Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.sticky_note_2_outlined,
                  size: 100, color: Colors.grey[500]),
              const SizedBox(height: 20),
              Text(
                'No notes yet.\nTap "+" to create your first note!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      )
          : Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: GridView.builder(
          itemCount: notes.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.85,
          ),
          itemBuilder: (context, index) {
            final note = notes[index];
            return NoteCard(
              note: note,
              onDelete: () async {
                await NotesDatabase.instance.deleteNote(note['id']);
                fetchNotes();
              },
              onTap: () {
                showNoteDialog(
                  id: note['id'],
                  title: note['title'],
                  content: note['description'],
                  colorIndex: note['color'],
                );
              },
              noteColors: noteColors,
            );
          },
        ),
      ),
    );
  }
}
