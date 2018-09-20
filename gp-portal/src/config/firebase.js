import * as firebase from "firebase";
import { FirebaseConfig } from "./keys";

firebase.initializeApp(FirebaseConfig);

// Initialise and export firebase database connection
export const firestore = firebase.firestore();

// Initialise and export firebase auth provider
export const auth = firebase.auth();

const settings = {timestampsInSnapshots: true};
firestore.settings(settings);

