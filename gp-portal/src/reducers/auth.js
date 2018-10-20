const defaultState = {
    loggedIn: false,
    user: ''
}

export default function reducer(state = defaultState, action) {
    const { type, payload } = action;
    let user = '';
    switch (type) {
        case 'LOGIN_SUCCESS':
            user  = payload.user;
            return { ...state, user, loggedIn: true };
        case 'REGISTER_SUCCESS':
            user  = payload.user;
            return { ...state, user, loggedIn: true };
        case 'PERSIST_LOGIN':
            user  = payload.user;
            return { ...state, user, loggedIn: true };
        case 'USER_LOGOUT':
            return { ...state, loggedIn: false, user: '' };
        default:
            return state;
    }
}