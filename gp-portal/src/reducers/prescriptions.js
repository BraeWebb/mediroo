const defaultState = {
}

export default function reducer(state = defaultState, action) {
  const { type, payload } = action;
  switch (type) {
    case 'PRESCRIPTIONS_COMMIT':
      const { prescription } = payload;
      const { uid } = prescription;
      const newState = {};
      // If user existing in state, append otherwise add user
      if (state[uid]) {
        const prescriptions = state[uid];
        console.log(prescriptions, prescription);
        newState[uid] = [...prescriptions, prescription];
        return {
          ...state,
          ...newState
        };
      } else {
        newState[uid] =[prescription];
        return {
          ...state,
          ...newState
        };
      }
    default:
      return state;
  }
}