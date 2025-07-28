import 'package:flutter/material.dart';
import 'package:notifyme/addnotes.dart';
import 'package:notifyme/intro.dart';
import 'package:notifyme/savednotes.dart';
import 'package:notifyme/editnotes.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double circleSize = screenWidth * 0.4;

    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 100,
            pinned: true,
            backgroundColor: Colors.blueGrey,
            automaticallyImplyLeading: false,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const intro()),
                );
              },
            ),
            flexibleSpace: const FlexibleSpaceBar(
              centerTitle: true,
              title: Text(
                "Your DashBoard",
                style: TextStyle(
                  fontFamily: 'Bubblegum_Sans',
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _circleItem("Saved Notes", circleSize, context, goToSavedNotes: true),
                  _circleItem("Add Notes", circleSize, context, goToAddNotes: true),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _circleItem("Edit Notes", circleSize, context, goToEditNotes: true),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _circleItem(
      String label,
      double size,
      BuildContext context, {
        bool goToAddNotes = false,
        bool goToSavedNotes = false,
        bool goToEditNotes = false,
      }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          if (goToAddNotes) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Addnotes()),
            );
          } else if (goToSavedNotes) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SavedNotes()),
            );
          } else if (goToEditNotes) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const EditNotes()),
            );
          }
        },
        borderRadius: BorderRadius.circular(size / 2),
        child: Container(
          height: size,
          width: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.yellow,
            boxShadow: const [
              BoxShadow(
                blurRadius: 20,
                color: Colors.white,
              ),
            ],
          ),
          child: Center(
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Bubblegum_Sans',
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
