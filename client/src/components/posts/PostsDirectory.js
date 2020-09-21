import React, { useEffect, useState } from 'react';
import styled, { css } from 'styled-components/macro';
import { isEmpty } from 'lodash'
import { Link, useHistory } from 'react-router-dom';
import moment from 'moment';
import { sm, colors } from '../../core/style'

import { getAllChatter, getAllRamblings } from './api';

import Markdown from 'react-markdown';
import { useActiveUserState } from '../../context/ActiveUserContext';

const Container = styled.div`
  margin-top: 2em;
  display: flex;
  justify-content: center
`

const BodyContainer = styled.div`
  display: flex;
  flex-direction: column;
  align-items: center;
  width: 80%;
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
  font-size: 2em;
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

const HeaderContainer = styled.div`
  display: flex;
  flex-direction: column;
  justify-content: center;
  width: 100%;
  margin-bottom: 1em;
  ${props => props.userPresent && css`
    margin-bottom: -2em;
  `}


  @media(max-width: ${sm}) {
    margin-bottom: 1em;
  }
`

const ButtonContainer = styled.div`
  display: flex;
  justify-content: flex-end;
  position: relative;
  top: -3em;

  @media(max-width: ${sm}) {
    top: 0;
    justify-content: center;
  }
`

const Button = styled.a`
  text-align: center;
  display: inline-block;
  border-radius: 3px;
  padding: 0.5rem 0;
  margin: 0.5rem 1rem;
  width: 10em;
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
  margin-top: 1em;
`

const PreviewContainer = styled.div`
  width: 100%;
  text-align: center;
`

function PostPreview(props) {
  const { content, title, summary, id, user, isChatter, created_at: createdAt } = props;
  const trimmedContent = content.length > 250 ? `${content.substring(0, 250)}...` : content;
  const username = user.username || 'Ghost Writer'
  const createdDate = moment(createdAt).format('MMMM Do, YYYY')
  const path = isChatter ? '/chatter' : '/ramblings'

  return (
    <PostContainer>
      <Title>{title}</Title>
      {
        isChatter ?
          (
            <InfoContainer>
              <Author>{username}:</Author>
              <Date>{createdDate}</Date>
            </InfoContainer>
          ) :
          (
            <InfoContainer>
              <Date>{createdDate}</Date>
            </InfoContainer>
          )
      }
      <PreviewContainer>
        <Markdown
          source={summary || trimmedContent}
        />
        <PostLink>
          <Link to={`${path}/${id}`}>see more >></Link>
        </PostLink>
      </PreviewContainer>
    </PostContainer>
  );
}

export default function PostsDirectory(props) {
  const { isChatter } = props;
  const history = useHistory();
  const activeUser = useActiveUserState();
  // TODO - Refactor to a hook
  const [posts, setPosts] = useState([]);
  useEffect(() => {
    if (isChatter) {
      getAllChatter()
        .then(posts => {
          setPosts(posts);
        });
    } else {
      getAllRamblings()
        .then(posts => {
          setPosts(posts);
        });
    }
  }, [isChatter]);

  const userLoggedIn = !isEmpty(activeUser)
  const handleNewChatter = () => {
    history.push('/chatter/edit')
  }

  const postList = posts.map(post => <PostPreview key={post.id} isChatter={isChatter} {...post} />)

  return (
    <Container>
      <BodyContainer>
        <HeaderContainer userPresent={isChatter && userLoggedIn}>
          <Header>
            {
              isChatter ? 'Welcome to the League Chatter' : ' Welcome to My Ramblings'
            }
          </Header>
          {
            userLoggedIn && isChatter ?
              (
                <ButtonContainer>
                  <Button
                    primary
                    onClick={handleNewChatter}
                  >
                    Make Some Noise
                  </Button>
                </ButtonContainer>
              ) :
              (
                null
              )
          }
        </HeaderContainer>
        <PostsContainer>
        {
          postList.length !== 0 ?
            (
              postList
            ) :
            (
              <div style={{ marginTop: '1em', fontStyle: 'italic' }}>
                It's a little quiet in here
              </div>
            )
        }
        </PostsContainer>
      </BodyContainer>
    </Container>
  );
}
