import React, { useState } from 'react';
import styled, { css } from 'styled-components';
import { useHistory } from 'react-router-dom'

import { createPost } from './api';

import ReactMde from 'react-mde';
import ReactMarkdown from 'react-markdown';
import 'react-mde/lib/styles/css/react-mde-all.css';

const EditContainer = styled.div`
  display: flex;
  justify-content: center;
  align-items: center;
  flex-direction: column;
`

const Label = styled.span`
  margin-right: 1em;
  font-weight: bold;
`

const TitleInput = styled.input`
  margin-bottom: 1em;
`

const ButtonContainer = styled.div`
  display: flex;
  width: 60%;
  justify-content: center;
`

const Button = styled.a`
  width: 5em;
  text-align: center;
  display: inline-block;
  border-radius: 3px;
  padding: 0.5rem 0;
  margin: 0.5rem 1rem;
  width: 6em;
  background: transparent;
  color: white;
  border: 2px solid #444444;
  cursor: pointer;

  ${props => props.primary && css`
    background: #444444;
    color: white;
  `}
`

const inlineStyle = {
  width: '60%',
};

function EditPosts() {
  const [content, setContent] = useState("");
  const [title, setTitle] = useState("");
  const [selectedTab, setSelectedTab] = useState("write");
  const history = useHistory();

  const onSave = () => {
    createPost({ title, content }).then(() => {
      history.push('/posts')
    })
  }

  return (
    <EditContainer>
      <div>
        <Label>Title:</Label>
        <TitleInput value={title} onChange={(e) => setTitle(e.target.value)}/>
      </div>
      <div className="container" style={inlineStyle}>
        <ReactMde
          value={content}
          onChange={setContent}
          selectedTab={selectedTab}
          onTabChange={setSelectedTab}
          generateMarkdownPreview={(markdown) =>
            Promise.resolve(<ReactMarkdown source={markdown} />)
          }
        />
      </div>
      <ButtonContainer>
        <Button
          primary
          onClick={onSave}
        >
          Save
        </Button>
      </ButtonContainer>
    </EditContainer>
  );
}

export default EditPosts;
