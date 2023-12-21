import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key, required this.title});

  final String title;

  @override
  State<RegisterPage> createState() => _RegisterPage();
}

class _RegisterPage extends State<RegisterPage> {

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _emailController.dispose();
    _confirmPasswordController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    Widget title = Container(
      alignment: Alignment.topCenter,
      constraints: const BoxConstraints(maxHeight: 170.0),
      padding: const EdgeInsets.all(16.0),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Créer votre compte',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ],
      ),
    );

    Widget form = Column(
      children: [
        Container(
            padding: const EdgeInsets.all(16.0),
            child : TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                hintText: 'Entrer votre email',
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return "Merci d'entrer une adresse email";
                }
                return null;
              },
            )
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            child : TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(
                hintText: 'Entrer votre mot de passe',
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return "Merci d'entrer un mot de passe";
                }
                return null;
              },
            )
          ),
           Container(
            padding: const EdgeInsets.all(16.0),
            child : TextFormField(
               controller: _confirmPasswordController,
              decoration: const InputDecoration(
                hintText: 'Confirmer le mot de passe',
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return "Merci de confirmer le mot de passe";
                }
                return null;
              },
            )
          ),
           Container(
            padding: const EdgeInsets.all(16.0),
            child:  Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: singUp,
                child: const Text('Valider'),
              ),
            ),
           ),
            Container(
            padding: const EdgeInsets.all(16.0),
            child:  Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: RichText(
                  text: TextSpan(children: [
                    const TextSpan(
                      text: 'Vous avez déjà un compte ? ',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    TextSpan(
                        text: 'Se connecter',
                        style: const TextStyle(
                          color: Colors.blue,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.pushNamed(context, '/login');
                          }),
                  ]),
                ),
              ),
            ),
      ]
    );

   return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: [
            title,
            Expanded(
              child: form,
            ),
          ],
        ),
      ),
    );
  }


  void singUp() async {
    String email = _emailController.text;
    String password = _passwordController.text;
    try {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }
}
