import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:idomussprofissional/models/profissional.dart';
import 'package:idomussprofissional/services/baseAuth.dart';
import 'package:idomussprofissional/services/database.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService implements BaseAuth {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Profissional _profissional;

  Future<FirebaseUser> getCurrentUser() async {
    return _auth.currentUser();
  }

  Stream<FirebaseUser> get user {
    return _auth.onAuthStateChanged;
  }

  Stream<Profissional> get profissional {
    return Stream.value(_profissional);
  }

  Future signIn(String email, String password) async {
    try {
      var result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;

      _profissional = await DatabaseService(uid: user.uid).getProfissional();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signUp(
      String email, String password, Profissional profissional) async {
    try {
      var result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      /*_auth.verifyPhoneNumber(
          phoneNumber: profissional.numeroCelular,
          timeout:  const Duration(minutes: 2),
          verificationCompleted: (credential) async{
            await (await _auth.currentUser()).updatePhoneNumberCredential(credential);
          },
          codeSent: (verificationId, [forceResendingToken]) async {
            String smsCode;
            final AuthCredential credential =
            PhoneAuthProvider.getCredential(verificationId: verificationId, smsCode: smsCode);
            await (await _auth.currentUser()).updatePhoneNumberCredential(credential);
          }
      );*/

      FirebaseUser user = result.user;
      user.sendEmailVerification();

      UserUpdateInfo updateInfo = new UserUpdateInfo();
      updateInfo.displayName = profissional.nome;
      updateInfo.photoUrl =
          await uploadPic(profissional.fotoFile, result.user.uid);

      user.updateProfile(updateInfo);
      profissional.foto = updateInfo.photoUrl;

      _profissional = profissional;
      await DatabaseService(uid: user.uid).updateUserData(profissional);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<String> uploadPic(File image, String uid) async {
    String fileName =
        uid + basename(image.path).substring(basename(image.path).indexOf('.'));
    StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child("profissionais/" + fileName);
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(image);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    return await firebaseStorageRef.getDownloadURL();
  }

  Future updateEmail(String newEmail) async {
    try {
      (await _auth.currentUser()).updateEmail(newEmail);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future updatePassword(String newPassword) async {
    try {
      (await _auth.currentUser()).updatePassword(newPassword);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future deleteUser() async {
    try {
      FirebaseUser user = (await _auth.currentUser());
      DatabaseService(uid: user.uid).deleteUserData();
      user.delete();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //forgot password
  Future resetPassword(String email) {
    _auth.sendPasswordResetEmail(email: email);
  }

  // using google
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future signInWithGoogle() async {
    try {
      final GoogleSignInAccount googleSignInAccount =
          await googleSignIn.signIn();

      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final AuthResult authResult =
          await _auth.signInWithCredential(credential);
      final FirebaseUser user = authResult.user;

      _profissional = await DatabaseService(uid: user.uid).getProfissional();

      _profissional.email = user.email;
      _profissional.nome = user.displayName;
      _profissional.foto = user.photoUrl;
      _profissional.numeroCelular = user.phoneNumber;
    } catch (erro) {
      print(erro);
      return null;
    }
  }

  Future signOutGoogle() async {
    await googleSignIn.signOut();
  }
}
