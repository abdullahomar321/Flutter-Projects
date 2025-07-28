import 'package:flutter/material.dart';
import 'package:notifyme/splash.dart';


class intro extends StatelessWidget {
  const intro({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
            expandedHeight: 70,
            backgroundColor: Colors.blueGrey,
          ),

          SliverToBoxAdapter(child: const SizedBox(height: 70)),

          SliverToBoxAdapter(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: InkWell(
                  onTap: () {
                   Navigator.push(context, MaterialPageRoute(builder: (context)=>Splash()));
                  },
                  borderRadius: BorderRadius.circular(250),
                  child: Container(
                    height: 500,
                    width: 500,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.yellow,
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 30,
                          color: Colors.black,
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text(
                        'NotifyMe',
                        style: TextStyle(
                          fontSize: 90,
                          fontFamily: 'Bubblegum_Sans',
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
