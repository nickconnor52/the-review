import axios from 'axios';

export const getBestBallScores = () => {
  return axios({
    url: '/api/scores/best_ball',
    method: 'GET',
  }).then(response => {
    return response.data || [];
  }).catch(response => {
    console.log(response);
    return [];
  });
}
