import React, { Component } from 'react';
import { BrowserRouter } from 'react-router-dom'
import { CssBaseline, createMuiTheme, MuiThemeProvider } from '@material-ui/core';
import Main from 'main';
import Header from 'components/header';

class app extends Component {
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

export default app;