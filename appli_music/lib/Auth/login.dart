import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.title});

  final String title;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _emailController.dispose();
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
            'Connectez-vous !',
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
          child:  const Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              onPressed: signUp,
              child: Text('Valider'),
            ),
          ),
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            child:  RichText(
              text: TextSpan(children: [
                const TextSpan(
                  text: "Vous n'avez pas encore de compte ? ",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                TextSpan(
                    text: "S'inscrire",
                    style: const TextStyle(
                      color: Colors.blue,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.pushNamed(context, '/register');
                      }),
              ]),
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
}

void signUp(){

}