import React from 'react';
import '../css/UdS.css';
import '../css/QuickSwitch.css';
import Box from '@mui/material/Box';
import { Button, Divider, FormGroup, TextField, Typography } from '@mui/material';

class QuickSwitch extends React.Component {
    render() {
        return (
            <Box sx={{ width: '100%', maxWidth: 360, bgcolor: 'background:paper' }}>
                <Typography className="UdS-title" variant="h6">Entrez le CIP pour l'échange rapide :</Typography>
                <FormGroup>
                    <TextField className="QS-field" id="cip" label="CIP" variant="outlined" sx={{
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
                        Enregistrer
                    </Button>
                </FormGroup>
            </Box>
        );
    }
}

export default QuickSwitch;