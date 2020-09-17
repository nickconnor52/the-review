import axios from 'axios';

export const getDraftByYear = (year) => {
  return axios({
    url: `/api/drafts/${year}`,
    method: 'GET',
  }).then(response => {
    return response.data || [];
  }).catch(response => {
    console.log(response);
    return [];
  });
}
