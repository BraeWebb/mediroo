export default function reducer(state = {}, action) {
  const { type, payload } = action;
  switch (type) {
      case 'LOGIN_SUCCESS':
          return { loggedIn: true};
      default:
          return state;
  }
}