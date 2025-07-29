import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:notifyme/noteprovider.dart';

class EditNotes extends StatefulWidget {
  const EditNotes({super.key});

  @override
  State<EditNotes> createState() => _EditNotesState();
}

class _EditNotesState extends State<EditNotes> {
  @override
  void initState() {
    super.initState();
    Provider.of<NoteProvider>(context, listen: false).loadNotes();
  }

  @override
  Widget build(BuildContext context) {
    final noteProvider = Provider.of<NoteProvider>(context);

    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            floating: true,
            backgroundColor: Colors.blueGrey,
            expandedHeight: 120,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'Edit Notes',
                style: TextStyle(
                  fontFamily: 'Bubblegum_Sans',
                  fontSize: 34,
                  color: Colors.white,
                ),
              ),
              centerTitle: true,
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                final note = noteProvider.notes[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  elevation: 5,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    title: Text(
                      note,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 18,
                        fontFamily: 'Bubblegum_Sans',
                      ),
                    ),
                    trailing: Wrap(
                      spacing: 8,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.visibility),
                          onPressed: () => _viewNote(context, note),
                          tooltip: 'View',
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _editNoteDialog(context, index, noteProvider),
                          tooltip: 'Edit',
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _confirmDelete(context, index, noteProvider),
                          tooltip: 'Delete',
                        ),
                      ],
                    ),
                  ),
                );
              },
              childCount: noteProvider.notes.length,
            ),
          ),
        ],
      ),
    );
  }

  void _viewNote(BuildContext context, String note) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.blueGrey[50],
        title: const Text(
          'View Note',
          style: TextStyle(fontFamily: 'Bubblegum_Sans'),
        ),
        content: Text(note, style: const TextStyle(fontFamily: 'Bubblegum_Sans')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close', style: TextStyle(fontFamily: 'Bubblegum_Sans')),
          ),
        ],
      ),
    );
  }

  void _editNoteDialog(BuildContext context, int index, NoteProvider provider) {
    final controller = TextEditingController(text: provider.notes[index]);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.blueGrey[50],
        title: const Text(
          'Edit Note',
          style: TextStyle(fontFamily: 'Bubblegum_Sans'),
        ),
        content: TextField(
          controller: controller,
          maxLines: null,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Update your note',
          ),
          style: const TextStyle(fontFamily: 'Bubblegum_Sans'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(fontFamily: 'Bubblegum_Sans')),
          ),
          ElevatedButton(
            onPressed: () {
              provider.updateNoteAt(index, controller.text);
              Navigator.pop(context);
            },
            child: const Text('Save', style: TextStyle(fontFamily: 'Bubblegum_Sans')),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, int index, NoteProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.blueGrey[50],
        title: const Text(
          'Delete Note?',
          style: TextStyle(fontFamily: 'Bubblegum_Sans'),
        ),
        content: const Text(
          'Are you sure you want to delete this note?',
          style: TextStyle(fontFamily: 'Bubblegum_Sans'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(fontFamily: 'Bubblegum_Sans')),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              provider.deleteNoteAt(index);
              Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(fontFamily: 'Bubblegum_Sans')),
          ),
        ],
      ),
    );
  }
}
