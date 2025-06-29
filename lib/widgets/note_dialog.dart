import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NoteDialog extends StatefulWidget {
  final int? noteId;
  final String? title;
  final String? content;
  final int? colorIndex;
  final List<Color> noteColors;
  final Function onNoteSaved;

  const NoteDialog({
    super.key,
    this.noteId,
    this.title,
    this.content,
    required this.colorIndex,
    required this.noteColors,
    required this.onNoteSaved,
  });

  @override
  State<NoteDialog> createState() => _NoteDialogState();
}

class _NoteDialogState extends State<NoteDialog> {
  late int _selectedColorIndex;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _selectedColorIndex = widget.colorIndex!;
  }

  @override
  Widget build(BuildContext context) {
    final currentDate = DateFormat('E d MMM').format(DateTime.now());
    final titleController = TextEditingController(text: widget.title);
    final descriptionController = TextEditingController(text: widget.content);

    return AlertDialog(
      backgroundColor: widget.noteColors[_selectedColorIndex],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      titlePadding: const EdgeInsets.fromLTRB(24, 20, 24, 10),
      contentPadding: const EdgeInsets.symmetric(horizontal: 24),
      actionsPadding: const EdgeInsets.only(right: 16, bottom: 10),

      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              widget.noteId == null ? 'Add Note' : 'Edit Note',
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            currentDate,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 13,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),

      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Material(
              color: Colors.white,
              elevation: 1,
              shadowColor: Colors.black12,
              borderRadius: BorderRadius.circular(12),
              child: TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  hintText: 'Enter title',
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  labelStyle: const TextStyle(
                    color: Colors.black87,           // Professional black for label
                    fontWeight: FontWeight.w500,
                  ),
                  hintStyle: TextStyle(
                    color: Colors.grey[500],         // Softer grey for hint
                    fontStyle: FontStyle.italic,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  filled: true,
                  fillColor: Colors.white,
                ),
              )

            ),
            const SizedBox(height: 16),
            Material(
              color: Colors.white,
              elevation: 1,
              shadowColor: Colors.black12,
              borderRadius: BorderRadius.circular(12),
              child: TextField(
                controller: descriptionController,
                maxLines: 5,
                decoration: InputDecoration(
                  labelText: 'Description',
                  hintText: 'Enter description',
                  alignLabelWithHint: true,
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  labelStyle: const TextStyle(
                    color: Colors.black87,           // Strong, readable label
                    fontWeight: FontWeight.w500,
                  ),
                  hintStyle: TextStyle(
                    color: Colors.grey[500],         // Lighter hint for subtle prompt
                    fontStyle: FontStyle.italic,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  filled: true,
                  fillColor: Colors.white,
                ),
              )
            ),
            const SizedBox(height: 16),
            const Text(
              'Pick a Color',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: List.generate(
                widget.noteColors.length,
                    (index) => GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedColorIndex = index;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: _selectedColorIndex == index
                          ? Border.all(color: Colors.black87, width: 2)
                          : null,
                    ),
                    child: CircleAvatar(
                      backgroundColor: widget.noteColors[index],
                      radius: 16,
                      child: _selectedColorIndex == index
                          ? const Icon(
                        Icons.check,
                        color: Colors.black87,
                        size: 16,
                      )
                          : null,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),

      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            'Cancel',
            style: TextStyle(color: Colors.black54),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black87,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          onPressed: () async {
            final newTitle = titleController.text.trim();
            final newDescription = descriptionController.text.trim();

            if (newTitle.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Title cannot be empty'),
                  backgroundColor: Colors.redAccent,
                  behavior: SnackBarBehavior.floating,
                  duration: Duration(seconds: 2),
                ),
              );
              return;
            }

            widget.onNoteSaved(
              newTitle,
              newDescription,
              _selectedColorIndex,
              currentDate,
            );
            Navigator.pop(context);
          },
          child: const Text(
            'Save',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ),

      ],
    );
  }
}
