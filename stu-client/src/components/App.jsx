import React from 'react';
import '../css/App.css';
import { BrowserRouter, Link, Routes, Route, Navigate } from 'react-router-dom';
import { Button, Grid } from '@mui/material';
import NavBar from './NavBar';
import Schedule from './Schedule';
import Menu from './Menu';
import Availabilities from './Availabilities';
import QuickSwitch from './QuickSwitch';

export default class App extends React.Component {
  render() {
    return (
      <div className="App">
        <header className="App-header">
          <NavBar />
        </header>
        <body className="App-body">
            <Grid container rowSpacing={1} columnSpacing={{ sm: 6, md: 12 }}>
              <Grid className="App-left" item xs={12} sm={6}>
                <Schedule />
              </Grid>
              <Grid className="App-right" item xs={12} sm={6}>
                <BrowserRouter>
                  <Routes>
                    {/* Menu principal */}
                    <Route path="/home" element={<Menu />} />
                    {/* Disponibilités */}
                    <Route path="/availabilities" element={<Availabilities />} />
                    {/* Échange rapide */}
                    <Route path="/quick-switch" element={<QuickSwitch />} />
                  </Routes>
                </BrowserRouter>
              </Grid>
            </Grid>
        </body>
      </div>
    );
  }

}
