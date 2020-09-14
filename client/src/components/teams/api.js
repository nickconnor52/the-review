import axios from 'axios';

export const getAllTeams = () => {
  return axios({
    url: '/api/teams',
    method: 'GET',
  }).then(response => {
    return response.data || [];
  }).catch(response => {
    console.log(response);
    return [];
  });
}

export const getTeam = (id) => {
  return axios({
    url: `/api/teams/${id}`,
    method: 'GET',
  }).then(response => {
    return response.data || {};
  }).catch(response => {
    console.log(response);
    return {};
  });
}

export const getTeamTransactions = (id) => {
  return axios({
    url: `/api/teams/${id}/transactions`,
    method: 'GET',
  }).then(response => {
    return response.data || {};
  }).catch(response => {
    console.log(response);
    return {};
  });
}

export const getRoster = (id, year) => {
  return axios({
    url: `/api/teams/${id}/roster/${year}`,
    method: 'GET',
  }).then(response => {
    return response.data || {};
  }).catch(response => {
    console.log(response);
    return {};
  });
}
