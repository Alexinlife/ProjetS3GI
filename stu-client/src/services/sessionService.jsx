// import requestService from './requestService';

// import Keycloak from "http://localhost:8180/js/keycloak.js";

/* export function initKeycloak() {
    const keycloak = new Keycloak({
        "realm": "usager",
        "auth-server-url": "http://localhost:8180/",
        "ssl-required": "external",
        "clientId": "frontend",
        "public-client": true,
        "confidential-port": 0
    });
    keycloak.init({onLoad: 'login-required'}).then(function (authenticated) {
        alert(authenticated ? 'authenticated' : 'not authenticated');

    }).catch(function () {
        alert('failed to initialize');
    });
} */

export async function authentificate(cip, password) {
    return {
        data: {
            session_token: "aa",
            exp_token: "aa",
        }
    }
    // return requestService.post("http://localhost:8089/", { cip: cip, password: password });
}

export async function logout() {
    localStorage.removeItem("session_token");
    window.location = "/";
}
