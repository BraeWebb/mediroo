const defaultState = {
  patients: []
}

export default function reducer(state = defaultState, action) {
  const { type, payload } = action;
  switch (type) {
    // All patients are fetched so overwrite state with latest
    case 'PATIENTS_COMMIT':
      const { patients } = payload;
      return {
        ...state,
        patients
      };
    default:
      return state;
  }
}