import 'package:elades20/models/user_model.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class AuthServices{
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   //regis
//   Future<UserModel?> register(String email, String password) async{
//     try{
//       UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//       return UserModel(uid: userCredential.user!.uid, email: email);
//     } catch (e){
//       print(e.toString());
//       return null;
//     }
//   }

//   //login
//   Future<UserModel?> login(String email, String password) async{
//     try{
//       UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//       return UserModel(uid: userCredential.user!.uid, email: email);
//     } catch (e){
//       print(e.toString());
//       return null;
//     }
//   }

//   //logout
//   Future<void> logout() async{
//     await _auth.signOut();
//   }
// }