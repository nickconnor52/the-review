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

export const getTrade = (id) => {
  return axios({
    url: `/api/trades/${id}`,
    method: 'GET',
  }).then(response => {
    return response.data || [];
  }).catch(response => {
    console.log(response);
    return [];
  })
}

export const createTrade = ({ content, title, summary }) => {
  return axios({
    url: '/api/trades',
    method: 'POST',
    data: {
      title,
      content,
      summary,
    }
  }).then(response => {
    return response.data || {};
  }).catch(response => {
    console.log(response);
  });
}

export const updateTrade = ({ id, content, title, summary }) => {
  return axios({
    url: `/api/trades/${id}`,
    method: 'PUT',
    data: {
      title,
      content,
      summary,
    }
  }).then(response => {
    return response.data || {};
  }).catch(response => {
    console.log(response);
  });
}

export const deleteTrade = ({ id }) => {
  return axios({
    url: `/api/trades/${id}`,
    method: 'DELETE',
  }).catch(response => {
    console.log(response);
  });
}
