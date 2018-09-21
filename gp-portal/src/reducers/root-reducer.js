import { combineReducers } from 'redux';
import auth from './auth';
import patients from './patients';
import prescriptions from './prescriptions';

// Combines all reducers
export default combineReducers({
  auth,
  patients,
  prescriptions
});