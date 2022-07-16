import React from 'react';
import '../css/UdS.css';
import Box from '@mui/material/Box';
import { Button, Divider, FormGroup, TextField, Typography } from '@mui/material';

class Login extends React.Component {
    render() {
        return (
            <Box className="UdS-option" sx={{ width: '100%', maxWidth: 360, bgcolor: 'background:paper' }}>
                <Typography className="UdS-title" variant="h6">Connectez-vous pour continuer</Typography>
                <FormGroup>
                    <TextField autoFocus id="cip" label="CIP" required variant="outlined" sx={{
                        '& ': {
                            marginTop: '30px',
                        },
                        '& label': {
                            color: 'white',
                        },
                        '& label.Mui-focused': {
                            color: 'white',
                        },
                        '& input': {
                            color: 'white',
                        },
                        '& .MuiOutlinedInput-root': {
                            '& fieldset': {
                                borderColor: '#4D8406',
                            },
                            '&:hover fieldset': {
                                borderColor: '#4D8406',
                            },
                            '&.Mui-focused fieldset': {
                                borderColor: '#4D8406',
                            },
                        },
                    }} />
                    <TextField id="password" label="password" required type="password" variant="outlined" sx={{
                        '& ': {
                            marginTop: '30px',
                        },
                        '& label': {
                            color: 'white',
                        },
                        '& label.Mui-focused': {
                            color: 'white',
                        },
                        '& input': {
                            color: 'white',
                        },
                        '& .MuiOutlinedInput-root': {
                            '& fieldset': {
                                borderColor: '#4D8406',
                            },
                            '&:hover fieldset': {
                                borderColor: '#4D8406',
                            },
                            '&.Mui-focused fieldset': {
                                borderColor: '#4D8406',
                            },
                        },
                    }} />
                    <Divider />
                    <Button className="UdS-btn" variant="contained" component="span">
                        Connexion
                    </Button>
                </FormGroup>
            </Box>
        );
    }
}

export default Login;