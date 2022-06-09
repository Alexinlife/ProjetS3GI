import '../css/App.css';
import { Grid } from '@mui/material';
import NavBar from './NavBar';
import Schedule from './Schedule';
import Menu from './Menu';
import Availabilities from './Availabilities';
import QuickSwitch from './QuickSwitch';

function App() {
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
            <Menu />
          </Grid>
        </Grid>
      </body>
    </div>
  );
}

export default App;
