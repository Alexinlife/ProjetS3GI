// import requestService from './requestService';

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
