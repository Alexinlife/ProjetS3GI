import React from 'react';
import '../css/UdS.css';
import '../css/Schedule.css';
import Box from '@mui/material/Box';
import List from '@mui/material/List';
import ListItem from '@mui/material/ListItem';
import ListItemButton from '@mui/material/ListItemButton';
import ListItemText from '@mui/material/ListItemText';
import Divider from '@mui/material/Divider';
import { Typography } from '@mui/material';

class Schedule extends React.Component {
  state = {
    schedule: [],
  }

  render() {
    return (
      <Box sx={{ width: '100%', maxWidth: 360, bgcolor: 'background:paper' }}>
        <Typography className="UdS-title" variant="h6">Vos tutorats à venir :</Typography>
        <nav>
          <List>
            <ListItem className="Sch-item" disablePadding>
              <ListItemButton>
                <ListItemText id="1" primary="Tutorat 1" />
                <ListItemText className="Sch-time" primary="07/06/22 9:00" />
              </ListItemButton>
            </ListItem>
            <Divider />
            <ListItem className="Sch-item" disablePadding>
              <ListItemButton>
                <ListItemText id="2" primary="Tutorat 1" />
                <ListItemText className="Sch-time" primary="07/06/22 9:00" />
              </ListItemButton>
            </ListItem>
            <Divider />
            <ListItem className="Sch-item" disablePadding>
              <ListItemButton>
                <ListItemText id="3" primary="Tutorat 1" />
                <ListItemText className="Sch-time" primary="07/06/22 9:00" />
              </ListItemButton>
            </ListItem>
            <Divider />
            <ListItem className="Sch-item" disablePadding>
              <ListItemButton>
                <ListItemText id="4" primary="Tutorat 1" />
                <ListItemText className="Sch-time" primary="07/06/22 9:00" />
              </ListItemButton>
            </ListItem>
          </List>
        </nav>
      </Box>
    );
  }
}

export default Schedule;