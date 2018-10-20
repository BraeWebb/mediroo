import React, { Component } from 'react';
import { Switch, Route } from 'react-router-dom';
import Login from 'pages/login';
import Register from 'pages/register';
import Patients from 'pages/patients';
import PatientDetail from 'pages/patient-detail';

class Main extends Component {
  render() {
    return (
      <div>
        <Switch>
          <Route exact path='/' component={Patients} />
          <Route exact path='/login' component={Login} />
          <Route exact path='/register' component={Register} />
          <Route exact path='/patient/:uid' component={PatientDetail} />
        </Switch>
      </div>
    );
  }
}

export default Main;