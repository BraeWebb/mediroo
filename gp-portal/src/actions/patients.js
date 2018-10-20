import { firestore, auth } from 'config/firebase';

export const fetchPatients = (uid) => (dispatch) => {

  auth.onAuthStateChanged(user => {
    if (user) {
      const { uid } = user;
      console.log(uid);
      firestore.collection(`doctors`).doc(uid).get().then(doc => {
        const doctorData = doc.data();
        const patients = doctorData.patients;
        patients.forEach(patientId => {
          firestore.collection('users').doc(patientId).get().then(user => {
            const {name, email} = user.data();
            dispatch({
              type: 'PATIENT_COMMIT',
              payload: {
                patient: {
                  name,
                  email,
                  patientId
                }
              }
            });
          })
        })
        // console.log(querySnapshot);
        // const patients = [];
        // querySnapshot.forEach(patient => {
        //   console.log(patient);
        //   const data = patient.data();
        //   console.log(data);
        //   // const uid = patient.id;
        //   // patients.push({ ...data, uid });
        // });
        // dispatch({
        // type: 'PATIENTS_COMMIT',
        // payload: {patients}
        // });
      });
    } else {
    }
  })
  // get a list of doctors patients
  // return firestore.collection(`doctors/${uid}/patients`).get().then(querySnapshot => {
  //   const patients = [];
  //   querySnapshot.forEach(patient => {
  //     console.log(patient);
  //     const data = patient.data();
  //     console.log(data);
  //     // const uid = patient.id;
  //     // patients.push({ ...data, uid });
  //   });
  // dispatch({
  // type: 'PATIENTS_COMMIT',
  // payload: {patients}
  // });
  // });

  // // for each patient, get their details and store in redux
  // return firestore.collection('users/').get().then(querySnapshot => {
  //   const patients = [];
  //   querySnapshot.forEach(patient => {
  //     const data = patient.data();
  //     const uid = patient.id;
  //     patients.push({ ...data, uid });
  //   });
  //   dispatch({
  //     type: 'PATIENTS_COMMIT',
  //     payload: {patients}
  //   });
  // })
}