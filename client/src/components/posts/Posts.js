import React, { useEffect, useState } from 'react';
import styled from 'styled-components/macro';

import { getAllPosts } from './api';

import Markdown from 'react-markdown';

const PostContainer = styled.div`
  display: flex;
`

const Header = styled.h1`
  text-align: center;
`

const Title = styled.text`
  font-weight: bold;
`

function Post(props) {
  const { content, title } = props;

  return (
    <PostContainer>
      <Title>{title}</Title>
      <Markdown
        source={content}
      />
    </PostContainer>
  );
}

export default function Posts() {
  // TODO - Refactor to a hook
  const [posts, setPosts] = useState([]);
  useEffect(() => {
    getAllPosts()
      .then(posts => {
        console.log(posts)
        setPosts(posts);
      });
  }, []);

  const postList = posts.map(post => <Post {...post} />)
  return (
    <div>
      <Header>
        Welcome to my ramblings
      </Header>
      {
        postList
      }
    </div>
  );
}
