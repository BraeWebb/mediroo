const defaultState = {
    loggedIn: false,
    user: ''
}

export default function reducer(state = defaultState, action) {
    const { type, payload } = action;
    switch (type) {
        case 'LOGIN_SUCCESS':
            return { loggedIn: true };
        case 'REGISTER_SUCCESS':
            const { user}  = payload;
            return {...state, user, loggedIn : true};
        case 'USER_LOGOUT':
            return {...state, loggedIn: false, user : ''};
        default:
            return state;
    }
}