import React, { Component } from 'react';
import { AppBar, Typography, Toolbar, Button } from '@material-ui/core';
import { Link } from 'react-router-dom'
import { connect } from 'react-redux';
import withStyles from '@material-ui/core/styles/withStyles';
import compose from 'recompose/compose';
import { userLogout } from 'actions/auth';

const styles = theme => ({
  grow: {
    flexGrow: 1
  },
});

class Header extends Component {
  render() {
    const { classes, loggedIn, userLogout } = this.props;
    console.log(this.props);
    console.log(loggedIn);
    return (
      <div>
        <AppBar position="static">
          <Toolbar>
            <Typography className={classes.grow} component={Link} to="/" variant="title" color="inherit">
              Mediroo
            </Typography>
            {
              !loggedIn ?
                <div>
                  <Button component={Link} to="/login" color="inherit">Login</Button>
                  <Button component={Link} to="/register" color="inherit">Register</Button>
                </div>
                :
                <div>
                  <Button component={Link} to="/patients" color="inherit">Patients</Button>
                  <Button onClick={() => userLogout()} color="inherit">Logout</Button>
                </div>
            }
          </Toolbar>
        </AppBar>
      </div>
    );
  }
}

const mapStateToProps = (state) => {
  return {
    loggedIn: state.auth.loggedIn
  }
};
const mapDispatchToProps = {
  userLogout
};

export default compose(connect(mapStateToProps, mapDispatchToProps), connect(), withStyles(styles))(Header);