import React, { Component } from 'react';
import { connect } from 'react-redux';
import { userLogin } from '../actions/auth';
import compose from 'recompose/compose';
import LoginForm from '../components/forms/login-form';
import Paper from '@material-ui/core/Paper';
import withStyles from '@material-ui/core/styles/withStyles';
import { Redirect } from 'react-router-dom'

// Material UI styling override
const styles = theme => ({
  layout: {
    width: 'auto',
    display: 'block',
    marginLeft: theme.spacing.unit * 3,
    marginRight: theme.spacing.unit * 3,
    [theme.breakpoints.up(400 + theme.spacing.unit * 3 * 2)]: {
      width: 400,
      margin: 'auto',
    },
  },
  paper: {
    marginTop: theme.spacing.unit * 8,
    display: 'flex',
    flexDirection: 'column',
    alignItems: 'center',
    padding: `${theme.spacing.unit * 2}px ${theme.spacing.unit * 3}px ${theme.spacing.unit * 3}px`,
  }
})

class Login extends Component {

  // Handle form submission from child
  onSubmit = state => {
    const { email, password } = state;
    this.props.userLogin(email, password);
  }

  render() {
    const { classes, loggedIn } = this.props;
    if (loggedIn) {
      return <Redirect to="/" />
    }
    return (
      <div>
        <div className={classes.layout}>
          <Paper className={classes.paper}>
            <LoginForm onSubmit={this.onSubmit} />
          </Paper>
        </div>
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
  userLogin
};

export default compose(connect(mapStateToProps, mapDispatchToProps), connect(), withStyles(styles))(Login);