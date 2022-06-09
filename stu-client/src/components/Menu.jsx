import React from 'react';
import '../css/UdS.css';
import'../css/Menu.css';
import Box from '@mui/material/Box';
import { Button, Typography } from '@mui/material';

class Menu extends React.Component {
    render() {
        return (
            <Box className="Menu-box" sx={{ width: '100%', maxWidth: 360, bgcolor: 'background:paper' }}>
                <Typography className="UdS-title" variant="h6">Sélectionnez une option :</Typography>
                <Button className="UdS-btn" variant="contained" component="span">
                    Je veux échanger
                </Button>
                <Button className="UdS-btn" variant="contained" component="span">
                    Je suis disponible
                </Button>
                <Button className="UdS-btn" variant="contained" component="span">
                    Échange rapide
                </Button>
            </Box>
        );
    }
}

export default Menu;