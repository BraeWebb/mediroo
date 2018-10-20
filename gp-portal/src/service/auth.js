import { auth, firestore } from 'config/firebase';

// Sign up practioner
export const registerWithEmailAndPassword = (email, password) => auth.createUserWithEmailAndPassword(email, password);

// Create practioner document
export const registerPractioner = (uid, email) => firestore.collection('doctors').doc(uid).set({
  email,
  patients: []
});

// Login practioner
export const loginWithEmailAndPassword = (email, password) => auth.signInWithEmailAndPassword(email, password);