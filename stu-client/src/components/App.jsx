import React from 'react';
import '../css/App.css';
import { BrowserRouter, Routes, Route } from 'react-router-dom';
import jwtDecode from "jwt-decode";
import { Box, Grid, Typography } from '@mui/material';
import NavBar from './NavBar';
import Login from './Login';
import Schedule from './Schedule';
import Menu from './Menu';
import Availabilities from './Availabilities';
import QuickSwitch from './QuickSwitch';

export default class App extends React.Component {
  state = {
    sessionToken: "",
  }

  componentDidMount() {
    try {
      const encodedSessionToken = localStorage.getItem("session_token");
      console.log(encodedSessionToken);
      this.setState({
        sessionToken: jwtDecode(encodedSessionToken)
      });
    } catch (e) {
      console.error(e);
    }
    
    this.setState({
      sessionToken: localStorage.getItem("session_token")
    });
  }

  render() {
    return (
      <div className="App">
        <header className="App-header">
          <NavBar />
        </header>
        <body className="App-body">
          {this.state.sessionToken ?
            <Grid container rowSpacing={1} columnSpacing={{ sm: 6, md: 12 }}>
              <Grid className="App-left" item xs={12} sm={6}>
                <Schedule />
              </Grid>
              <Grid className="App-right" item xs={12} sm={6}>
                <BrowserRouter>
                  <Routes>
                    {/* Menu principal */}
                    <Route index element={<Menu />} path="/" />
                    {/* Disponibilités */}
                    <Route path="/availabilities" element={<Availabilities />} />
                    {/* Échange rapide */}
                    <Route path="/quick-switch" element={<QuickSwitch />} />
                  </Routes>
                </BrowserRouter>
              </Grid>
            </Grid>
            :
            <Grid container>
              <Grid className="App-login" item xs={12}>
                <Box className="UdS-option" sx={{ width: '100%', maxWidth: 360, bgcolor: 'background:paper' }}>
                  <Typography className="UdS-title" variant="h6">Connectez-vous pour continuer</Typography>
                  <Login />
                </Box>
              </Grid>
            </Grid>}
        </body>
      </div>
    );
  }

}
