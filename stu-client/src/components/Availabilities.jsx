import React from 'react';
import { Link } from 'react-router-dom';
import '../css/UdS.css';
import Box from '@mui/material/Box';
import { Button, Checkbox, FormControlLabel, FormGroup, Typography } from '@mui/material';

class Availabilities extends React.Component {
    state = {
        availabilities: [],
    }

    render() {
        return (
            <Box className="UdS-option" sx={{ width: '100%', maxWidth: 360, bgcolor: 'background:paper' }}>
                <Link className="UdS-link" to={`/`}>
                    <Button>Retour</Button>
                </Link>
                <Typography className="UdS-title" variant="h6">Changez vos disponibilités :</Typography>
                <FormGroup>
                    <FormControlLabel control={<Checkbox sx={{
                        color: "#4D8406",
                        '&.Mui-checked': {
                            color: "#4D8406",
                        },
                    }} defaultChecked />} label="9:00" />

                    <FormControlLabel control={<Checkbox sx={{
                        color: "#4D8406",
                        '&.Mui-checked': {
                            color: "#4D8406",
                        },
                    }} />} label="11:00" />

                    <FormControlLabel control={<Checkbox sx={{
                        color: "#4D8406",
                        '&.Mui-checked': {
                            color: "#4D8406",
                        },
                    }} />} label="13:00" />

                    <Button className="UdS-btn" variant="contained" component="span">
                        Enregistrer
                    </Button>
                </FormGroup>
            </Box>
        );
    }
}

export default Availabilities;