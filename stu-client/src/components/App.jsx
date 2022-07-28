import React from 'react';
import { ToastContainer } from 'react-toastify';
import 'react-toastify/dist/ReactToastify.css';
import '../css/App.css';
import { BrowserRouter, Navigate, Routes, Route } from 'react-router-dom';
// import jwtDecode from "jwt-decode";
import { Box, Grid, Typography } from '@mui/material';
// import * as sessionService from '../services/sessionService';
import NavBar from './NavBar';
import Login from './forms/Login';
import Schedule from './Schedule';
import Menu from './Menu';
import Timetable from './forms/Timetable';
import QuickSwitch from './forms/QuickSwitch';

export default class App extends React.Component {
  state = {
    sessionToken: "",
  }

  componentDidMount() {
    /* try {
      this.setState({
        sessionToken: jwtDecode(localStorage.getItem("session_token")),
        cip: localStorage.getItem("cip"),
      });
    } catch (e) {
      console.error(e);
    } */

    this.setState({
      // sessionToken: localStorage.getItem("session_token"),
      cip: localStorage.getItem("cip"),
    });
  }

  render() {
    return (
      <div className="App">
        <header className="App-header">
          <NavBar />
        </header>
        <body className="App-body">
          {/* this.state.sessionToken */ this.state.cip ?
            <Grid container rowSpacing={1} columnSpacing={{ sm: 6, md: 12 }}>
              <Grid className="App-left" item xs={12} sm={6}>
                <Schedule />
              </Grid>
              <Grid className="App-right" item xs={12} sm={6}>
                <BrowserRouter>
                  <Routes>
                    <Route path='*' element={<Navigate to="/" replace />} />
                    {/* Menu principal */}
                    <Route index element={<Menu />} path="/" />
                    {/* Demande d'échange */}
                    <Route path="/request-change" element={<Timetable />} />
                    {/* Disponibilités */}
                    <Route path="/availabilities" element={<Timetable />} />
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
          <ToastContainer
            position="bottom-right"
            autoClose={5000}
            hideProgressBar={false}
            newestOnTop={false}
            closeOnClick
            rtl={false}
            pauseOnFocusLoss
            draggable
            pauseOnHover
          />
        </body>
      </div>
    );
  }

}
