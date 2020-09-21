import React, { useEffect, useState } from 'react';
import DataTable from '../../core/DataTable';
import styled from 'styled-components';
import { useParams } from 'react-router-dom';
import moment from 'moment';
import { get } from 'lodash';
import { sm } from '../../core/style';

import { getTeam, getTeamTransactions, getRoster } from './api';

const PageContainer = styled.div`
  margin-top: 2em;
  display: flex;
  justify-content: center;
`

const BodyContainer = styled.div`
  display: flex;
  background-color: white;
  border-radius: 10px;
  box-shadow: 0px 0px 16px rgba(0,0,0,0.15);
  padding: 2em;
  flex-direction: column;
  width: 75%;
`

const TeamHeader = styled.div`
  font-size: 2em;
  font-weight: 600;
  text-align: center;
`

const Header = styled.div`
  font-size: 1.5em;
  font-weight: 600;
  text-align: center;
`

const HeaderBar = styled.div`
  display: flex;
  align-items: center;
  width: 90%;
  justify-content: center;
  flex-direction: column;
`

const YearDropdown = styled.div`
  display: flex;
  margin-left: auto;
`

const ContentContainer = styled.div`
  margin-top: 2em;
  display: flex;
  width: 100%;
  flex-direction: column;
  align-items: center;
`

const TeamInfoContainer = styled.div`
  display: flex;
  margin-top: 2em;
  margin-bottom: 2em;

  @media(max-width: ${sm}) {
    flex-direction: column;
  }
`

const LogoContainer = styled.div`
  flex: 1;
`

const TeamLogo = styled.img`
  max-width: 15em;
  width: 15em;
  box-shadow: 0px 0px 16px rgba(0,0,0,0.15);
  border-radius: 10px;
`

const InfoContainer = styled.div`
  display: flex;
  justify-content: center;
  flex: 2;
`

const TeamInfo = styled.div`
  display: flex;
  align-items: flex-start;
  flex-direction: column;

  @media(max-width: ${sm}) {
    margin-top: 2em;
  }
`

const InfoItem = styled.div`
  display: flex;
  justify-content: center;
  margin-bottom: 1em;
`

const Label = styled.div`
  font-weight: bold;
  width: 10em;
`
const Value = styled.div``

const ValueList = styled.div`
  display: flex;
  flex-direction: column;
  margin-left: auto;
`

const ListItem = styled.div`
  margin-bottom: 0.5em;
`

const TableContainer = styled.div`
  display: flex;
  margin-top: 2em;
  width: 90%;
  height: 400px;
`

function Team() {
  const [team, setTeam] = useState({});
  const [transactions, setTransactions] = useState([]);
  const { id } = useParams();
  const team_info = team.team_info || {};
  const past_info = team.past_team_info || [];

  const [roster, setRoster] = useState([]);
  const [rosterYear, setRosterYear] = useState(moment().year());

  const current_owner = team.current_owner || {};

  const location = team_info.location || '';
  const nickname = team_info.nickname || '';
  const logo_url = team_info.logo_url || '';
  const owner_name = `${current_owner.first_name || ''} ${current_owner.last_name || ''}`
  const owner_location = current_owner.city || '';
  const acquire_date = current_owner.season_joined || '';
  const trade_count = team.trade_count || '0';
  const original_players = team.original_players || [];

  useEffect(() => {
    getTeam(id).then(response => {
      setTeam(response)
    });
  }, [id]);

  useEffect(() => {
    getTeamTransactions(id).then(response => {
      setTransactions(response)
    });
  }, [id]);

  useEffect(() => {
    getRoster(id, rosterYear).then(response => {
      setRoster(response)
    });
  }, [rosterYear, id]);

  const rowData = roster.map(player => ({
    fullName: player.full_name,
    position: get(player, ['position', 'abbreviation'], 'Not Listed'),
    team: get(player, ['pro_team', 'name'], 'Not Listed'),
    number: player.jersey_number,
  }));

  const columnDefs = [
    { headerName: 'Player', field: 'fullName' },
    { headerName: 'Position', field: 'position' },
    { headerName: 'Team', field: 'team' },
    { headerName: 'Number', field: 'number' },
  ]

  return (
    <PageContainer>
      <BodyContainer>
        <TeamHeader>{`${location} ${nickname}`}</TeamHeader>
        <TeamInfoContainer>
          <LogoContainer>
            <TeamLogo src={logo_url} alt='Team Logo' />
          </LogoContainer>
          <InfoContainer>
            <TeamInfo>
              <InfoItem>
                <Label>Owner:</Label>
                <Value>{owner_name}</Value>
              </InfoItem>
              <InfoItem>
                <Label>Location:</Label>
                <Value>{owner_location}</Value>
              </InfoItem>
              <InfoItem>
                <Label>Acquired Team:</Label>
                <Value>{acquire_date}</Value>
              </InfoItem>
              <InfoItem>
                <Label>Total Trades:</Label>
                <Value>{trade_count}</Value>
              </InfoItem>
              <InfoItem>
                <Label>The Real OG Squad Squad:</Label>
                {
                original_players.length !== 0 ?
                (
                  <ValueList>
                    {
                      original_players.map(player => (
                        <ListItem key={`${player}`}>
                          {player}
                        </ListItem>
                      ))
                    }
                  </ValueList>
                ) :
                (
                  <Value>No Day Ones</Value>
                )
              }
              </InfoItem>
              <InfoItem>
                <Label>Established:</Label>
                <Value>2016</Value>
              </InfoItem>
              {
                past_info.length !== 0 ?
                (
                  <InfoItem>
                    <Label>Former Names:</Label>
                    <ValueList>
                      {
                        past_info.map(info => (
                          <ListItem key={`${info.location}-${info.location}`}>
                            {`${info.location} ${info.nickname}`}
                          </ListItem>
                        ))
                      }
                    </ValueList>
                  </InfoItem>
                ) :
                (
                  null
                )
              }
            </TeamInfo>
          </InfoContainer>
        </TeamInfoContainer>
        <hr style={{width: '100%'}} />
        <ContentContainer>
          <HeaderBar>
            <Header style={{ marginLeft: 'auto', marginRight: 'auto' }}>Current Lineup</Header>
            <YearDropdown>
              <select onChange={(e) => setRosterYear(e.target.value)} id="rosterPicker">
                <option key='2020' value="2020">2020</option>
                <option key='2019'value="2019">2019</option>
                <option key='2018'value="2018">2018</option>
                <option key='2017'value="2017">2017</option>
                <option key='2016'value="2016">2016</option>
              </select>
            </YearDropdown>
          </HeaderBar>
          <TableContainer>
            <DataTable rowData={rowData} columnDefs={columnDefs} />
          </TableContainer>
        </ContentContainer>
      </BodyContainer>
    </PageContainer>
  )
}

export default Team;
