import React, { Component } from 'react';
import { BrowserRouter } from 'react-router-dom'
import { CssBaseline } from '@material-ui/core';
import Main from './main';
import Header from './components/header';

class app extends Component {
  render() {
    return (
      <BrowserRouter>
        <div>
          <CssBaseline />
          <Header />
          <Main />
        </div>
      </BrowserRouter>
    );
  }
}

export default app;