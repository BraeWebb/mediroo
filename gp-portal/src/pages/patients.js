import React, { Component } from 'react';
import PatientTableItem from '../components/common/patient-list-item';
import withStyles from '@material-ui/core/styles/withStyles';
import Paper from '@material-ui/core/Paper';
import Table from '@material-ui/core/Table';
import TableBody from '@material-ui/core/TableBody';
import TableCell from '@material-ui/core/TableCell';
import TableHead from '@material-ui/core/TableHead';
import TableRow from '@material-ui/core/TableRow';
import { firestore } from '../config/firebase';

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
    patients: []
  };

  constructor(){
    super();
  }

  componentDidMount() {
    // move to redux
    this.call = firestore.collection('pills/users/jRTDHRTTOYf3GvN6xevmnu2Ok9o2').get().then(querySnapshot => {
      const patients = [];
      querySnapshot.forEach(patient => {
        console.log();
        patients.push(patient.data());
      });
      this.setState({patients});
      console.log(patients);
    });
  }

  componentWillUnmount(){
    // TODO: cancel promise when unmounting
    console.log(this.call);
  }

  render() {
    const { classes } = this.props;
    const patientTableItems = this.state.patients.map(patient => <PatientTableItem {...this.props} {...patient} />);
    return (
      <div className={classes.layout}>
        <Paper className={classes.root}>
          <Table className={classes.table}>
            <TableHead>
              <TableRow>
                <TableCell>Name</TableCell>
                <TableCell numeric>Patient ID</TableCell>
                <TableCell>Email</TableCell>
                <TableCell>Phone Number</TableCell>
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

export default withStyles(styles)(Patients);