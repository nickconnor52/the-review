import React, { useEffect, useState } from 'react';
import styled from 'styled-components';

import { getAllTeams } from './api';

import { colors, sm } from '../../core/style';
import { Link } from 'react-router-dom';

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

const TeamContainer = styled.div`
  margin-top: 2em;
  display: flex;
  width: 100%;
  flex-direction: column;
  align-items: center;
`

const TeamCard = styled.div`
  background-color: white;
  width: 45%;
  box-shadow: 0 0 16px rgba(0,0,0,0.15);
  border-radius: 10px;
  display: flex;
  align-items: center;
  padding: 1em;

  @media(max-width: ${sm}) {
    width: 60%;
  }
`

const LogoContainer = styled.div`
  flex: 1;
`

const TeamLogo = styled.img`
  max-width: 5em;
  width: 5em;
  height: 5em;
  max-height: 5em;
  border-radius: 10px;
  box-shadow: 0px 0px 16px rgba(0,0,0,0.15);
`

const TeamLink = styled.div`
  flex: 1;
  display: flex;
  align-items: center;
  text-align: center;

  a {
    color: ${colors.strawberry};
    text-decoration: none;
    font-size: 1.5em;
    font-weight: bold;

    @media(max-width: ${sm}) {
      font-size: 1em;
    }
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
          const { location, nickname, logo_url } = team_info;
          return (
            <TeamContainer key={nickname}>
              <TeamCard>
                <LogoContainer>
                  <TeamLogo src={logo_url}/>
                </LogoContainer>
                <TeamLink>
                  <Link to={`/teams/${id}`}>{`${location} ${nickname}`}</Link>
                </TeamLink>
            </TeamCard>
            </TeamContainer>
          )
        })}
    </Container>
  );
}

export default Teams
