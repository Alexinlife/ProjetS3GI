import React from 'react';
import '../css/UdS.css';
import '../css/Notifications.css';
import Box from '@mui/material/Box';
import List from '@mui/material/List';
import ListItem from '@mui/material/ListItem';
import ListItemButton from '@mui/material/ListItemButton';
import ListItemText from '@mui/material/ListItemText';
import Divider from '@mui/material/Divider';
import { Container, Typography } from '@mui/material';

 export default class Schedule extends React.Component {
  state = {
    notifications: [],
  }

  render() {
    return (
      <Container className="notifications" sx={{ width: '100%', maxWidth: 360, bgcolor: 'background:paper' }}>
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
      </Container>
    );
  }
}