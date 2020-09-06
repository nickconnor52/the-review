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
  });
}

export const getPost = (id) => {
  return axios({
    url: `/posts/${id}`,
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
    return response.data || {};
  }).catch(response => {
    console.log(response);
  });
}

export const updatePost = ({ id, content, title }) => {
  return axios({
    url: `/posts/${id}`,
    method: 'PUT',
    data: {
      title,
      content
    }
  }).then(response => {
    return response.data || {};
  }).catch(response => {
    console.log(response);
  });
}

export const deletePost = ({ id }) => {
  return axios({
    url: `/posts/${id}`,
    method: 'DELETE',
  }).catch(response => {
    console.log(response);
  });
}
