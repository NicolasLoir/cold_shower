import 'package:cold_shower/modeles/utilisateur.dart';
import 'package:cold_shower/pages/authentification/page_connexion.dart';
import 'package:cold_shower/pages/page_test.dart';
import 'package:cold_shower/pages/profil/updateMail.dart';
import 'package:cold_shower/pages/profil/updatePassword.dart';
import 'package:cold_shower/utils/firebase_authentification.dart';
import 'package:cold_shower/utils/sharedPref.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';

class Profil extends StatefulWidget {
  const Profil({Key? key}) : super(key: key);

  @override
  _ProfilState createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {
  final FirebaseAuthentification authentification = FirebaseAuthentification();
  Utilisateur _user = Utilisateur()..isAnonymous = true;
  @override
  void initState() {
    super.initState();

    initProfil();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profil"),
      ),
      body: RefreshIndicator(
        child: SafeArea(
          child: monProfil(),
        ),
        onRefresh: () {
          return initProfil();
        },
      ),
    );
  }

  Future<void> initProfil() {
    return SharedPref.getUuid()
        .then((cuid) => createInstanceUser(cuid).then((utilisateur) {
              setState(() {
                _user = utilisateur;
              });
            }).catchError((error) {
              Scaffold.of(context).showSnackBar(const SnackBar(
                content:
                    Text('Erreur lors du chargement des données du profil'),
                duration: Duration(seconds: 1),
              ));
              // print(error);
            }));
  }

  Widget monProfil() {
    if (_user.isAnonymous!) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          const SizedBox(
            height: 200,
          ),
          Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.black,
              valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).colorScheme.primary),
            ),
          ),
        ],
      );
    } else {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          cardTitle("Mon compte"),
          cardOption("Adresse e-mail", _user.email!, () {
            MaterialPageRoute route =
                MaterialPageRoute(builder: (_) => UpdateMail(_user));
            Navigator.push(context, route).then((value) {
              setState(() {
                _user = _user;
              });
            }).catchError((error) {
              Scaffold.of(context).showSnackBar(const SnackBar(
                content:
                    Text('Erreur lors de la mise à jour de l\'adresse mail'),
                duration: Duration(seconds: 1),
              ));
              // print(error);
            });
          }),
          cardOption("Mot de passe", "", () {
            MaterialPageRoute route =
                MaterialPageRoute(builder: (_) => UpdatePassword(_user));
            Navigator.push(context, route).then((value) {
              setState(() {
                _user = _user;
              });
            }).catchError((error) {
              Scaffold.of(context).showSnackBar(const SnackBar(
                content: Text('Erreur lors de la mise à jour du mot de passe'),
                duration: Duration(seconds: 1),
              ));
              // print(error);
            });
          }),
          cardTitle("Action de compte"),
          cardOption("Synchroniser les données", "", () {
            MaterialPageRoute route = MaterialPageRoute(
                builder: (_) => PageTest(
                      texte:
                          "todo: creer 2 boutons. Un pour récupérer les données en ligne: écrase les données stockées en locale. Le deuxième pour envoyer les données en ligne: écrase les données sauvegarder sur firebase",
                    ));
            Navigator.push(context, route).then((value) {
              setState(() {
                _user = _user;
              });
            }).catchError((error) {
              Scaffold.of(context).showSnackBar(const SnackBar(
                content: Text('Erreur lors de la synchronisation des données'),
                duration: Duration(seconds: 1),
              ));
              // print(error);
            });
          }),
          cardOption("Déconnexion", "", () {
            authentification.deconnecter().then((resultat) {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const PageConnexion()));
            });
          }),
        ],
      );
    }
  }

  Widget cardTitle(String title) {
    return Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.grey.shade300, width: 0.5),
        borderRadius: BorderRadius.circular(0),
      ),
      margin: const EdgeInsets.all(0),
      color: Colors.grey.shade300,
      elevation: 0,
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
      ),
    );
  }

  Widget cardOption(String title, String sousTitre, Function functionOnTap) {
    return Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.grey.shade300, width: 0.5),
        borderRadius: BorderRadius.circular(0),
      ),
      margin: const EdgeInsets.all(0),
      color: Colors.white,
      elevation: 0,
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(color: Colors.black),
        ),
        trailing:
            Text(sousTitre, style: TextStyle(color: Colors.grey.shade700)),
        onTap: () {
          functionOnTap();
        },
      ),
    );
  }
}

Future<Utilisateur> createInstanceUser(String id) async {
  final _auth = FirebaseAuth.instance;
  final currentUser = _auth.currentUser!;
  String? userEmail = currentUser.email;
  Utilisateur user = Utilisateur();
  user
    ..id = id
    ..email = userEmail
    ..isAnonymous = false;
  return user;
}
