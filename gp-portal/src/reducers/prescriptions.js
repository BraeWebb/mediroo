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
      if (state[uid] && state[uid].prescriptions) {
        const { prescriptions } = state[uid];
        newState[uid] = [...prescriptions, prescription];
        return {
          ...state,
          ...newState
        };
      } else {
        newState[uid] = [prescription];
        return {
          ...state,
          ...newState
        };
      }
    default:
      return state;
  }
}