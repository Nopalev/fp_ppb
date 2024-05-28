import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fp_ppb/component/app_bar.dart';
import 'package:fp_ppb/component/button.dart';
import 'package:fp_ppb/component/square_tile.dart';
import 'package:fp_ppb/component/text_field.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Profile'),
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SquareTile(
                  imagePath: 'lib/assets/logo.png',
                  size: 160,
                ),
                const SizedBox(height: 30),
                CustomTextField(
                  controller: usernameController,
                  hintText: FirebaseAuth.instance.currentUser!.displayName,
                ),
                const SizedBox(height: 8),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                        'Forgot Password?'
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Button(
                  childText: 'Update Profile',
                  onTap: () async {
                    await FirebaseAuth.instance.currentUser!.updateDisplayName(usernameController.text);
                    setState(() {});
                  }
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
