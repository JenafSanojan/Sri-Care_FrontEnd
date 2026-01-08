import 'package:sri_tel_flutter_web_mob/entities/user.dart';
import 'package:sri_tel_flutter_web_mob/widget_common/snack_bar.dart'; // Aliased for clarity

class UserService {
  // final firebase_auth.FirebaseAuth _firebaseAuth = firebase_auth.FirebaseAuth.instance;
  // final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  //
  // // Firestore collection reference for user profiles
  // late final CollectionReference<User> _usersProfileCollection;
  //
  // UserService() {
  //   _usersProfileCollection = _firestore.collection('users').withConverter<User>(
  //     fromFirestore: User.fromFirestore,
  //     toFirestore: (User user, _) {
  //       // The User.toFirestore() method should already handle not saving the password.
  //       // If it doesn't, ensure it's removed here orin the model's toFirestore().
  //       Map<String, dynamic> data = user.toFirestore();
  //       data.remove('password'); // Explicitly ensure password is not sent to Firestore
  //       return data;
  //     },
  //   );
  // }
  //
  // // on auth changes
  //
  //
  // Future<User?> signUpWithEmailAndPassword({
  //   required String email,
  //   required String password,
  //   String? displayName, // Optional: to set on Firebase Auth profile
  //   String? photoURL,    // Optional: to set on Firebase Auth profile
  //   String? defaultRoleId, // Optional: to set in the Firestore user profile
  // }) async {
  //   try {
  //     // 1. Create user with Firebase Authentication
  //     firebase_auth.UserCredential userCredential =
  //     await _firebaseAuth.createUserWithEmailAndPassword(
  //       email: email,
  //       password: password,
  //     );
  //
  //     firebase_auth.User? firebaseUser = userCredential.user;
  //
  //     if (firebaseUser != null) {
  //       // 2. Update Firebase Auth profile (optional fields)
  //       if (displayName != null || photoURL != null) {
  //         await firebaseUser.updateDisplayName(displayName);
  //         // Note: updatePhotoURL might require the URL to be valid and accessible.
  //         // For initial setup, you might handle photo uploads separately.
  //         if (photoURL != null) await firebaseUser.updatePhotoURL(photoURL);
  //       }
  //
  //       // 3. Create and save the user profile document in Firestore
  //       User newUserProfile = User(
  //         uid: firebaseUser.uid, // Use UID from Firebase Auth
  //         email: firebaseUser.email ?? '', // Ensure email is not null
  //         password: '', // Password is not stored in Firestore
  //         phoneNumber: firebaseUser.phoneNumber ?? '', // Optional, if available
  //         displayName: displayName ?? firebaseUser.displayName,
  //         photoURL: photoURL ?? firebaseUser.photoURL,
  //         roleId: defaultRoleId, // Assign a default role if provided
  //         createdAt: Timestamp.now(), // Or use FieldValue.serverTimestamp()
  //         isActive: true,
  //         isProfileComplete: false, // Or your default logic
  //         // password field in User model is NOT set here for Firestore
  //       );
  //
  //       await _usersProfileCollection.doc(firebaseUser.uid).set(newUserProfile);
  //       print('User registered with Auth and profile created in Firestore.');
  //       return newUserProfile; // Return your custom User object
  //     }
  //     return null;
  //   } on firebase_auth.FirebaseAuthException catch (e) {
  //     // Handle specific Firebase Auth errors (e.g., email-already-in-use, weak-password)
  //     print('Firebase Auth SignUp Error: ${e.message} (Code: ${e.code})');
  //     throw e; // Re-throw to be caught by the UI for user feedback
  //   } catch (e) {
  //     print('Error during sign up process: $e');
  //     throw Exception('An unexpected error occurred during sign up.');
  //   }
  // }
  //
  // Future<User?> signInWithEmailAndPassword(String email, String password) async {
  //   try {
  //     // 1. Sign in with Firebase Authentication
  //     firebase_auth.UserCredential userCredential =
  //     await _firebaseAuth.signInWithEmailAndPassword(
  //       email: email,
  //       password: password,
  //     );
  //
  //     firebase_auth.User? firebaseUser = userCredential.user;
  //
  //     if (firebaseUser != null) {
  //       // 2. Fetch the corresponding user profile from Firestore
  //       User? userProfile = await getUserProfile(firebaseUser.uid);
  //
  //       if (userProfile != null) {
  //         // Optional: Update lastSignInAt in Firestore
  //         await _usersProfileCollection.doc(firebaseUser.uid).update({
  //           'lastSignInAt': FieldValue.serverTimestamp(),
  //         });
  //         // Return the merged/updated User object
  //         return userProfile.copyWith(
  //           lastSignInAt: Timestamp.now(), // Approximate client time, server is better
  //           // You might want to refresh other fields from firebaseUser if they can change
  //           email: firebaseUser.email,
  //           displayName: firebaseUser.displayName,
  //           photoURL: firebaseUser.photoURL,
  //         );
  //       } else {
  //         CommonLoaders.errorSnackBar(title: "Something went wrong, Check your connection",
  //             message: "If this error persists, contact us. Error code: PRFMISS_${firebaseUser.uid}",
  //             duration: 5
  //         );
  //       }
  //     }
  //     return null;
  //   } on firebase_auth.FirebaseAuthException catch (e) {
  //     print('Firebase Auth SignIn Error: ${e.message} (Code: ${e.code})');
  //     throw e;
  //   } catch (e) {
  //     print('Error during sign in process: $e');
  //     throw Exception('An unexpected error occurred during sign in.');
  //   }
  // }
  //
  // Future<void> signOut() async {
  //   try {
  //     await _firebaseAuth.signOut();
  //     print('User signed out successfully.');
  //   } catch (e) {
  //     print('Error signing out: $e');
  //     throw Exception('Error signing out.');
  //   }
  // }
  //
  // firebase_auth.User? getCurrentFirebaseAuthUser() {
  //   return _firebaseAuth.currentUser;
  // }
  //
  // Future<bool> sendPasswordResetEmail(String email) async {
  //   try {
  //     await _firebaseAuth.sendPasswordResetEmail(email: email);
  //     print('Password reset email sent to $email');
  //     return true;
  //   } on firebase_auth.FirebaseAuthException catch (e) {
  //     print('Error sending password reset email: ${e.message} (Code: ${e.code})');
  //     return false;
  //   } catch (e) {
  //     print('Error sending password reset email: $e');
  //     return false;
  //   }
  // }
  //
  // Future<User?> getUserProfile(String uid) async {
  //   try {
  //     DocumentSnapshot<User> docSnap = await _usersProfileCollection.doc(uid).get();
  //     if (docSnap.exists) {
  //       return docSnap.data();
  //     } else {
  //       print('User profile not found in Firestore for UID: $uid');
  //       return null;
  //     }
  //   } catch (e) {
  //     print('Error getting user profile for UID "$uid": $e');
  //     return null; // Or throw an error
  //   }
  // }
  //
  // Stream<User?> getUserProfileStream(String uid) {
  //   if (uid.isEmpty) return Stream.value(null); // Return a stream of null if UID is empty
  //   return _usersProfileCollection.doc(uid).snapshots().map((snapshot) {
  //     if (snapshot.exists) {
  //       return snapshot.data(); // The converter handles creating the User object
  //     } else {
  //       // Document doesn't exist for this UID in the profiles collection
  //       return null;
  //     }
  //   }).handleError((error) {
  //     // Handle any errors that occur during the stream
  //     print("Error in user profile stream for UID $uid: $error");
  //     // You might want to stream an error state or just null
  //     return null;
  //   });
  // }
  //
  // Future<bool> updateFirebaseAuthProfile({
  //   String? displayName,
  //   String? photoURL,}) async {
  //   try {
  //     firebase_auth.User? currentUser = _firebaseAuth.currentUser;
  //     if (currentUser == null) {
  //       print("No authenticated user to update Firebase Auth profile.");
  //       return false;
  //     }
  //
  //     // Prepare updates
  //     if (displayName != null) {
  //       await currentUser.updateDisplayName(displayName);
  //     }
  //     if (photoURL != null) {
  //       // Ensure the photoURL is a valid URL.
  //       // Actual photo upload should be handled separately (e.g., to Firebase Storage),
  //       // and then this URL is updated.
  //       await currentUser.updatePhotoURL(photoURL);
  //     }
  //     print("Firebase Auth profile updated successfully.");
  //     // Optionally, you might want to update these in your Firestore profile as well
  //     // if you are keeping them synced.
  //     if (displayName != null || photoURL != null) {
  //       Map<String, dynamic> firestoreUpdates = {};
  //       if (displayName != null) firestoreUpdates['displayName'] = displayName;
  //       if (photoURL != null) firestoreUpdates['photoURL'] = photoURL;
  //       if (firestoreUpdates.isNotEmpty) {
  //         await _usersProfileCollection.doc(currentUser.uid).update(firestoreUpdates);
  //       }
  //     }
  //     return true;
  //   } on firebase_auth.FirebaseAuthException catch (e) {
  //     print('Firebase Auth Error updating profile: ${e.message} (Code: ${e.code})');
  //     return false;
  //   } catch (e) {
  //     print('Error updating Firebase Auth profile: $e');
  //     return false;
  //   }
  // }
  //
  // Future<bool> updateUserProfileInFirestore(User user) async {
  //   if (user.uid == null || user.uid!.isEmpty) {
  //     print('Error: User UID is required for updating Firestore profile.');
  //     return false;}
  //   try {
  //     // The `_usersProfileCollection` is already configured with a converter
  //     // that uses `User.toFirestore`. So, we can directly pass the `User` object.
  //     // The `toFirestore` method in your `User` model should handle removing the password
  //     // and preparing other fields.
  //
  //     // We'll use `set` with `SetOptions(merge: true)` to perform a partial update.
  //     // This means only the fields present in the `user.toFirestore()` map will be updated,
  //     // and other fields in the Firestoredocument will remain untouched.
  //     // If a field is explicitly set to `null` in the `User` object and then in `toFirestore()`,
  //     // it might remove that field if not handled carefully by `toFirestore` (e.g. by not including nulls).
  //
  //     // If your User model's `toFirestore` method doesn't automatically add an `updatedAt`
  //     // timestamp for updates, you might want to handle it.
  //     // However, the `withConverter` approach is cleaner if `toFirestore` is comprehensive.
  //
  //     // Let's assume User.toFirestore() correctly prepares the data,
  //     // including handling of `updatedAt` if it's a field in your model
  //     // that should be updated with FieldValue.serverTimestamp() on writes.
  //     // If not, you'd prepare a Map manually:
  //     // Map<String, dynamic> dataToUpdate = user.toFirestore();
  //     // dataToUpdate.remove('password'); // Ensure password is not there
  //     // dataToUpdate['updatedAt'] = FieldValue.serverTimestamp(); // Explicitly set updatedAt
  //     // await _usersProfileCollection.doc(user.uid).update(dataToUpdate);
  //
  //     // Using the converter directly with set and merge:
  //     await _usersProfileCollection.doc(user.uid).set(user, SetOptions(merge: true));
  //
  //     print('User profile in Firestore updated for UID: ${user.uid}');
  //     return true;
  //   } catch (e) {
  //     print('Error updating user profile in Firestore for UID "${user.uid}": $e');
  //     return false;
  //   }
  // }
  //
  // Future<bool> deactivateUserInFirestore(String uid) async {
  //   if (uid.isEmpty) {
  //     print('Error: UID is required to deactivate user.');
  //     return false;
  //   }
  //   try {
  //     await _usersProfileCollection.doc(uid).update({
  //       'isActive': false,
  //       'updatedAt': FieldValue.serverTimestamp() // Good practice to track when this happened
  //     });
  //     print('User $uid deactivated in Firestore.');
  //     return true;
  //   } catch (e) {
  //     print('Error deactivating user "$uid" in Firestore: $e');
  //     return false;
  //   }
  // }
  //
  // Future<bool> reactivateUserInFirestore(String uid) async {
  //   if (uid.isEmpty) {
  //     print('Error: UID is required to reactivate user.');
  //     return false;
  //   }
  //   try {
  //     await _usersProfileCollection.doc(uid).update({
  //       'isActive': true,
  //       'updatedAt': FieldValue.serverTimestamp() // Good practice
  //     });
  //     print('User $uid reactivated in Firestore.');
  //     return true;
  //   } catch (e) {
  //     print('Error reactivating user "$uid" in Firestore: $e');
  //     return false;
  //   }
  // }
  //
  // Future<bool> deleteUserProfileFromFirestore(String uid) async {
  //   if (uid.isEmpty) {
  //     print('Error: UID is required to delete user profile.');
  //     return false;
  //   }
  //   try {
  //     await _usersProfileCollection.doc(uid).delete();
  //     print('User profile for $uid deleted from Firestore.');
  //     return true;
  //   } catch (e) {
  //     print('Error deleting user profile "$uid" from Firestore: $e');
  //     return false;
  //   }
  // }
  //
  // Future<bool> deleteUserFromFirebaseAuth() async {
  //   try {
  //     firebase_auth.User? currentUser = _firebaseAuth.currentUser;
  //     if (currentUser == null) {
  //       print("No authenticated user to delete from Firebase Auth.");
  //       return false;
  //     }
  //     await currentUser.delete();
  //     print("User deleted from Firebase Authentication successfully.");
  //     // You should also delete their Firestore profile data at this point.
  //     // await deleteUserProfileFromFirestore(currentUser.uid); // Uncomment if needed
  //     return true;
  //   } on firebase_auth.FirebaseAuthException catch (e) {
  //     print('Firebase Auth Error deleting user: ${e.message} (Code: ${e.code})');
  //     if (e.code == 'requires-recent-login') {
  //       print("This operation is sensitive and requires recent authentication. Log in again before retrying this request.");
  //       // You might want to re-authenticate the user here.
  //     }
  //     return false;
  //   } catch (e) {
  //     print('Error deleting user from Firebase Auth: $e');
  //     return false;
  //   }
  // }
}