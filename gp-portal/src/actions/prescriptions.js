import { firestore } from 'config/firebase';

export const fetchPatientPrescriptions = (uid) => (dispatch) => {
  return firestore.collection(`prescriptions/${uid}/prescription`).get().then(querySnapshot => {
    const prescriptions = [];
    querySnapshot.forEach(prescriptionSnapShot => {
      const prescriptionData = prescriptionSnapShot.data();
      const { description, notes: prescriptionNotes, remaining } = prescriptionData;
      console.log(prescriptionData);
      const prescription = {
        name: description,
        prescriptionNotes,
        remaining,
        uid
      };
      if (!prescriptionData.medication) prescriptions.push(prescription);
    });
    dispatch({
      type: 'PRESCRIPTIONS_COMMIT',
      payload: {
        uid,
        prescriptions
      }
    });
  });
}

export const createPatientPrescription = (uid, prescription) => (dispatch) => {
  return firestore.collection(`prescriptions/${uid}/prescription`).add(prescription)
    .then(() => {
      dispatch({
        type: 'PRESCRIPTION_CREATION_COMMIT'
      });
    })
}