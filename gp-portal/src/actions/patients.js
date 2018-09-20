import { firestore } from 'config/firebase';

export const fetchPatients = () => (dispatch) => {
  return firestore.collection('users/').get().then(querySnapshot => {
    const patients = [];
    querySnapshot.forEach(patient => {
      const data = patient.data();
      const uid = patient.id;
      patients.push({ ...data, uid });
    });
    dispatch({
      type: 'PATIENTS_COMMIT',
      payload: {patients}
    });
  })
}