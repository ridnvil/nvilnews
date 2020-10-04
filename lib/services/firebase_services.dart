import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Nvil{

    final GoogleSignIn _googleSignIn = GoogleSignIn();
    final FirebaseAuth _auth = FirebaseAuth.instance;

    final FirebaseOptions options = new FirebaseOptions(
      appId: '1:803376804112:android:495d51a4b2fce93998f595',
      apiKey: 'AIzaSyDjdg9KOY6fxrKZdCJBdyaZbiKNsQYzjX8',
      projectId: 'nvilnews',
      messagingSenderId: '803376804112',
    );

    Future<User> handleSignIn() async {

      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;

      // ignore: deprecated_member_use
      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final User user = (await _auth.signInWithCredential(credential)).user;

      return user;
    }

    Future<User> autoSignin(User currentUser) async {
      User userLogin;
      _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) async {

        if (currentUser != null) {
          handleSignIn().then((User user) {
            userLogin = user;
          }).catchError((e) => print("Error : $e"));
        } else {
          final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
          final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
          // ignore: deprecated_member_use
          final AuthCredential credential = GoogleAuthProvider.getCredential(
            accessToken: googleAuth.accessToken,
            idToken: googleAuth.idToken,
          );
          userLogin = (await _auth.signInWithCredential(credential)).user;
        }
      });

      return userLogin;
    }

    Future silent() {
      _googleSignIn.signInSilently();
    }

    Future signOut() async {
      await _googleSignIn.signOut();
      await _auth.signOut();
    }
}