import 'package:appli_music/Auth/register.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:fluttertoast/fluttertoast.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.title});

  final String title;

  @override
  State<LoginPage> createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const LoginPage(title: 'Login'),
    const RegisterPage(title: 'Register')
  ];

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
            child:  Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: singIn,
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
                      text:  "Vous n'avez pas encore de compte ? ",
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
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color.fromARGB(255, 211, 211, 211),
        // Plus de 3 éléments
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorite',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,       
      ),
    );
  }

  void _onItemTapped(int index) {
  setState(() {
    _selectedIndex = index;
  });
}


  void singIn() async {
    String email = _emailController.text;
    String password = _passwordController.text;
    try {

        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      
       print('Connexion réussie ******************************************** !');
    
    } on FirebaseAuthException catch (e) {

      if(e.code == 'invalid-email'){
        print("L'email n'est pas au bon format");
      }
      else if(e.code == 'invalid-credential'){
        print('Email ou mot de passe incorrect. ********************************');
      }
      else{
        print("Veuillez entrer votre email et votre mot de passe");
      }
    } catch (e) {
      print(e);
    }
  }


    void _showToast(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: const Text('Les mots de passe ne correspondent pas'),
        action: SnackBarAction(label: '', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }
}
