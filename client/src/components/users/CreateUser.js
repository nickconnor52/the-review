import React, { useState } from 'react'
import styled, { css } from 'styled-components'
import { createUser } from './api';
import { useHistory } from 'react-router-dom'
import { useActiveUserDispatch } from '../../context/ActiveUserContext'

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
  width: 5em;
  background: transparent;
  color: #444444;
  border: 2px solid #444444;
  cursor: pointer;

  ${props => props.primary && css`
    background: #444444;
    color: white;
  `}
`

const InputElement = styled.input`
  height: 2em;
  width: 14em;
`

function CreateUser() {
  const [email, setEmail] = useState('');
  const [username, setUsername] = useState('');
  const [firstName, setFirstName] = useState('');
  const [lastName, setLastName] = useState('');
  const [password, setPassword] = useState('');
  const dispatch = useActiveUserDispatch();
  const history = useHistory();

  const onCreate = () => {
    createUser({email, username, firstName, lastName, password}).then(response => {
      if (!response.errors) {
        dispatch({ type: 'SET_ACTIVE_USER', user: response.user, token: response.jwt})
        localStorage.setItem('token', response.jwt)
        localStorage.setItem('activeUser', JSON.stringify(response.user))
        history.push('/')
      }
    })
  }

  const handleKeyDown = (e) => {
    if (e.key === 'Enter') {
      onCreate();
    }
  }

  return (
    <Container>
      <Header>
        Create Account
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
        <InputRow>
          <InputLabel>Password:</InputLabel>
          <InputElement
            type='password'
            name='password'
            value={password}
            placeholder='Enter Password'
            onKeyDown={handleKeyDown}
            onChange={(e) => setPassword(e.target.value)}
          />
        </InputRow>
        <ButtonContainer>
          <Button
            primary
            onClick={onCreate}
          >
            Create Account
          </Button>
        </ButtonContainer>
      </FieldsContainer>
    </Container>
  );
}

export default CreateUser;
