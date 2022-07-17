
export async function authentificate(cip, password) {
    return {
        data: {
            session_token: "aa",
            exp_token: "aa",
        }
    }
}

export async function logout() {
    localStorage.removeItem("session_token");
    window.location = "/";
  }
