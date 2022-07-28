import requestService from './requestService';

export async function authentificate(cip, password) {
    return requestService.post("http://localhost:8089/", { cip: cip, password: password });
}

export async function logout() {
    // localStorage.removeItem("session_token");
    localStorage.removeItem("cip");
    window.location = "/";
}
