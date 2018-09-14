import React, { Component } from 'react';
import { AppBar, Typography, Toolbar, Button } from '@material-ui/core';
import { Link } from 'react-router-dom'

class Header extends Component {
  render() {
    return (
      <div>
        <AppBar position="static">
          <Toolbar>
            <Typography component={Link} to="/" variant="title" color="inherit">
              Mediroo
          </Typography>
          <Button component={Link} to="/login" color="inherit">Login</Button>
          <Button component={Link} to="/register" color="inherit">Register</Button>
          <Button component={Link} to="/patients" color="inherit">Patients</Button>
          </Toolbar>
        </AppBar>
      </div>
    );
  }
}

export default Header;