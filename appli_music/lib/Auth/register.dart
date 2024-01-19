import 'package:appli_music/Auth/music_style.dart';
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

  bool isPasswordValid = true;
  bool isSamePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _confirmPasswordController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

   void validatePassword(String value) {
    setState(() {
      isPasswordValid = value.isEmpty || value.length >= 6;
    });
  }

   void samePassword(String value) {
    setState(() {
      isSamePassword = value == _passwordController.text;
    });
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
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
      ],
    ),
  );

  Widget form = Column(
    children: [
      Container(
        padding: const EdgeInsets.all(16.0),
        child: TextFormField(
          controller: _emailController,
          decoration: InputDecoration(
            hintText: 'Entrer votre email',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.all(12.0),
          ),
          validator: (String? value) {
            if (value == null || value.isEmpty) {
              return "Merci d'entrer une adresse email";
            }
            return null;
          },
        ),
      ),
      Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Entrer votre mot de passe',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.all(12.0),
              ),
              onChanged: validatePassword,
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return "Merci d'entrer un mot de passe";
                }
                return null;
              },
            ),
            const SizedBox(height: 8),
            if (!isPasswordValid)
              const Text(
                'Le mot de passe est trop court',
                style: TextStyle(color: Colors.red),
              ),
          ],
        ),
      ),
      Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: _confirmPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Confirmez le mot de passe',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.all(12.0),
              ),
              onChanged: samePassword,
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return "Merci d'entrer un mot de passe";
                }
                return null;
              },
            ),
            const SizedBox(height: 8),
            if (!isSamePassword)
              const Text(
                'Les mots de passe ne sont pas identiques',
                style: TextStyle(color: Colors.red),
              ),
          ],
        ),
      ),
      Container(
        padding: const EdgeInsets.all(16.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: ElevatedButton(
            onPressed: singUp,
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
            ),
            child: const Text(
              'Valider',
              style: TextStyle(fontSize: 15),
            ),
          ),
        ),
      ),
      Container(
        padding: const EdgeInsets.all(16.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: RichText(
            text: TextSpan(children: [
              const TextSpan(
                text: 'Vous avez déjà un compte ? ',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
              TextSpan(
                text: 'Se connecter',
                style: const TextStyle(
                  color: Colors.blue,
                  fontSize: 16,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    Navigator.pushNamed(context, '/login');
                  },
              ),
            ]),
          ),
        ),
      ),
    ],
  );

  return Scaffold(
    resizeToAvoidBottomInset: false,
    appBar: AppBar(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      title: Text(
        widget.title,
        style: const TextStyle(fontSize: 20),
      ),
      centerTitle: true,
      automaticallyImplyLeading: false,
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

  void isCreatedNavigation(userId){

     Navigator.pushReplacement( 
        context, 
        MaterialPageRoute( 
          builder: (context) => 
              MusicStyle(title: 'Styles', id: userId), 
        ), 
     );
  }

  void singUp() async {
    String email = _emailController.text;
    String password = _passwordController.text;
    String checkPassword = _confirmPasswordController.text;
    try {
      if(password == checkPassword){

        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Récupérer l'ID de l'utilisateur nouvellement créé
        String userId = userCredential.user?.uid ?? "";

        isCreatedNavigation(userId);
      }
      else{
        _showToast(context, 'Les mots de passe ne correspondent pas');
      }

    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        _showToast(context, 'Le mot de passe est trop court');
      } else if (e.code == 'email-already-in-use') {
        _showToast(context, 'Ce compte existe déjà');
      }
    } catch (e) {
      print(e);
    }
  }
  


  void _showToast(BuildContext context, String message) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(message),
        action: SnackBarAction(label: '', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }
}
