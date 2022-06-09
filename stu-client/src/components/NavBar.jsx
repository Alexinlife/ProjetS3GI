import React from 'react';
import '../css/NavBar.css';
// Composants Material-UI
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
    <Box className="nav-box" sx={{ flexGrow: 1 }}>
      <AppBar position="static">
        <Toolbar className="nav-tool">
          {/* Nom de l'application */}
          <Typography className="nav-title" variant="h6" sx={{ flexGrow: 1 }}>
            <span className="nav-title-full">Système de Tutorat Facile Universitaire</span>
            <span className="nav-title-md">Système de Tutorat Facile</span>
            <span className="nav-title-sm">STU</span>
            </Typography>
          {/* Profil */}
          <IconButton edge="end" className="nav-btn" color="inherit" aria-label="profile">
            <Typography edge="end" className="nav-text" sx={{ flexGrow: 1 }}>Alex Lajeunesse</Typography>
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