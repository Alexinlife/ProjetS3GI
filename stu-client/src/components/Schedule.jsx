import React from 'react';
import axios from 'axios';
import '../css/UdS.css';
import '../css/Schedule.css';
import Box from '@mui/material/Box';
import List from '@mui/material/List';
import ListItem from '@mui/material/ListItem';
import ListItemButton from '@mui/material/ListItemButton';
import ListItemText from '@mui/material/ListItemText';
import { Typography } from '@mui/material';

class Schedule extends React.Component {
  state = {
    schedule: [],
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
    return (
      <Box sx={{ width: '100%', maxWidth: 360, bgcolor: 'background:paper' }}>
        <Typography className="UdS-title" variant="h6">Vos tutorats à venir :</Typography>
        <List>
          {this.state.schedule.map((item) => (
            <ListItem className="Sch-item" disablePadding>
              <ListItemButton>
                <ListItemText id={item.idTutorat} primary={"Tutorat" + item.numeroTutorat} secondary={item.numeroAPP + " | " + item.dateTutorat} />
              </ListItemButton>
            </ListItem>
          ))}
        </List>
      </Box>
    );
  }
}

export default Schedule;