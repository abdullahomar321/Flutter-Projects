import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ecom_app/signin.dart';
import 'package:ecom_app/success.dart';
import 'package:ecom_app/home.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Verify extends StatefulWidget {
  final String email;
  final String username;

  const Verify({super.key,required this.email,required this.username});

  @override
  State<Verify> createState() => _VerifyState();
}

class _VerifyState extends State<Verify> {
  final TextEditingController otpController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  String? _verificationId;
  String _statusMessage = '';

  @override
  void dispose() {
    otpController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  Future<void> _verifyPhoneNumber() async {
    String phone = phoneController.text.trim();

    if (phone.isEmpty || phone.length < 11) {
      setState(() {
        _statusMessage = "Enter a valid phone number";
      });
      return;
    }

    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+92$phone',
        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseAuth.instance.signInWithCredential(credential);
          setState(() {
            _statusMessage = "Phone number auto-verified successfully.";
          });
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const success()),
          );
        },
        verificationFailed: (FirebaseAuthException e) {
          setState(() {
            _statusMessage = 'Verification failed: ${e.message}';
          });
        },
        codeSent: (String verificationId, int? resendToken) {
          setState(() {
            _verificationId = verificationId;
            _statusMessage = 'OTP sent successfully to +92$phone';
          });
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          setState(() {
            _verificationId = verificationId;
            _statusMessage = 'Auto retrieval timed out. Please enter OTP manually.';
          });
        },
      );
    } catch (e) {
      setState(() {
        _statusMessage = "Error during phone verification: $e";
      });
    }
  }

  Future<void> _verifyOTP() async {
    final otp = otpController.text.trim();

    if (otp.isEmpty || otp.length < 6) {
      setState(() {
        _statusMessage = "Enter a valid 6-digit OTP";
      });
      return;
    }

    if (_verificationId == null) {
      setState(() {
        _statusMessage = "OTP not sent yet. Please send OTP first.";
      });
      return;
    }

    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: otp,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
      setState(() {
        _statusMessage = "OTP verified successfully.";
      });

      await FirebaseFirestore.instance.collection("Users").doc("logininfo").set(
        {
          'logins': FieldValue.arrayUnion([
            {
              'email': widget.email,
              'username': widget.username,
            }
          ])
        },SetOptions(merge: true));




      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const success()),
      );
    } catch (e) {
      setState(() {
        _statusMessage = "OTP verification failed: ${e.toString()}";
      });
    }




  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 100,
            backgroundColor: Colors.blueAccent,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const signin()),
                  );
                },
                icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 30),
              ),
            ),
            pinned: true,
            flexibleSpace: const FlexibleSpaceBar(
              title: Text(
                'Verification',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w400),
              ),
              centerTitle: true,
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => home()),
                    );
                  },
                  icon: const Icon(Icons.home_filled, color: Colors.black, size: 30),
                ),
              ),
            ],
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 15)),

          SliverToBoxAdapter(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  _statusMessage,
                  style: const TextStyle(fontSize: 18, color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),


          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextField(
                controller: phoneController,
                decoration: const InputDecoration(
                  hintText: 'Enter phone number',
                  suffixIcon: Icon(Icons.call, size: 30, color: Colors.black),
                  hintStyle: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
                ),
                keyboardType: TextInputType.number,
              ),
            ),
          ),


          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: _verifyPhoneNumber,
                child: const Text(
                  'Send OTP',
                  style: TextStyle(fontSize: 30, fontFamily: 'Jost', fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
            ),
          ),


          const SliverToBoxAdapter(child: SizedBox(height: 15)),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextField(
                controller: otpController,
                decoration: const InputDecoration(
                  hintText: 'Enter OTP',
                  suffixIcon: Icon(Icons.email, size: 30, color: Colors.black),
                  hintStyle: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
                ),
                keyboardType: TextInputType.number,
              ),
            ),
          ),


          const SliverToBoxAdapter(child: SizedBox(height: 30)),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: _verifyOTP,
                child: const Text(
                  'Verify',
                  style: TextStyle(fontSize: 30, fontFamily: 'Jost', fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
