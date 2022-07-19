import React from 'react';
import { Link } from 'react-router-dom';
import '../css/UdS.css';
import '../css/Menu.css';
import { Box, Button, Typography } from '@mui/material';

class Menu extends React.Component {
    render() {
        return (
            <Box>
                <Typography className="UdS-title" variant="h6">Sélectionnez une option :</Typography>
                <Box className="menu-box" sx={{ width: '100%', maxWidth: 360 }}>
                    <Link className="UdS-link" to={`/availabilities`}>
                        <Button className="UdS-btn" variant="contained" component="span">
                            Je veux échanger
                        </Button>
                    </Link>
                    <Link className="UdS-link" to={`/availabilities`}>
                        <Button className="UdS-btn" variant="contained" component="span">
                            Je suis disponible
                        </Button>
                    </Link>
                    <Link className="UdS-link" to={`/quick-switch`}>
                        <Button className="UdS-btn" variant="contained" component="span">
                            Échange rapide
                        </Button>
                    </Link>
                </Box>
            </Box>
        );
    }
}

export default Menu;