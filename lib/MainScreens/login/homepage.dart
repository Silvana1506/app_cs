import 'package:cronosalud/MainScreens/login/localauth.dart';
import 'package:flutter/material.dart';

//llama a biometric metodo
class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  bool auth = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('BiometricApp'),
          centerTitle: true,
        ),
        floatingActionButton: auth == true
            ? null
            : FloatingActionButton(
                onPressed: () async {
                  final authen = await LocalAuth.authenticate();
                  setState(() {
                    auth = authen;
                  });
                },
                child: const Icon(Icons.fingerprint),
              ),
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (!auth)
                const Icon(
                  Icons.warning,
                  size: 60,
                ),
              if (auth) const Icon(Icons.check_circle, size: 60),
              if (auth)
                ElevatedButton(
                    onPressed: () {
                      setState(() {
                        auth = false;
                      });
                      // Redirige a la pantalla de inicio de sesión
                      //Navigator.pushReplacement(
                      // context,
                      //MaterialPageRoute(builder: (context) => LoginScreen()),
                      //);
                    },
                    child: const Text('Remove Auth'))
            ],
          ),
        ));
  }
}
