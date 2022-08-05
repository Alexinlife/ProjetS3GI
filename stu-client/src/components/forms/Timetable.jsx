import React from 'react';
// import axios from 'axios';
import { Link } from 'react-router-dom';
import { toast } from 'react-toastify';
import '../../css/UdS.css';
import { withFormik } from 'formik';
import { Box, Button, FormControlLabel, Radio, RadioGroup, Typography } from '@mui/material';

/* const timetable = async () => {
    // const timetableResponse = await axios.get('');
    console.log(timetableResponse);
    return timetableResponse.data;
} */

const form = (props) => {
    const {
        values,
        isSubmitting,
        handleChange,
        handleSubmit,
    } = props;

    return (
        <Box className="UdS-option" component="form" onSubmit={handleSubmit}>
            <Link className="UdS-link" to={`/`}>
                <Button>Retour</Button>
            </Link>
            <Typography variant="h6">Sélectionnez les plages :</Typography>
            <RadioGroup
                name="slot"
                onChange={handleChange}
                value={values.slot}
            >
                { /*
                    timetable.map((item) => (
                        <FormControlLabel
                            control={
                                <Radio
                                    value="1"
                                    sx={{
                                        color: "#ffffff",
                                        '&.Mui-checked': {
                                            color: "#4D8406",
                                        },
                                    }}
                                />
                            }
                            label="9:00"
                        />
                    ))
                        */ }
                <FormControlLabel
                    control={
                        <Radio
                            value="1"
                            sx={{
                                color: "#ffffff",
                                '&.Mui-checked': {
                                    color: "#4D8406",
                                },
                            }}
                        />
                    }
                    label="9:00"
                />
                <FormControlLabel
                    control={
                        <Radio
                            value="2"
                            sx={{
                                color: "#ffffff",
                                '&.Mui-checked': {
                                    color: "#4D8406",
                                },
                            }}
                        />
                    }
                    label="11:00"
                />
                <FormControlLabel
                    control={
                        <Radio
                            value="3"
                            sx={{
                                color: "#ffffff",
                                '&.Mui-checked': {
                                    color: "#4D8406",
                                },
                            }}
                        />
                    }
                    label="13:00"
                />
            </RadioGroup>
            <Button className="UdS-btn" disabled={isSubmitting} type="submit" variant="contained">
                Soumettre
            </Button>
        </Box>
    );
};

const Timetable = withFormik({
    mapPropsToValues: ({ slot }) => {
        return {
            slot: slot || null,
        };
    },
    handleSubmit: async (values, { setSubmitting }) => {
        try {
            console.log(localStorage.getItem("selected_tutorat"));
            console.log(values.slot);
            var valid = false;
            if (localStorage.getItem("selected_tutorat") === null || values.slot === null) {
                toast.warn("Veuillez sélectionner un tutorat et au moins une plage");
            } else {
                valid = true;
            }
            if (window.location.pathname === "/request-change" && valid) {
                localStorage.removeItem("selected_tutorat");
                setSubmitting(false);
                window.location = "/";
            }
            if (window.location.pathname === "/availabilities" && valid) {
                setSubmitting(false);
                window.location = "/";
            }
            localStorage.removeItem("selected_tutorat");
        } catch (e) {
            console.log(e);
        }
    }
})(form);

export default Timetable;