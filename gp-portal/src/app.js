import React, { Component } from 'react';
import { BrowserRouter } from 'react-router-dom'
import { CssBaseline, createMuiTheme, MuiThemeProvider } from '@material-ui/core';
import Main from 'main';
import Header from 'components/header';
import { userLogout, persistLogin } from 'actions/auth';
import { connect } from 'react-redux';
import { auth } from 'config/firebase';

class app extends Component {
  componentWillMount() {
    auth.onAuthStateChanged(user => {
      if (user) {
        this.props.persistLogin(user.uid);
      } else {
        this.props.userLogout();
      }
      console.log(user);
    })
  }

  render() {
    // Sets global material ui theme
    const theme = createMuiTheme({
      palette: {
        primary: {
          main: '#1c5379'
        },
        secondary: {
          main: '#f44336',
        },
      },
    });
    // Initialise router
    return (
      <BrowserRouter>
        <MuiThemeProvider theme={theme}>
          <CssBaseline />
          <Header />
          <Main />
        </MuiThemeProvider>
      </BrowserRouter>
    );
  }
}

const mapDispatchToProps = {
  userLogout,
  persistLogin
};

export default connect(null, mapDispatchToProps)(app);
