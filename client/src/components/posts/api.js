import axios from 'axios';

export const getAllPosts = () => {
  return axios({
    url: '/api/posts',
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
    url: `/api/posts/${id}`,
    method: 'GET',
  }).then(response => {
    return response.data || [];
  }).catch(response => {
    console.log(response);
    return [];
  })
}

export const createPost = ({ content, title, summary }) => {
  return axios({
    url: '/api/posts',
    method: 'POST',
    data: {
      title,
      content,
      summary,
    },
    headers: {
      Authorization: `Bearer ${localStorage.getItem('token')}`
    },
  }).then(response => {
    return response.data || {};
  }).catch(response => {
    console.log(response);
  });
}

export const updatePost = ({ id, content, title, summary }) => {
  return axios({
    url: `/api/posts/${id}`,
    method: 'PUT',
    headers: {
      Authorization: `Bearer ${localStorage.getItem('token')}`
    },
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

export const deletePost = ({ id }) => {
  return axios({
    url: `/api/posts/${id}`,
    method: 'DELETE',
    headers: {
      Authorization: `Bearer ${localStorage.getItem('token')}`
    },
  }).catch(response => {
    console.log(response);
  });
}

export const saveComment = ({ body, userId, postId }) => {
  const token = localStorage.getItem('token')
  return axios({
    url: `/api/comments`,
    method: 'POST',
    headers: {
      Authorization: `Bearer ${token}`
    },
    data: {
      body,
      user_id: userId.toString(),
      post_id: postId,
    }
  }).then(response => {
    return response.data || {};
  }).catch(response => {
    console.log(response);
  });
}
