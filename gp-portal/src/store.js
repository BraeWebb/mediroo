import { applyMiddleware, createStore } from 'redux';
import { composeWithDevTools } from 'redux-devtools-extension';
import thunk from 'redux-thunk';
import rootReducer from './reducers/root-reducer';

const middleware = applyMiddleware(thunk);

export default createStore(rootReducer, composeWithDevTools(middleware));