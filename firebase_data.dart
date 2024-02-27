// import 'package:firebase_auth/firebase_auth.dart';

// final currentUser = FirebaseAuth.instance.currentUser!;
// final FirebaseAuth _auth = FirebaseAuth.instance;

// // getCurrentUseData() async {
// //   final User user = _auth.currentUser!;
// //   final uid = user.uid;
// //   final CollectionReference documentReference = FirebaseFirestore.instance.collection("Users");

// //   final QuerySnapshot querySnapshot = await documentReference.where("uid", isEqualTo: uid).get();

// // // Get the first document from the query results
// //   final DocumentSnapshot documentSnapshot = querySnapshot.docs.first;

// //   final String name = documentSnapshot['Username'];
// //   return name;
// // }

// getCurrentUserUid() async {
//   final User user = _auth.currentUser!;
//   final uid = user.uid;

//   return uid;
// }

// getCurrentEmail() async {
//   final User user = _auth.currentUser!;
//   final uemail = user.email;
//   return uemail;
// }
