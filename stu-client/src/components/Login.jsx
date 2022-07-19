import React from 'react';
import * as sessionService from '../services/sessionService.jsx';
import '../css/UdS.css';
import { withFormik } from 'formik';
import * as yup from 'yup';
import { Box, Button, TextField } from '@mui/material';

const validation = {
    cip: yup
        .string()
        .required("Le champ CIP est obligatoire")
        .min(8, "Le champ CIP doit contenir exactement 8 caractères")
        .max(8, "Le champ CIP doit contenir exactement 8 caractères"),
    password: yup
        .string()
        .required("Un mot de passe est requis"),
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
            <Box component="form" noValidate onSubmit={handleSubmit}>
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
                <TextField
                    error={touched.password && Boolean(errors.password)}
                    fullWidth
                    helperText={touched.password ? errors.password : ""}
                    id="password"
                    label="Password"
                    name="password"
                    onBlur={handleBlur}
                    onChange={handleChange}
                    required
                    value={values.password}
                    type="password"
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
                    Connexion
                </Button>
            </Box>
    );
};

const Login = withFormik({
    mapPropsToValues: ({ cip, password }) => {
        return {
            cip: cip || "",
            password: password || "",
        };
    },
    validationSchema: yup.object().shape(validation),
    handleSubmit: async (values, { setSubmitting }) => {
        try {
            const response = await sessionService.authentificate(values.cip, values.password);
            const sessionToken = response.data.session_token;
            const expToken = response.data.exp_token;
            localStorage.setItem("session_token", sessionToken);
            localStorage.setItem("exp_token", expToken);
            localStorage.setItem("cip", String(values.cip).toLowerCase());
            setSubmitting(false);
            window.location = "/";
        } catch (e) {
            console.log(e);
        }
    }
})(form);

export default Login;
