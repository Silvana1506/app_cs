import 'package:cronosalud/MainScreens/login/login_screen.dart';
import 'package:cronosalud/MainScreens/widgets/design_widgets.dart';
import 'package:cronosalud/Utils/logingoogleutils.dart';
import 'package:cronosalud/Utils/textapp.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

_drawerHome(BuildContext context, Color colorHeader) {
  return Drawer(
    child: ListView(
      children: [
        DrawerHeader(
          decoration: BoxDecoration(
            gradient: Designwidgets.linearGradientMain(context),
          ),
          child: Text(
            'Nombre de Usuario',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
            ),
          ),
        ),
        //cerrar sesión
        ListTile(
            onTap: () => {
                  LoginGoogleUtils().signOutGoogle(),
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return LoginScreen();
                      },
                    ),
                  )
                },
            leading: Icon(Icons.logout),
            title: Text(
              TextApp.logout,
              style: TextStyle(color: Colors.black),
            ))
      ],
    ),
  );
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(),
      drawer: _drawerHome(context, Colors.black),
    );
  }
}
