import React, { Component } from 'react';
import { connect } from 'react-redux';
import { userLogin } from '../actions/auth';
import compose from 'recompose/compose';
import LoginForm from '../components/forms/login-form';
import Paper from '@material-ui/core/Paper';
import withStyles from '@material-ui/core/styles/withStyles';

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
  onSubmit = state => {
    const { email, password } = state;
    this.props.userLogin(email, password);
    this.props.history.push('/');
  }

  render() {
    const { classes } = this.props;
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