import React from 'react';
import axios from 'axios';
import { Link } from 'react-router-dom';
import { toast } from 'react-toastify';
import '../../css/UdS.css';
import { withFormik } from 'formik';
import * as yup from 'yup';
import { Box, Button, TextField, Typography } from '@mui/material';

const validation = {
    cip: yup
        .string()
        .required("Le champ CIP est obligatoire")
        .matches(/^[a-zA-Z]+[0-9]+$/, "Le format du CIP est incorrect")
        .min(8, "Le champ CIP doit contenir exactement 8 caractères")
        .max(8, "Le champ CIP doit contenir exactement 8 caractères"),
};

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
        <Box className="UdS-option" component="form" onSubmit={handleSubmit}>
            <Link className="UdS-link" to={`/`}>
                <Button>Retour</Button>
            </Link>
            <Typography className="UdS-title" variant="h6">Entrez le CIP pour l'échange rapide :</Typography>
            <TextField
                autoFocus
                error={touched.cip && Boolean(errors.cip)}
                fullWidth
                helperText={touched.cip ? errors.cip : ""}
                id="cip"
                label="CIP"
                name="cip"
                onBlur={handleBlur}
                onChange={handleChange}
                required
                value={values.cip}
                variant="outlined"
                sx={{
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
                }}
            />
            <Button className="UdS-btn" disabled={isSubmitting} type="submit" variant="contained">
                Soumettre
            </Button>
        </Box>
    );
};

const QuickSwitch = withFormik({
    mapPropsToValues: ({ cip }) => {
        return {
            cip: cip || "",
        };
    },
    validationSchema: yup.object().shape(validation),
    handleSubmit: async (values, { setSubmitting }) => {
        try {
            var valid = false;
            if (localStorage.getItem("selected_tutorat") === null) {
                toast.warn("Veuillez sélectionner un tutorat");
            } else {
                valid = true;
            }
            if (valid) {
                const quickSwitchResponse = await axios.get('http://localhost:8089/api/echange-rapide/' + localStorage.getItem("cip") + "/" + values.cip + "/" + localStorage.getItem("selected_tutorat"));
                console.log(quickSwitchResponse);
                localStorage.removeItem("selected_tutorat");
                setSubmitting(false);
                toast.success("Échange complété");
                window.location = "/quick-switch";
            }
        } catch (e) {
            console.log(e);
        }
    }
})(form);

export default QuickSwitch;
