import React from 'react';
import axios from 'axios';
import '../css/UdS.css';
import '../css/Schedule.css';
import { Box, FormControl, ListItem, ListItemText, Radio, RadioGroup, Typography } from '@mui/material/';

class Schedule extends React.Component {
  state = {
    schedule: [],
    selected: 0,
  }

  componentDidMount() {
    this.getSchedule();
  }

  async getSchedule() {
    try {
      const scheduleResponse = await axios.get('http://localhost:8089/tutorats/gethoraire');
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
        <FormControl>
          <RadioGroup
            aria-labelledby="radio-schedule"
            name="radio-schedule"
            value={this.state.selected}
            onChange={handleChange}
          >
            {this.state.schedule.map((item) => (
              <ListItem className="UdS-item">
                <Radio value={item.idTutorat}
                  sx={{
                    color: "#ffffff",
                    '&.Mui-checked': {
                      color: "#4D8406",
                    },
                  }}
                ></Radio>
                <ListItemText primary={"Tutorat" + item.numeroTutorat} secondary={item.numeroAPP + " | " + item.dateTutorat} />
              </ListItem>
            ))}
          </RadioGroup>
        </FormControl>
      </Box>
    );
  }
}

export default Schedule;