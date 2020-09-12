import React, { useEffect, useState } from 'react';
import styled from 'styled-components';
import { useParams } from 'react-router-dom';

import { getTeam, getTeamTransactions } from './api';

const Container = styled.div`
  margin-top: 2em;
`

const Header = styled.div`
  font-size: 1.5em;
  font-weight: 600;
  text-align: center;
`

const ContentContainer = styled.div`
  margin-top: 2em;
  display: flex;
  width: 100%;
  flex-direction: column;
  align-items: center;
`

function Team() {
  const [team, setTeam] = useState({});
  const [transactions, setTransactions] = useState([]);
  const { id } = useParams();
  const team_info = team.team_info || {};
  const roster = team.roster || [];

  const location = team_info.location || '';
  const nickname = team_info.nickname || '';

  useEffect(() => {
    getTeam(id).then(response => {
      setTeam(response)
    });
  }, []);

  useEffect(() => {
    getTeamTransactions(id).then(response => {
      setTransactions(response)
    });
  }, []);

  return (
    <Container>
      <Header>{`${location} ${nickname}`}</Header>
      <ContentContainer>
        {roster.map(player => {
          return (
            <p>
              {player.full_name}
            </p>
          )
        })}
      </ContentContainer>
      <ContentContainer>
        <Header>Transactions</Header>
      </ContentContainer>
    </Container>
  )
}

export default Team;
