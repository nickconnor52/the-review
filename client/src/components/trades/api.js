import axios from 'axios';

export const getAllTrades = () => {
  return axios({
    url: '/api/trades',
    method: 'GET',
  }).then(response => {
    return response.data || [];
  }).catch(response => {
    console.log(response);
    return [];
  });
}
