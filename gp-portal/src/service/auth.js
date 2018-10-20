import { auth, firestore } from 'config/firebase';

// Sign up practioner
export const registerWithEmailAndPassword = (email, password, name, practice) => auth.createUserWithEmailAndPassword(email, password);

// Create practioner document
export const registerPractioner = (uid, email, name, practice) => firestore.collection('doctors').doc(uid).set({
  email,
  patients: [],
  name,
  practice
});

// Login practioner
export const loginWithEmailAndPassword = (email, password) => auth.signInWithEmailAndPassword(email, password);

export const logoutUser = () => auth.signOut();
