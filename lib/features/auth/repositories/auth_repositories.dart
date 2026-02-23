import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/services.dart';
import 'package:resume_ai/features/profile/model/resume_model.dart';

import '../model/user.dart';

class AuthRepositories {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<UserModel?> signInWithGoogle() async {
    try {
      // Reset any previous sign-in state that might be causing issues
      await _googleSignIn.signOut();

      // Start the interactive sign-in process with explicit scopes
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // User canceled the sign-in flow
        log('Google Sign In was canceled by user');
        return null;
      }

      try {
        // Obtain the auth details from the request
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        // Create a new credential
        final OAuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        // Sign in to Firebase with the Google credential
        final UserCredential userCredential =
            await _firebaseAuth.signInWithCredential(credential);
        final User? user = userCredential.user;

        if (user == null) {
          log('Failed to get user from UserCredential');
          return null;
        }

        // Create user model from Firebase user
        final UserModel userModel = UserModel(
          id: user.uid,
          email: user.email ?? '',
          name: user.displayName ?? 'User',
          photoUrl: user.photoURL ?? '',
        );

        // Extract first and last name safely
        String firstName = '';
        String lastName = '';

        if (user.displayName != null && user.displayName!.isNotEmpty) {
          final nameParts = user.displayName!.split(' ');
          firstName = nameParts.first;
          if (nameParts.length > 1) {
            lastName = nameParts.skip(1).join(' ');
          }
        }

        // Create initial resume model for new users
        final ResumeModel resumeModel = ResumeModel(
          firstName: firstName,
          lastName: lastName,
          bio: '',
          yearsOfExp: '',
          email: user.email ?? '',
          phone: user.phoneNumber ?? '',
          skills: [],
          portfolioLink: '',
          linkedinLink: '',
          githubLink: '',
          otherLink: '',
          gender: 'Male',
          maritalStatus: 'Single',
          projectsControllers: [],
          workExperienceControllers: [],
          educationControllers: [],
          achievementsControllers: [],
        );

        // If this is a new user, create their document in Firestore
        if (userCredential.additionalUserInfo?.isNewUser == true) {
          log('Creating new user in Firestore');

          // Add user profile data
          await _firebaseFirestore.collection('users').doc(user.uid).set(
                userModel.toMap(),
                SetOptions(merge: true),
              );

          // Add resume data
          await _firebaseFirestore
              .collection('users')
              .doc(user.uid)
              .collection('resume')
              .doc(user.uid)
              .set(
                resumeModel.toMap(),
                SetOptions(merge: true),
              );
        }

        log('Successful Google sign in: ${user.uid}');
        return userModel;
      } on PlatformException catch (e) {
        // Handle platform-specific exceptions (including Google API errors)
        log('PlatformException during Google authentication: ${e.code} - ${e.message}');
        if (e.code == 'sign_in_failed' && e.message?.contains('10:') == true) {
          log('Error 10: This usually means there is a configuration issue with your Google API Console project');
          log('Please check your SHA-1 fingerprint is registered correctly in Firebase Console');
        }
        return null;
      }
    } on FirebaseAuthException catch (e) {
      log('FirebaseAuthException during sign in: ${e.code} - ${e.message}');
      return null;
    } on PlatformException catch (e) {
      log('PlatformException during Google sign in: ${e.code} - ${e.message}');
      if (e.code == 'sign_in_failed' && e.message?.contains('10:') == true) {
        log('Error 10: This usually means there is a configuration issue with your Google API Console project');
        log('Please check your SHA-1 fingerprint is registered correctly in Firebase Console');
      }
      return null;
    } catch (e) {
      log('Exception during Google sign in: ${e.toString()}');
      return null;
    }
  }

  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _firebaseAuth.signOut();
      log('User signed out successfully');
    } catch (e) {
      log('Error signing out: ${e.toString()}');
    }
  }
}
