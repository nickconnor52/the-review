import React, { useEffect, useState } from 'react';
import styled, { css } from 'styled-components';
import { useHistory } from 'react-router-dom'
import Chips from 'react-chips';

import { createTrade } from './api';
import { getAllTeams } from '../teams/api';

const EditContainer = styled.div`
  margin-top: 2em;
  display: flex;
  justify-content: center;
  align-items: center;
  flex-direction: column;
  width: 100%;
`

const Label = styled.div`
  margin-right: 1em;
  font-weight: bold;
  margin-bottom: 1em;
`

const ButtonContainer = styled.div`
  display: flex;
  width: 60%;
  justify-content: center;
`

const InputContainer = styled.div`
  display: flex;
  width: 60%;
  flex-direction: column;
  align-items: center;
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

const TradeContainer = styled.div`
  display: flex;
  width: 100%;
  flex-direction: column;
  align-items: center;
`

const TeamContainer = styled.div`
  display: flex;
  width: 60%;
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

function TradeEditor() {
  const history = useHistory();
  const [teamAId, setTeamAId] = useState('');
  const [teamBId, setTeamBId] = useState('');
  const [teamAPlayerNames, setTeamAPlayerNames] = useState([]);
  const [teamBPlayerNames, setTeamBPlayerNames] = useState([]);
  const [date, setDate] = useState('');
  const [teams, setTeams] = useState([]);

  useEffect(() => {
    getAllTeams().then(response => {
      setTeams(response)
    });
  }, []);

  const onSave = () => {
    createTrade({ teamAId, teamBId, teamAPlayerNames, teamBPlayerNames, date }).then(() => {
      history.push(`/trades`)
    });
  }

  return (
    <EditContainer>
      <InputContainer>
        <Label>New Trade</Label>
        <TradeContainer>
          <InputRow>
            <InputLabel>Date:</InputLabel>
            <input
              type='text'
              name={date}
              placeholder={'MM/DD/YY'}
              onChange={(e) => setDate(e.target.value)}
            />
          </InputRow>
          <TeamContainer>
            <div style={{marginBottom: '1em', fontWeight: 'bold'}}>Team A</div>
            <InputRow>
              <InputLabel>Title:</InputLabel>
              <select onChange={(e) => setTeamAId(e.target.value)} id="teamAID">
                {
                  teams.map(team => (
                    <option key={`${team.id}-A`} value={team.id}>{team.current_owner.first_name}</option>
                  ))
                }
              </select>
            </InputRow>
            <InputRow>
                <InputLabel>Player Full Names</InputLabel>
                <Chips
                  key='teamAPlayers'
                  onChange={(names) => setTeamAPlayerNames(names)}
                  value={teamAPlayerNames}
                  createChipKeys={["Enter", ","]}
                />
            </InputRow>
          </TeamContainer>
          <TeamContainer>
            <div style={{marginBottom: '1em', fontWeight: 'bold'}}>Team B</div>
            <InputRow>
              <InputLabel>Title:</InputLabel>
              <select onChange={(e) => setTeamBId(e.target.value)} id="teamBID">
                {
                  teams.map(team => (
                    <option key={`${team.id}-B`} value={team.id}>{team.current_owner.first_name}</option>
                  ))
                }
              </select>
            </InputRow>
            <InputRow>
                <InputLabel>Player Full Names</InputLabel>
                <Chips
                  key='teamBPlayers'
                  onChange={(names) => setTeamBPlayerNames(names)}
                  value={teamBPlayerNames}
                  createChipKeys={["Enter", ","]}
                />
            </InputRow>
          </TeamContainer>
        </TradeContainer>
      </InputContainer>
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

export default TradeEditor;
