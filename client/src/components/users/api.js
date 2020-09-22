import axios from 'axios'

export const createUser = ({ email, username, firstName, lastName, password }) => {
  return axios({
    url: '/api/users',
    method: 'POST',
    data: {
      email,
      username,
      first_name: firstName,
      last_name: lastName,
      password,
    }
  }).then(response => {
    return response.data || {};
  }).catch(response => {
    console.log(response);
  });
}

export const updateUser = ({ id, email, username, firstName, lastName }) => {
  return axios({
    url: '/api/users/update',
    method: 'POST',
    headers: {
      Authorization: `Bearer ${localStorage.getItem('token')}`
    },
    data: {
      id,
      email,
      username,
      first_name: firstName,
      last_name: lastName,
    }
  }).then(response => {
    return response.data || {};
  }).catch(response => {
    console.log(response);
  });
}

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
