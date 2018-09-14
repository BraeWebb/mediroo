import React, { Component } from 'react';

class PatientDetail extends Component {
  render() {
    return (
      <div>
        {this.props.match.params.patientId}
      </div>
    );
  }
}

export default PatientDetail;