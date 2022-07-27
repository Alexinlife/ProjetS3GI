import axios from "axios";
import { toast } from "react-toastify";

const accessToken = localStorage.getItem("access_token");

if (accessToken) {
  axios.defaults.headers.common["Authorization"] = `Bearer ${accessToken}`;
}

axios.interceptors.response.use(null, (error) => {
  const handledError =
    error.response &&
    error.response.status >= 400 &&
    error.response.status < 500;

  if (!handledError) {
    toast.error("Une erreur inattendue est survenue.");
  }

  return Promise.reject(error);
});

const request = {
  get: axios.get,
  post: axios.post,
  put: axios.put,
  delete: axios.delete,
};

export default request;
