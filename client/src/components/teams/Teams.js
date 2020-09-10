import React, { useEffect, useState } from 'react';
import styled from 'styled-components';

import { getAllTeams } from './api';

import { colors } from '../../core/style';
import { Link } from 'react-router-dom';

const Container = styled.div`
  margin-top: 2em;
`

const Header = styled.div`
  font-size: 1.5em;
  font-weight: 600;
  text-align: center;
`

const TeamsContainer = styled.div`
  margin-top: 2em;
  display: flex;
  width: 100%;
  flex-direction: column;
  align-items: center;
`

const TeamLink = styled.div`
  padding-bottom: 2em;
  a {
    color: ${colors.strawberry};
    text-decoration: none
  }
`

function Teams() {
  const [teams, setTeams] = useState([]);
  useEffect(() => {
    getAllTeams().then(response => {
      setTeams(response)
    });
  }, []);

  return (
    <Container>
      <Header>Teams</Header>
        {teams.map(team => {
          const { id, team_info } = team;
          const { location, nickname } = team_info;
          return (
            <TeamsContainer key={nickname}>
              <TeamLink>
                <Link to={`/teams/${id}`}>{`${location} ${nickname}`}</Link>
              </TeamLink>
            </TeamsContainer>
          )
        })}
    </Container>
  );
}

export default Teams
