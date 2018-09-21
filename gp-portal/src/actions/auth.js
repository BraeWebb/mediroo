import { registerWithEmailAndPassword, loginWithEmailAndPassword } from 'service/auth';

// Log in user
export const userLogin = (email, password) => (dispatch) => {
  return loginWithEmailAndPassword(email, password)
    .then(user => {
      dispatch({
        type: 'LOGIN_SUCCESS',
        payload: { user: user.user.uid }
      });
    });
}

// Register a new user
export const userRegister = (email, password) => (dispatch) => {
  return registerWithEmailAndPassword(email, password)
    .then(user => {
      dispatch({
        type: 'REGISTER_SUCCESS',
        payload: {user: user.user.uid}
      });
    })
}

// Logs out a user
export const userLogout = () => (dispatch) => {
  dispatch({
    type: 'USER_LOGOUT'
  });
}
