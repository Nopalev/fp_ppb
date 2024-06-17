import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fp_ppb/component/app_bar.dart';
import 'package:fp_ppb/component/button.dart';
import 'package:fp_ppb/component/square_tile.dart';
import 'package:fp_ppb/component/text_field.dart';
import 'package:fp_ppb/database/player.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final PlayerDatabase playerDatabase = PlayerDatabase();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordConfirmationController = TextEditingController();

  void userRegister() async {
    showDialog(
        context: context,
        builder: (context){
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
    );

    try {
      if(passwordController.text == passwordConfirmationController.text){
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: emailController.text,
            password: passwordController.text
        );
      }
      else{
        throw Exception('Password confirmation mismatched :(');
      }
      if(mounted){
        Navigator.pop(context);
      }
    } on FirebaseAuthException catch (error){
      if(mounted){
        Navigator.pop(context);
      }
      showErrorMessage(error.code);
    } catch (error){
      if(mounted){
        Navigator.pop(context);
      }
      showErrorMessage(error.toString());
    }

    FirebaseAuth.instance.currentUser!.updateDisplayName(usernameController.text);

    playerDatabase.create(FirebaseAuth.instance.currentUser!.uid);

    if(mounted && FirebaseAuth.instance.currentUser != null){
      Navigator.pushNamedAndRemoveUntil(context, '/home', (r) => false);
    }
  }

  void showErrorMessage(String message) {
    List<String> splitted = message.split('-');
    message = splitted.join(' ');
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).primaryColor,
          title: Center(
            child: Text(
              message,
              textAlign: TextAlign.center,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Register',
      ),
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
                  size: 80,
                ),
                const SizedBox(height: 15),
                CustomTextField(
                  controller: usernameController,
                  hintText: 'Username',
                ),
                const SizedBox(height: 6),
                CustomTextField(
                  controller: emailController,
                  hintText: 'Email',
                ),
                const SizedBox(height: 6),
                CustomTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),
                const SizedBox(height: 6),
                CustomTextField(
                  controller: passwordConfirmationController,
                  hintText: 'Confirm Password',
                  obscureText: true,
                ),
                const SizedBox(height: 20),
                Button(
                    childText: 'Register',
                    onTap: userRegister
                ),
                const SizedBox(height: 20),
                const Row(
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                          'Or Continue with'
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const SquareTile(
                  imagePath: 'lib/assets/google.png',
                  size: 50,
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Already have an account?',
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () async {
                        await Navigator.pushReplacementNamed(context, '/login');
                      },
                      child: const Text(
                        'Login now',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
