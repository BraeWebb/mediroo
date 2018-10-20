import React, { Component } from 'react';
import withStyles from '@material-ui/core/styles/withStyles';
import Paper from '@material-ui/core/Paper';
import Table from '@material-ui/core/Table';
import TableBody from '@material-ui/core/TableBody';
import { connect } from 'react-redux';
import { Redirect } from 'react-router-dom'
import compose from 'recompose/compose';
import { TableCell, TableHead, TableRow } from '@material-ui/core';
import PrescriptionTableItem from 'components/common/prescription-list-item';
import { fetchPatientPrescriptions } from 'actions/prescriptions';

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

class PatientDetail extends Component {
  state = {
    prescriptions: []
  }

  componentDidMount() {
    const { uid} = this.props.match.params;
    this.props.fetchPatientPrescriptions(uid);
  }

  render() {
    const { loggedIn, classes, prescriptions } = this.props;
    const { uid} = this.props.match.params;
    let prescriptionTableItems = [];
    if (prescriptions && prescriptions[uid]) {
      prescriptionTableItems = prescriptions[uid].map((prescription, index) => <PrescriptionTableItem key={index} {...prescription} />);
    }
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
                <TableCell>Remaining</TableCell>
                <TableCell>Notes</TableCell>
              </TableRow>
            </TableHead>
            <TableBody>
              {prescriptionTableItems}
            </TableBody>
          </Table>
        </Paper>
      </div>
    );
  }
}

const mapStateToProps = (state) => {
  return {
    prescriptions: state.prescriptions,
    loggedIn: state.auth.loggedIn
  }
};
const mapDispatchToProps = {
  fetchPatientPrescriptions
};

export default compose(connect(mapStateToProps, mapDispatchToProps), connect(), withStyles(styles))(PatientDetail);
