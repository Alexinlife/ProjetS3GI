import React from 'react';
import '../css/UdS.css';
import '../css/Notifications.css';
import { Box, Button, List, ListItem, ListItemText } from '@mui/material/';
import { toast } from 'react-toastify';

export default class Schedule extends React.Component {
  state = {
    notifications: [],
  }

  componentDidMount() {
    this.getNotifications();
  }

  async getNotifications() {

  }

  acceptNotification = () => {
    toast.success("Demande acceptée");
  };

  declineNotification = () => {
    toast.success("Demande refusée");
  };

  render() {
    return (
      <Box className="ntf-notifications">
        <List>
          <ListItem className="UdS-item" id="0">
            <ListItemText primary={"Félix veut échanger"} secondary={"07/06/22 9:00 -> 07/06/22 13:00"} />
            <Button className="ntf-accept" onClick={this.acceptNotification} variant="text">Accepter</Button>
            <Button variant="text" onClick={this.declineNotification}>Refuser</Button>
          </ListItem>
          <ListItem className="UdS-item" id="0">
            <ListItemText primary={"Félix veut échanger"} secondary={"07/06/22 9:00 -> 07/06/22 13:00"} />
            <Button className="ntf-accept" onClick={this.acceptNotification} variant="text">Accepter</Button>
            <Button variant="text" onClick={this.declineNotification}>Refuser</Button>
          </ListItem>
        </List>
      </Box>
    );
  }
}