// import 'dart:async';

// ignore_for_file: non_constant_identifier_names, avoid_print, file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cold_shower/modeles/utilisateur.dart';
import 'package:cold_shower/utils/sharedPref.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthentification {
  final FirebaseAuth _authentificationFirebase = FirebaseAuth.instance;
  static final FirebaseFirestore bdd = FirebaseFirestore.instance;

  Future<String> connexion(String email, String mdp) async {
    await _authentificationFirebase.signInWithEmailAndPassword(
        email: email, password: mdp);
    return _authentificationFirebase.currentUser!.uid;
  }

  Future<String> inscription(String email, String mdp, String nom) async {
    try {
      await _authentificationFirebase.createUserWithEmailAndPassword(
          email: email, password: mdp);
      //createUserWithEmailAndPassword modifie _authentificationFirebase.currentUser
      String id = _authentificationFirebase.currentUser!.uid;
      Utilisateur user = Utilisateur();
      user.id = id;
      bdd.collection('user').add(user.toMap());
      SharedPref.saveUuid(id);
    } on FirebaseAuthException catch (e) {
      return e.message!;
    }
    return 'Inscription réussi';
  }

  Future deconnecter() async {
    await _authentificationFirebase.signOut();
    SharedPref.removeUuid();
  }

  void updateNomFirebase(String id, String nom) async {
    QuerySnapshot querySnap = await FirebaseFirestore.instance
        .collection('user')
        .where('id', isEqualTo: id)
        .get();
    String idDoc = querySnap.docs[0].reference.id;
    FirebaseFirestore.instance
        .collection('user')
        .doc(idDoc)
        .update({'nom': nom});
  }

  void updatePrenomFirebase(String id, String prenom) async {
    QuerySnapshot querySnap = await FirebaseFirestore.instance
        .collection('user')
        .where('id', isEqualTo: id)
        .get();
    String idDoc = querySnap.docs[0].reference.id;
    FirebaseFirestore.instance
        .collection('user')
        .doc(idDoc)
        .update({'prenom': prenom});
  }
}
