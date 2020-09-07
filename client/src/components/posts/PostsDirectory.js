import React, { useEffect, useState } from 'react';
import styled from 'styled-components/macro';
import { Link } from 'react-router-dom';

import { getAllPosts } from './api';

import Markdown from 'react-markdown';

const Container = styled.div`
  margin-top: 2em;
`

const PostContainer = styled.div`
  display: flex;
  flex-direction: column;
  width: 60%;
  align-items: center;
`

const PostsContainer = styled.div`
  display: flex;
  width: 100%;
  flex-direction: column;
  align-items: center;
`

const Header = styled.div`
  font-size: 1.5em;
  font-weight: 600;
  text-align: center;
`

const Title = styled.h2`
  font-style: italic;
  font-weight: bold;
  margin-bottom: 0;
`

const PostLink = styled.div`
  display: flex;
  justify-content: flex-end;
`

function PostPreview(props) {
  const { content, title, summary, id } = props;
  const trimmedContent = content.length > 250 ? `${content.substring(0, 250)}...` : content;

  return (
    <PostContainer>
      <Title>{title}</Title>
      <div>
        <Markdown
          source={summary || trimmedContent}
        />
        <PostLink>
          <Link to={`/posts/${id}`}>see more >></Link>
        </PostLink>
      </div>
    </PostContainer>
  );
}

export default function PostsDirectory() {
  // TODO - Refactor to a hook
  const [posts, setPosts] = useState([]);
  useEffect(() => {
    getAllPosts()
      .then(posts => {
        setPosts(posts);
      });
  }, []);

  const postList = posts.map(post => <PostPreview key={post.id} {...post} />)
  return (
    <Container>
      <Header>
        Welcome to My Ramblings
      </Header>
      <PostsContainer>
      {
        postList
      }
      </PostsContainer>
    </Container>
  );
}
