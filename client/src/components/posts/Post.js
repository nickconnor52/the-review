import React, { useEffect, useState } from "react";
import styled from 'styled-components/macro';
import { useParams } from 'react-router-dom';

import { getPost } from './api';

import Markdown from 'react-markdown';
import './post.scss'
import 'github-markdown-css';

const bodyStyle = {
  display: 'flex',
  width: '60%',
  flexDirection: 'column',
}

const PostContainer = styled.div`
  display: flex;
  flex-direction: column;
  width: 100%;
  align-items: center;
  margin-bottom: 2em;
`

const Title = styled.h2`
  font-weight: bold;
`

const Body = styled.div`
  display: flex;
  width: 75%;
  flex-direction: column;
`

const MyImage = props => {
  const [fullSize, setFullSize] = useState();
  const handleClick = () => {
    setFullSize(!fullSize);
  };
  return (
    <img
      className={fullSize ? "large" : "small"}
      alt={props.alt}
      src={props.src}
      onClick={handleClick}
    />
  );
};

function Post() {
  const { id } = useParams();
  const [title, setTitle] = useState('');
  const [content, setContent] = useState('');
  const renderers = {
    image: MyImage
  };

  useEffect(() => {
    getPost(id).then(post => {
      setTitle(post.title)
      setContent(post.content)
    })
  }, [id]);

  return (
    <PostContainer>
      <Title>{title}</Title>
      <div style={bodyStyle} className="markdown-body">
        <Markdown
          source={content}
          renderers={renderers}
        />
      </div>
    </PostContainer>
  );
}

export default Post;
