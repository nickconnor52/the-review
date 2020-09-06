import axios from 'axios';

export const getAllPosts = () => {
  return axios({
    url: '/posts',
    method: 'GET',
  }).then(response => {
    return response.data || [];
  }).catch(response => {
    console.log(response);
    return [];
  })
}

export const createPost = ({ content, title }) => {
  return axios({
    url: '/posts',
    method: 'POST',
    data: {
      title,
      content
    }
  }).then(response => {
    console.log(response);
  }).catch(response => {
    console.log(response);
  })
}
