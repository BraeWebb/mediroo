import { auth } from 'config/firebase';

// Sign up practioner
export const registerWithEmailAndPassword = (email, password) => auth.createUserWithEmailAndPassword(email, password);

// Login practioner
export const loginWithEmailAndPassword = (email, password) => auth.loginWithEmailAndPassword(email, password);