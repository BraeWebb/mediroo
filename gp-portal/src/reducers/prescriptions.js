const defaultState = {
}

export default function reducer(state = defaultState, action) {
  const { type, payload } = action;
  switch (type) {
    case 'PRESCRIPTIONS_COMMIT':
      const { prescriptions, uid } = payload;
      const newState = {};
      newState[uid] = prescriptions;
      return {
        ...state,
        ...newState
      };
    default:
      return state;
  }
}