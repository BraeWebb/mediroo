import React, { Component } from 'react';
import Button from '@material-ui/core/Button';
import FormControl from '@material-ui/core/FormControl';
import Input from '@material-ui/core/Input';
import InputLabel from '@material-ui/core/InputLabel';
import withStyles from '@material-ui/core/styles/withStyles';
import TextField from '@material-ui/core/TextField';
import moment from 'moment';

const styles = theme => ({
  avatar: {
    margin: theme.spacing.unit,
    backgroundColor: theme.palette.secondary.main,
  },
  form: {
    width: '100%',
    marginTop: theme.spacing.unit,
  },
  submit: {
    marginTop: theme.spacing.unit * 3,
  },
});

class PrescriptionForm extends Component {
  state = {
    description: '',
    notes: '',
    remaining: 0,
    intervals: [],
    start: moment(new Date()).format("YYYY-MM-DD"),
    end: moment(new Date()).format("YYYY-MM-DD")
  }

  onChange = e => {
    this.setState({ [e.target.name]: e.target.value });
  }

  onIntervalChange = (e, index) => {
    const { intervals } = this.state;
    intervals[index] = {
      ...intervals[index],
      [e.target.name]: e.target.value
    }
    this.setState({
      intervals
    });
  }

  onSubmit = e => {
    e.preventDefault();
    this.props.onSubmit(this.state);
  }

  handleAddInterval = () => {
    this.setState({
      intervals: [
        ...this.state.intervals,
        {
          dosage: 0,
          time: '07:30'
        }]
    });
  }

  render() {
    const { classes } = this.props;
    const intervals = this.state.intervals.map((interval, index) =>
      <div key={index}>
        <FormControl margin="normal" required fullWidth>
          <InputLabel htmlFor="remaining">Dosage</InputLabel>
          <Input
            key={index}
            id="intervalDosage"
            name="dosage"
            type="number"
            onChange={(e) => this.onIntervalChange(e, index)} />
        </FormControl>
        <TextField
          required
          id="time"
          name="time"
          fullWidth
          label="Time of Day"
          type="time"
          defaultValue="07:30"
          InputLabelProps={{
            shrink: true,
          }}
          inputProps={{
            step: 600
          }}
          onChange={(e) => this.onIntervalChange(e, index)} />
      </div>
    );
    return (
      <form className={classes.form} onSubmit={this.onSubmit}>
        <FormControl margin="normal" required fullWidth>
          <InputLabel htmlFor="description">Medication Name</InputLabel>
          <Input
            id="description"
            name="description"
            type="text"
            onChange={this.onChange}
            autoFocus />
        </FormControl>
        <FormControl margin="normal" required fullWidth>
          <InputLabel htmlFor="name">Medication Notes</InputLabel>
          <Input
            id="notes"
            name="notes"
            type="text"
            onChange={this.onChange} />
        </FormControl>
        <FormControl margin="normal" required fullWidth>
          <InputLabel htmlFor="remaining">Number of pills</InputLabel>
          <Input
            id="remaining"
            name="remaining"
            type="number"
            onChange={this.onChange} />
        </FormControl>
        <TextField
          required
          id="start"
          label="Start Date"
          name="start"
          defaultValue={moment(new Date()).format("YYYY-MM-DD")}
          type="date"
          className={classes.textField}
          InputLabelProps={{
            shrink: true,
          }}
          onChange={this.onChange} />
        <TextField
          required
          id="end"
          label="End Date"
          name="end"
          defaultValue={moment(new Date()).format("YYYY-MM-DD")}
          type="date"
          className={classes.textField}
          InputLabelProps={{
            shrink: true,
          }}
          onChange={this.onChange} />
        {intervals}
        <Button
          fullWidth
          variant="raised"
          color="primary"
          onClick={this.handleAddInterval}
          className={classes.submit}
        >
          Add Interval
        </Button>
        <Button
          type="submit"
          fullWidth
          variant="raised"
          color="primary"
          className={classes.submit}
        >
          Submit new prescription
            </Button>
      </form>
    );
  }
}

export default withStyles(styles)(PrescriptionForm);