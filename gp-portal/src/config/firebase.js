import * as firebase from "firebase";
import { FirebaseConfig } from "./keys";

firebase.initializeApp(FirebaseConfig);

export const firestore = firebase.firestore();
export const auth = firebase.auth();

const settings = {timestampsInSnapshots: true};
firestore.settings(settings);

