import 'package:firebase_auth/firebase_auth.dart';

class AuthRepo {
  static Future<void> signUpWithEmailAndPassword(email, password) async {
    final auth = FirebaseAuth.instance;
    await auth.createUserWithEmailAndPassword(email: email, password: password);
  }

  static Future<void> logOut()async {
    await FirebaseAuth.instance.signOut();
  }

  static Future<void> signInWithEmailAndPassword(email, password) async {
    final auth = FirebaseAuth.instance;
    await auth.signInWithEmailAndPassword(email: email, password: password);
  }

  static Future<void> reloadUser() async {
    await FirebaseAuth.instance.currentUser!.reload();
  }

  static Future<void> updateDisplayName(name) async {
    await FirebaseAuth.instance.currentUser!.updateDisplayName(name);
  }

  static Future<void> sendVerificationEmail() async {
    final User user = FirebaseAuth.instance.currentUser!;
    try {
      await user.sendEmailVerification();
    } catch (e) {
      print(e);
    }
  }

  static Future<void> sendEmailResetPassword(email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } catch (e) {
      print(e);
    }
  }

  static Future<bool> checkVerifiedMail() async {
    User user = FirebaseAuth.instance.currentUser!;
    return user.emailVerified;
  }

  static get uid {
    final User user = FirebaseAuth.instance.currentUser!;
    return user.uid;
  }
}
