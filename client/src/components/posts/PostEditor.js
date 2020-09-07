import React, { useEffect, useState } from 'react';
import styled, { css } from 'styled-components';
import { useHistory, useParams } from 'react-router-dom'
import { isUndefined } from 'lodash'

import { createPost, getPost, updatePost, deletePost } from './api';

import ReactMde from 'react-mde';
import ReactMarkdown from 'react-markdown';
import 'react-mde/lib/styles/css/react-mde-all.css';

const EditContainer = styled.div`
  margin-top: 2em;
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
  color: #444444;
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

const SummaryContainer = styled.div`
  display: flex;
  flex-direction: row;
  align-items: center;
  margin-bottom: 1em;
`

function PostEditor() {
  const { id } = useParams();
  const isNew = isUndefined(id);
  const [content, setContent] = useState("");
  const [title, setTitle] = useState("");
  const [summary, setSummary] = useState("");
  const [selectedTab, setSelectedTab] = useState("write");
  const history = useHistory();

  const onDelete = () => {
    if (window.confirm('You serious Clark??')) {
      deletePost({id}).then(() => {
        history.push(`/posts`)
      })
    }
  }

  const onSave = () => {
    if (isNew) {
      createPost({ title, content, summary }).then((post) => {
        history.push(`/posts/${post.id}`)
      });
    } else {
      updatePost({ title, content, summary, id}).then((post) => {
        history.push(`/posts/${id}`)
      })
    }
  }

  useEffect(() => {
    if (!isNew) {
      getPost(id).then(post => {
        setContent(post.content)
        setTitle(post.title)
        setSummary(post.summary)
      })
    }
  }, []);

  return (
    <EditContainer>
      <div>
        <Label>Title:</Label>
        <TitleInput value={title} onChange={(e) => setTitle(e.target.value)}/>
      </div>
      <SummaryContainer>
        <Label>Summary:</Label>
        <textarea value={summary} onChange={(e) => setSummary(e.target.value)} rows="4" cols="50" />
      </SummaryContainer>
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
          onClick={onDelete}
        >
          Delete
        </Button>
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

export default PostEditor;
