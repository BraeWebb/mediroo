import { registerWithEmailAndPassword, loginWithEmailAndPassword, registerPractioner } from 'service/auth';

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
export const userRegister = (email, password, name, practice) => (dispatch) => {
  return registerWithEmailAndPassword(email, password)
    .then(user => {
      console.log(user);
      const { email, uid } = user.user;
      registerPractioner(uid, email, name, practice)
        .then(() => {
          dispatch({
            type: 'REGISTER_SUCCESS',
            payload: {user: uid}
          });
        })
    })
}

// Logs out a user
export const userLogout = () => (dispatch) => {
  dispatch({
    type: 'USER_LOGOUT'
  });
}
