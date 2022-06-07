import React from 'react';
import '../css/NavBar.css';
// Composants Material-UI
// import { makeStyles } from '@mui/material/styles';
import { AppBar, Box, IconButton, Toolbar, Typography } from '@mui/material';
// Icônes
import PersonIcon from '@mui/icons-material/Person';
import BellIcon from '@mui/icons-material/Notifications';

/**
 * @author Alex Lajeunesse
 * @function NavBar
 * @description Affiche la NavBar
 * @see https://mui.com/material-ui/react-app-bar/#app-bar
 */
export default function NavBar() {
  return (
    <Box sx={{ flexGrow: 1 }}>
      <AppBar position="static">
        <Toolbar>
          {/* Nom de l'application */}
          <Typography variant="h6" className="nav-text" sx={{ flexGrow: 1 }}>Système de Tutorat Facile Universitaire</Typography>
          {/* Profil */}
          <IconButton edge="end" className="nav-btn" color="inherit" aria-label="profile">
            <PersonIcon />
          </IconButton>
          {/* Notifications */}
          <IconButton edge="end" className="nav-btn" color="inherit" aria-label="notifications">
            <BellIcon />
          </IconButton>
        </Toolbar>
      </AppBar>
    </Box>
  );
}