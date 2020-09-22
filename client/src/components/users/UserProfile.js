import React, { useState } from 'react'
import styled, { css } from 'styled-components'
import { updateUser } from './api';
import { useHistory } from 'react-router-dom'
import { useActiveUserDispatch, useActiveUserState } from '../../context/ActiveUserContext'

const Container = styled.div`
  margin-top: 2em;
  display: flex;
  align-items: center;
  flex-direction: column;
`

const Header = styled.div`
  font-size: 1.5em;
  font-weight: 600;
  text-align: center;
`

const FieldsContainer = styled.div`
  margin-top: 2em;
  display: flex;
  width: 100%;
  flex-direction: column;
  align-items: center;
`

const InputLabel = styled.div`
margin-right: 1em;
font-weight: bold;
`

const InputRow = styled.div`
  display: flex;
  width: 100%;
  justify-content: center;
  align-items: center;
  margin-bottom: 1em;
`

const ButtonContainer = styled.div`
  display: flex;
  width: 60%;
  justify-content: center;
`

const Button = styled.a`
  text-align: center;
  display: inline-block;
  border-radius: 3px;
  padding: 0.5rem 0;
  margin: 0.5rem 1rem;
  width: 7em;
  background: transparent;
  color: #444444;
  border: 2px solid #444444;
  cursor: pointer;
  background: white;

  ${props => props.primary && css`
    background: #444444;
    color: white;
  `}
`

const InputElement = styled.input`
  height: 2em;
  width: 14em;
`

function UserProfile() {
  const activeUser = useActiveUserState();
  const [email, setEmail] = useState(activeUser.email);
  const [username, setUsername] = useState(activeUser.username);
  const [firstName, setFirstName] = useState(activeUser.first_name);
  const [lastName, setLastName] = useState(activeUser.last_name);
  const dispatch = useActiveUserDispatch();
  const history = useHistory();

  const onSave = () => {
    updateUser({id: activeUser.id, email, username, firstName, lastName}).then(response => {
      if (!response.errors) {
        dispatch({ type: 'SET_ACTIVE_USER', user: response})
        localStorage.setItem('activeUser', JSON.stringify(response))
        history.push('/')
      }
    })
  }

  const onLogout = () => {
    localStorage.setItem('token', null)
    localStorage.setItem('activeUser', null)
    dispatch({type: 'REMOVE_ACTIVE_USER' })
    history.push('/')
  }

  return (
    <Container>
      <Header>
        Update Account
      </Header>
      <FieldsContainer>
        <InputRow>
          <InputLabel>Email:</InputLabel>
          <InputElement
            type='text'
            value={email}
            name='email'
            placeholder='Enter Email'
            onChange={(e) => setEmail(e.target.value)}
          />
        </InputRow>
        <InputRow>
          <InputLabel>Username:</InputLabel>
          <InputElement
            type='text'
            value={username}
            name='username'
            placeholder='Enter Username'
            onChange={(e) => setUsername(e.target.value)}
          />
        </InputRow>
        <InputRow>
          <InputLabel>First Name:</InputLabel>
          <InputElement
            type='text'
            value={firstName}
            name='firstName'
            placeholder='Enter First Name'
            onChange={(e) => setFirstName(e.target.value)}
          />
        </InputRow>
        <InputRow>
          <InputLabel>Last Name:</InputLabel>
          <InputElement
            type='text'
            value={lastName}
            name='lastName'
            placeholder='Enter Last Name'
            onChange={(e) => setLastName(e.target.value)}
          />
        </InputRow>
        <ButtonContainer>
          <Button
            onClick={onLogout}
          >
            Logout
          </Button>
          <Button
            primary
            onClick={onSave}
          >
            Update Profile
          </Button>
        </ButtonContainer>
      </FieldsContainer>
    </Container>
  );
}

export default UserProfile;
