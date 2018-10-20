import React, { Component } from 'react';
import withStyles from '@material-ui/core/styles/withStyles';
import Paper from '@material-ui/core/Paper';
import { connect } from 'react-redux';
import PrescriptionForm from 'components/forms/prescription-form';
import { Redirect } from 'react-router-dom'
import compose from 'recompose/compose';
import { fetchPatientPrescriptions } from 'actions/prescriptions';

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
});

class CreatePrescription extends Component {
  onSubmit = () => {
    console.log('test');
  }

  render() {
    const { loggedIn, classes } = this.props;
    if (!loggedIn) {
      return <Redirect to="/login" />
    }
    return (
      <div>
        <div className={classes.layout}>
          <Paper className={classes.paper}>
            <PrescriptionForm onSubmit={this.onSubmit} />
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
  fetchPatientPrescriptions
};

export default compose(connect(mapStateToProps, mapDispatchToProps), connect(), withStyles(styles))(CreatePrescription);
