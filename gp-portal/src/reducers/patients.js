const defaultState = {
  patients: []
}

export default function reducer(state = defaultState, action) {
  const { type, payload } = action;
  switch (type) {
    // All patients are fetched so overwrite state with latest
    case 'PATIENT_COMMIT':
      const { patient } = payload;
      const {patients} = state;
      if (patients.find(fetchedPatient => fetchedPatient.patientId == patient.patientId)) return state;
      return {
        ...state,
        patients: [...patients, patient]
      };
    default:
      return state;
  }
}