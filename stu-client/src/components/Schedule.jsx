import React from 'react';
import axios from 'axios';
import '../css/UdS.css';
import '../css/Schedule.css';
import { Box, ListItem, ListItemText, Radio, RadioGroup, Typography } from '@mui/material/';

class Schedule extends React.Component {
  state = {
    schedule: [],
    selected: 0,
  }

  componentDidMount() {
    this.getSchedule();
    localStorage.removeItem("selected_tutorat");
  }

  async getSchedule() {
    try {
      const scheduleResponse = await axios.get('http://localhost:8089/api/gethoraire/' + localStorage.getItem("cip"));
      console.log(scheduleResponse);
      this.setState({
        schedule: scheduleResponse.data,
      });
    } catch (error) {
      console.error(error);
    }
  }

  render() {
    const handleChange = (event) => {
      localStorage.setItem("selected_tutorat", event.target.value);
      this.setState({
        selected: event.target.value,
      });
    }

    return (
      <Box>
        <Typography className="UdS-title" variant="h6">Vos tutorats à venir :</Typography>
        <RadioGroup
          name="radio-schedule"
          value={this.state.selected}
          onChange={handleChange}
        >
          {
            this.state.schedule.length === 0 ?
              <ListItem className="UdS-item">
                <ListItemText primary="Aucun tutorat à venir" secondary="Contactez le coordonateur pour plus d'information" />
              </ListItem>
              :
              this.state.schedule.map((item) => (
                <ListItem className="UdS-item" key={item.idTutorat}>
                  <Radio
                    value={item.idTutorat}
                    sx={{
                      color: "#ffffff",
                      '&.Mui-checked': {
                        color: "#4D8406",
                      },
                    }}
                  />
                  <ListItemText primary={"Tutorat" + item.numeroTutorat} secondary={item.numeroAPP + " | " + item.dateTutorat} />
                </ListItem>
              ))
          }
        </RadioGroup>
      </Box>
    );
  }
}

export default Schedule;