import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:notifyme/noteprovider.dart';

class SavedNotes extends StatelessWidget {
  const SavedNotes({super.key});

  @override
  Widget build(BuildContext context) {
    final noteProvider = Provider.of<NoteProvider>(context);

    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 100,
            pinned: true,
            backgroundColor: Colors.blueGrey,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, size: 30, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: const FlexibleSpaceBar(
              centerTitle: true,
              title: Text(
                "Saved Notes",
                style: TextStyle(
                  fontFamily: 'Bubblegum_Sans',
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: noteProvider.notes.isEmpty
                  ? const Center(
                child: Text(
                  "No notes saved yet.",
                  style: TextStyle(
                    fontFamily: 'Bubblegum_Sans',
                    fontSize: 18,
                    color: Colors.white70,
                  ),
                ),
              )
                  : Column(
                children: List.generate(noteProvider.notes.length, (index) {
                  final note = noteProvider.notes[index];
                  return Card(
                    color: Colors.black87,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 6,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        note,
                        style: const TextStyle(
                          fontFamily: 'Bubblegum_Sans',
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
