import React, { useEffect, useState } from "react";
import styled, { css } from 'styled-components/macro';
import { useParams } from 'react-router-dom';
import { useActiveUserState } from '../../context/ActiveUserContext';
import MarkdownEditor from '../../core/MardownEditor';
import { colors, sm } from '../../core/style';
import { isEmpty, get } from 'lodash';
import moment from 'moment'

import { getPost, saveComment } from './api';

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
`

const Title = styled.h2`
  font-weight: bold;
`

const Header = styled.div`
  font-weight: bold;
  font-size: 1.5em;
`

const CommentsContainer = styled.div`
  display: flex;
  margin-top: 2em;
  flex-direction: column;
  align-items: center;
  width: 100%;
`

const CommentContainer = styled.div`
  display: flex;
  flex-direction: column;
  width: 60%;
  background-color: white;
  border-radius: 10px;
  margin-bottom: 2em;
  box-shadow: 0 0 16px rgba(0,0,0,0.15);
  padding: 1em;
`

const ReplyContainer = styled.div``

const CommentInfoContainer = styled.div`
  margin-bottom: 0.5em;
  display: flex;
  justify-content: space-between;
  align-items: center;

  @media(max-width: ${sm}) {
    flex-direction: column;
  }
`

const CommentAuthor = styled.div`
  font-weight: bold;
`

const CommentDate = styled.div`
  color: ${colors.midGrey};
  font-weight: 300;
  font-size: 0.8em;
`

const BodyContainer = styled.div``

const ButtonContainer = styled.div`
  display: flex;
  justify-content: flex-end;
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

const Author = styled.div`
  font-weight: 600;
  font-size: 0.8em;
  margin-right: 1em;
`
const Date = styled.div`
  color: ${colors.midGrey};
  font-weight: 300;
  font-size: 0.8em;
`

const InfoContainer = styled.div`
  display: flex;
  justify-content: center;
  width: 100%;
  margin-bottom: 1em;
`

const Break = styled.hr`
  border: 0;
  margin-top: 0;
  height: 1px;
  background-image: -webkit-linear-gradient(left, #f0f0f0, #8c8b8b, #f0f0f0);
  background-image: -moz-linear-gradient(left, #f0f0f0, #8c8b8b, #f0f0f0);
  background-image: -ms-linear-gradient(left, #f0f0f0, #8c8b8b, #f0f0f0);
  background-image: -o-linear-gradient(left, #f0f0f0, #8c8b8b, #f0f0f0);
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

function Comment(props) {
  const { author = {}, body, created_at: createdAt } = props;
  const { username = '' } = author;

  const date = moment(createdAt).format('LT MMM Do, YYYY')

  return (
    <CommentContainer>
      <CommentInfoContainer>
        <CommentAuthor>
          {username}
        </CommentAuthor>
        <CommentDate>
          {date}
        </CommentDate>
      </CommentInfoContainer>
      <BodyContainer>
        <Markdown
          source={body}
        />
      </BodyContainer>
    </CommentContainer>
  );
}

function Post() {
  const { id } = useParams();
  const [title, setTitle] = useState('');
  const [content, setContent] = useState('');
  const [username, setUsername] = useState('');
  const [createdDate, setCreatedDate] = useState('');
  const [comments, setComments] = useState([]);
  const [newCommentBody, setNewCommentBody] = useState("");
  const activeUser = useActiveUserState();
  const renderers = {
    image: MyImage
  };

  useEffect(() => {
    getPost(id).then(post => {
      setTitle(post.title)
      setUsername(`${get(post, ['user', 'first_name'], '')} ${get(post, ['user', 'last_name'], '')}`)
      setCreatedDate(moment(post.created_at).format('MMMM Do, YYYY'))
      setContent(post.content)
      setComments(post.comments)
    })
  }, [id]);

  const onSaveComment = () => {
    saveComment({ body: newCommentBody, userId: activeUser.id, postId: id }).then(response => {
      const newComment = response;
      setComments([
        ...comments,
        newComment
      ]);
      setNewCommentBody('');
    })
  }

  return (
    <PostContainer>
      <Title>{title}</Title>
      <InfoContainer>
        <Author>{username}:</Author>
        <Date>{createdDate}</Date>
      </InfoContainer>
      <div style={bodyStyle} className="markdown-body">
        <Markdown
          source={content}
          renderers={renderers}
        />
      </div>
      <div style={{marginTop: '2em', width: '100%'}}>
        <Break />
      </div>
      <CommentsContainer>
        <Header style={{ marginBottom: '1em' }}>
          Comments
        </Header>
        {
          comments && comments.length !== 0 ?
            (
              comments.map(comment => (
                <Comment key={comment.id} {...comment} />
              ))
            ) :
            (
              <div style={{marginBottom: '2em', fontStyle: 'italic'}}>It's awfully quiet in here</div>
            )
        }
        {
          !isEmpty(activeUser) ?
            (
              <ReplyContainer>
                <MarkdownEditor
                  content={newCommentBody}
                  onChange={setNewCommentBody}
                />
                <ButtonContainer>
                  <Button
                    primary
                    onClick={onSaveComment}
                  >
                    Save
                  </Button>
                </ButtonContainer>
              </ReplyContainer>
            ) :
            (
              null
            )
        }
      </CommentsContainer>
    </PostContainer>
  );
}

export default Post;
