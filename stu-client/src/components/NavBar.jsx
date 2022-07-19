import React from 'react';
import * as sessionService from '../services/sessionService.jsx';
import '../css/NavBar.css';
// Composants Material-UI
import { AppBar, Box, IconButton, Toolbar, Typography } from '@mui/material';
// Icônes
import PersonIcon from '@mui/icons-material/Person';
import LogoutIcon from '@mui/icons-material/Logout';
import BellIcon from '@mui/icons-material/Notifications';
import Notifications from './Notifications';

/**
 * @author Alex Lajeunesse
 * @function NavBar
 * @description Affiche la NavBar
 * @see https://mui.com/material-ui/react-app-bar/#app-bar
 */
export default class NavBar extends React.Component {
  state = {
    dispNotifications: false
  };

  toggleDispNotifications = () => {
    this.setState({
      dispNotifications: !this.state.dispNotifications
    });
  };

  render() {
    return (
      <Box className="nav-box" sx={{ flexGrow: 1 }}>
        <AppBar position="static">
          <Toolbar className="nav-tool">
            {/* Nom de l'application */}
            <Typography className="nav-title" variant="h6" sx={{ flexGrow: 1 }}>
              <span className="nav-title-full">Système de Tutorat Facile Universitaire</span>
              <span className="nav-title-md">Système de Tutorat Facile</span>
              <span className="nav-title-sm">STU</span>
            </Typography>
            {/* Compte */}
            <Typography edge="end" className="nav-text" sx={{ flexGrow: 1 }}>{localStorage.getItem("session_token") ? <span>{localStorage.getItem("cip")}</span> : <span>Déconnecté</span>}</Typography>
            <PersonIcon />
            {localStorage.getItem("session_token") ?
              <IconButton edge="end" className="nav-btn" color="inherit" aria-label="logout" onClick={sessionService.logout}>
                <LogoutIcon />
              </IconButton>
              : <span></span>}
            {/* Notifications */}
            <IconButton edge="end" className="nav-btn" color="inherit" aria-label="notifications" onClick={this.toggleDispNotifications}>
              <BellIcon />
            </IconButton>
          </Toolbar>
        </AppBar>
        {this.state.dispNotifications ? <Notifications toggle={this.toggleDispNotifications} /> : null}
      </Box>
    );
  }
}
