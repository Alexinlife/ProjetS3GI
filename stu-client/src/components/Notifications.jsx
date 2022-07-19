import React from 'react';
import '../css/UdS.css';
import '../css/Notifications.css';
import { Box, Button, List, ListItem, ListItemText } from '@mui/material/';

export default class Schedule extends React.Component {
  state = {
    notifications: [],
  }

  render() {
    return (
      <Box className="ntf-notifications">
        <List>
          <ListItem className="UdS-item">
            <ListItemText primary={"Tutorat 1"} secondary={"s6eapp2 | 07/06/22 9:00"} />
            <Button className="ntf-accept" variant="text">Accepter</Button>
            <Button variant="text">Refuser</Button>
          </ListItem>
          <ListItem className="UdS-item">
            <ListItemText primary={"Tutorat 1"} secondary={"s6eapp2 | 07/06/22 9:00"} />
            <Button variant="text">Accepter</Button>
            <Button variant="text">Refuser</Button>
          </ListItem>
          <ListItem className="UdS-item">
            <ListItemText primary={"Tutorat 1"} secondary={"s6eapp2 | 07/06/22 9:00"} />
            <Button variant="text">Accepter</Button>
            <Button variant="text">Refuser</Button>
          </ListItem>
          <ListItem className="UdS-item">
            <ListItemText primary={"Tutorat 1"} secondary={"s6eapp2 | 07/06/22 9:00"} />
            <Button variant="text">Accepter</Button>
            <Button variant="text">Refuser</Button>
          </ListItem>
        </List>
      </Box>
    );
  }
}