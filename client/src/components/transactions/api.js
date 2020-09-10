import axios from 'axios';

export const getAllTransactions = () => {
  return axios({
    url: '/api/transactions',
    method: 'GET',
  }).then(response => {
    return response.data || [];
  }).catch(response => {
    console.log(response);
    return [];
  });
}
