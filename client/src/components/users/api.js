import axios from 'axios'

export const login = ({ email, password }) => {
  return axios({
    url: '/api/login',
    method: 'POST',
    data: {
      email,
      password,
    }
  }).then(response => {
    return response.data || {};
  }).catch(response => {
    console.log(response);
  });
}

export const autoLogin = (token) => {
  return axios({
    url: '/api/auto_login',
    method: 'GET',
    headers: {
      Authorization: `Bearer ${token}`,
    }
  }).then(response => {
    return response.data || {};
  }).catch(response => {
    console.log(response);
  });
}
