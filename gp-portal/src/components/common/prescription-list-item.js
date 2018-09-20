import React, { Component } from 'react';
import { TableCell, TableRow } from '@material-ui/core';

// Table row item for prescription list
class PrescriptionTableRow extends Component {
  render() {
    const { name, remaining, prescriptionNotes } = this.props;
    return (
      <TableRow hover onClick={this.handleClick}>
        <TableCell>{name}</TableCell>
        <TableCell>{remaining}</TableCell>
        <TableCell>{prescriptionNotes}</TableCell>
      </TableRow>
    );
  }
};

export default PrescriptionTableRow;
