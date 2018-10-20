import React, { Component } from 'react';
import { Paper, Table, TableBody, TableCell, TableHead, TableRow} from '@material-ui/core';
import withStyles from '@material-ui/core/styles/withStyles';
import { Redirect } from 'react-router-dom'
import PatientTableItem from 'components/common/patient-list-item';
import { connect } from 'react-redux';
import compose from 'recompose/compose';
import { fetchPatients } from 'actions/patients';
const styles = theme => ({
  layout: {
    width: 'auto',
    display: 'block',
    marginLeft: theme.spacing.unit * 3,
    marginRight: theme.spacing.unit * 3,
    [theme.breakpoints.up(400 + theme.spacing.unit * 3 * 2)]: {
      width: 800,
      margin: 'auto',
    },
  },
  root: {
    width: '100%',
    marginTop: theme.spacing.unit * 3,
    overflowX: 'auto',
  },
  table: {
    minWidth: 500,
  },
  row: {
    '&:nth-of-type(odd)': {
      backgroundColor: theme.palette.background.default,
    },
  }
});

class Patients extends Component {
  state = {
    patients: [],
    loggedIn: true
  };

  constructor() {
    super();
  }

  componentDidMount() {
    if (!this.props.loggedIn){
      this.props.history.push('/login');
    } else {
      this.props.fetchPatients();
    }
  }

  render() {
    const { classes, patients, loggedIn } = this.props;
    const patientTableItems = patients.map((patient, index) => <PatientTableItem key={index} {...this.props} {...patient} />);
    if (!loggedIn) {
      return <Redirect to="/login" />
    }
    return (
      <div className={classes.layout}>
        <Paper className={classes.root}>
          <Table className={classes.table}>
            <TableHead>
              <TableRow>
                <TableCell>Name</TableCell>
                <TableCell>Email</TableCell>
              </TableRow>
            </TableHead>
            <TableBody>
              {patientTableItems}
            </TableBody>
          </Table>
        </Paper>
      </div>
    );
  }
}

const mapStateToProps = (state) => {
  return {
    patients: state.patients.patients,
    loggedIn: state.auth.loggedIn
  }
};
const mapDispatchToProps = {
  fetchPatients
};

export default compose(connect(mapStateToProps, mapDispatchToProps), connect(), withStyles(styles))(Patients);
