import { firestore } from 'config/firebase';
import moment from 'moment';

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

export const createPatientPrescription = (uid, prescription, intervals) => (dispatch) => {
  const prescriptionCollection = `prescriptions/${uid}/prescription`;
  return firestore.collection(prescriptionCollection).add(prescription)
    .then(result => {
      dispatch({
        type: 'PRESCRIPTION_CREATION_COMMIT'
      });
      return result
    })
    .then((prescriptionResult) => {
      const prescriptionResultId = prescriptionResult.id;
      if (intervals && intervals.start && intervals.end && intervals.intervals) {
        const { intervals : intervalObjects, start, end } = intervals;
        const promises = [];
        intervalObjects.forEach(interval => {
          const intervalObject = {
            days: 1,
            dosage: parseInt(interval.dosage),
            time: moment(`${start} ${interval.time}`, 'YYYY-MM-DD HH:mm').toDate(),
            start: moment(`${start} ${interval.time}`, 'YYYY-MM-DD HH:mm').toDate(),
            end: moment(`${end} ${interval.time}`, 'YYYY-MM-DD HH:mm').toDate()
          };
          console.log(intervalObject);
          const promise = firestore.collection(`${prescriptionCollection}/${prescriptionResultId}/intervals`)
            .add(intervalObject);
          promises.push(promise);
        });
        return Promise.all(promises);
      };
    })
}