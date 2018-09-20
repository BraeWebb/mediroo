import { fetchPatientList } from 'service/patients';

export const fetchPatients = () => (dispatch) => {
  return fetchPatientList()
    .then(patients => {
      dispatch({
        type: 'PATIENT_COMMIT',
        payload: { patients }
      });
    });
}

export const fetchPatient = (patientId) => (dispatch) => {
}