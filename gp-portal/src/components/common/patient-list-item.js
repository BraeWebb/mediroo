import React, { Component } from 'react';
import TableCell from '@material-ui/core/TableCell';
import TableRow from '@material-ui/core/TableRow';

class PatientTableRow extends Component {
  handleClick = () => {
    this.props.history.push(`/patients/${this.props.patientId}`);
  }

  render() {
    const { name, patientId, email, phone } = this.props;
    return (
      <TableRow hover onClick={this.handleClick}>
        <TableCell>{name}</TableCell>
        <TableCell numeric>{patientId}</TableCell>
        <TableCell numeric>{email}</TableCell>
        <TableCell numeric>{phone}</TableCell>
      </TableRow>
    );
  }
};

export default PatientTableRow;