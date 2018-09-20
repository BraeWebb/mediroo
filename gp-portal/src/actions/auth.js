import { registerWithEmailAndPassword, loginWithEmailAndPassword } from 'service/auth';

export const userLogin = (email, password) => (dispatch) => {
  return loginWithEmailAndPassword(email, password)
    .then(user => {
      console.log(user);
      dispatch({
        type: 'LOGIN_SUCCESS',
        payload: { user: user.user.uid }
      });
    });
}

export const userRegister = (email, password) => (dispatch) => {
  return registerWithEmailAndPassword(email, password)
    .then(user => {
      dispatch({
        type: 'REGISTER_SUCCESS',
        payload: {user: user.user.uid}
      });
    })
}

export const userLogout = () => (dispatch) => {
  dispatch({
    type: 'USER_LOGOUT'
  });
}
