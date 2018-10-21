import { firestore, auth } from 'config/firebase';

export const fetchPatients = (uid) => (dispatch) => {

  auth.onAuthStateChanged(user => {
    if (user) {
      const { uid } = user;
      console.log(uid);
      firestore.collection(`doctors`).doc(uid).get().then(doc => {
        const doctorData = doc.data();
        const patients = doctorData.patients;
        const promises = [];
        patients.forEach(patientId => {
          const patientPromise = firestore.collection('users').doc(patientId).get();
          promises.push(patientPromise);
        });
        Promise.all(promises)
          .then(snapShots => {
            const patients = [];
            snapShots.forEach(patientSnapShot => {
              const patientId = patientSnapShot.id;
              const { name, email } = patientSnapShot.data();
              console.log(patientSnapShot.data());
              patients.push({
                name, email, patientId
              });
            });
            dispatch({
              type: 'PATIENT_COMMIT',
              payload: {
                patients
              }
            });
          });
      })
    } else {
    }
  })
}