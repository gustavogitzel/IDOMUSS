import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:idomuss/models/cliente.dart';

abstract class BaseAuth {
  Future signIn(String email, String password);

  Future signUp(String email, String password, Cliente client);

  Future<FirebaseUser> getCurrentUser();

  Future signOut();

  Future deleteUser();

  Future signInWithGoogle();

  Future signOutGoogle();
}
