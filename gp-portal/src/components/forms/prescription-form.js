import React, { Component } from 'react';
import Button from '@material-ui/core/Button';
import FormControl from '@material-ui/core/FormControl';
import Input from '@material-ui/core/Input';
import InputLabel from '@material-ui/core/InputLabel';
import withStyles from '@material-ui/core/styles/withStyles';
import TextField from '@material-ui/core/TextField';

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
    email: '',
    password: ''
  }

  onChange = e => {
    this.setState({ [e.target.name]: e.target.value });
  }

  onSubmit = e => {
    e.preventDefault();
    this.props.onSubmit(this.state);
  }

  render() {
    const { classes } = this.props;
    return (
      <form className={classes.form} onSubmit={this.onSubmit}>
        <FormControl margin="normal" required fullWidth>
          <InputLabel htmlFor="name">Medication Name</InputLabel>
          <Input
            id="name"
            name="name"
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
          <InputLabel htmlFor="number">Number of pills</InputLabel>
          <Input
            id="number"
            name="number"
            type="number"
            onChange={this.onChange} />
        </FormControl>
        <TextField
          id="start"
          label="Start Date"
          name="start"
          type="date"
          className={classes.textField}
          InputLabelProps={{
            shrink: true,
          }}
          onChange={this.onChange} />
        <TextField
          id="end"
          label="End Date"
          name="end"
          type="date"
          className={classes.textField}
          InputLabelProps={{
            shrink: true,
          }}
          onChange={this.onChange} />
        <Button
          type="submit"
          fullWidth
          variant="raised"
          color="primary"
          className={classes.submit}
        >
          Register new prescription
            </Button>
      </form>
    );
  }
}

export default withStyles(styles)(PrescriptionForm);