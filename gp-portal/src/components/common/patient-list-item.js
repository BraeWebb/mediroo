import React, { Component } from 'react';
import { TableCell, TableRow } from '@material-ui/core';

// Table row item for patient list
class PatientTableRow extends Component {
  handleClick = () => {
    this.props.history.push(`/patients/${this.props.uid}`);
  }

  render() {
    const { name, email } = this.props;
    return (
      <TableRow hover onClick={this.handleClick}>
        <TableCell>{name}</TableCell>
        <TableCell>{email}</TableCell>
      </TableRow>
    );
  }
};

export default PatientTableRow;
