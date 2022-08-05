import React from 'react';
import { Link } from 'react-router-dom';
import '../../css/UdS.css';
import { Box, Button, Checkbox, FormControlLabel, FormGroup, Typography } from '@mui/material';

const form = (props) => {
    const {
        values,
        touched,
        errors,
        isSubmitting,
        handleChange,
        handleBlur,
        handleSubmit,
    } = props;

    return (
        <Box component="form" onSubmit={handleSubmit}>
            <Link className="UdS-link" to={`/`}>
                <Button>Retour</Button>
            </Link>
            <Typography variant="h6">Changez vos disponibilités :</Typography>
            <FormGroup>
                <FormControlLabel
                    key="0"
                    value="0"
                    control={
                        <Checkbox
                            defaultChecked
                            checked={values.}
                            sx={{
                                color: "#4D8406",
                                '&.Mui-checked': {
                                    color: "#4D8406",
                                },
                            }}
                        />
                    }
                    label="9:00"
                />
                <FormControlLabel
                    key="1"
                    value="2"
                    control={
                        <Checkbox
                            sx={{
                                color: "#4D8406",
                                '&.Mui-checked': {
                                    color: "#4D8406",
                                },
                            }}
                        />
                    }
                    label="11:00"
                />
                <FormControlLabel
                    key="2"
                    value="2"
                    control={
                        <Checkbox
                            sx={{
                                color: "#4D8406",
                                '&.Mui-checked': {
                                    color: "#4D8406",
                                },
                            }}
                        />
                    }
                    label="13:00"
                />
            </FormGroup>
            <Button className="UdS-btn" variant="contained" component="span">
                Enregistrer
            </Button>
        </Box>
    );
};

const Timetable = withFormik({
    mapPropsToValues: ({ }) => {
        return {
        };
    },
    validationSchema: yup.object().shape(validation),
    handleSubmit: async (values, { setSubmitting }) => {
        try {
            setSubmitting(false);
            window.location = "/";
        } catch (e) {
            console.log(e);
        }
    }
})(form);

export default Timetable;