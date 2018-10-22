const defaultState = {
  patients: []
}

export default function reducer(state = defaultState, action) {
  const { type, payload } = action;
  switch (type) {
    case 'PATIENT_COMMIT':
      const { patients } = payload;
      return {
        patients
      };
    default:
      return state;
  }
}