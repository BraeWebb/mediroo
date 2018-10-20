import { firestore } from 'config/firebase';

export const fetchPatientPrescriptions = (uid) => (dispatch) => {
  return firestore.collection(`prescriptions/${uid}/prescription`).get().then(querySnapshot => {
    querySnapshot.forEach(prescription => {
      const prescriptionData = prescription.data();
      console.log(prescriptionData);
      if (prescriptionData.medication !== undefined) {
        firestore.collection('medication').doc(prescriptionData.medication).get().then(document => {
          const medicationData = document.data();
          const { notes: prescriptionNotes, remaining } = prescriptionData;
          const { notes: medicationNotes, name } = medicationData;
          const prescription = {
            prescriptionNotes,
            medicationNotes,
            name,
            remaining,
            uid
          };
          dispatch({
            type: 'PRESCRIPTIONS_COMMIT',
            payload: {prescription}
          });
        });
      } else {
        const { description, notes: prescriptionNotes, remaining } = prescriptionData;
        const prescription = {
          name: description,
          prescriptionNotes,
          remaining,
          uid
        };
        dispatch({
          type: 'PRESCRIPTIONS_COMMIT',
          payload: {prescription}
        });
      }
    });
  });
}