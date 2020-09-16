import React, { useEffect, useState } from 'react'
import styled from 'styled-components';
import {  get, sortBy } from 'lodash';
import { getAllTrades } from './api';
import moment from 'moment';
import { sm } from '../../core/style';

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
  align-items: center;
`

const TeamHeader = styled.div`
  font-size: 2em;
  font-weight: 600;
  text-align: center;
  margin-bottom: 2rem;
`

const Subtitle = styled.div`
  display: flex;
  margin-bottom: 1em;
`

const Label = styled.div`
  font-weight: bold;
  margin-right: 1em;
`

const Value = styled.div``

const TradeCard = styled.div`
  display: flex;
  justify-content: center;
  align-items: center;
  margin-bottom: 2em;
  width: 60%;
  border-radius: 10px;
  box-shadow: 0px 0px 16px rgba(0,0,0,0.15);
  padding: 1.5rem;
  flex-direction: column;

  @media(max-width: ${sm}) {
    width: 90%;
  }
`

const TeamsContainer = styled.div`
  display: flex;
  justify-content: space-between;
  width: 100%;
`

const TeamColumn = styled.div`
  display: flex;
  flex-direction: column;
  align-items: center;
  width: 100%;
`

const TeamName = styled.div`
  font-weight: bold;
  font-size: 1.25em;
  margin-bottom: 1rem;
`

const PlayerView = styled.div``

function TradeView(props) {
  const { accepted_date: acceptedDate, teams, transaction_pieces: transactionPieces } = props;
  const teamA = get(teams, [0, 'team_info'], {});
  const teamB = get(teams, [1, 'team_info'], {});
  const teamAPieces = transactionPieces.filter(t => (t.to_team_id === teamA.team_id));
  const teamBPieces = transactionPieces.filter(t => (t.to_team_id === teamB.team_id));
  return (
    <TradeCard>
      <Subtitle>
        <Label>Accepted On: </Label>
        <Value>{moment(acceptedDate).format('MMMM Do, YYYY')}</Value>
      </Subtitle>
      <TeamsContainer>
        <TeamColumn>
          <TeamName>{`${teamA.location} ${teamA.nickname}`}</TeamName>
          <div style={{fontStyle: 'italic', marginBottom: '1em' }}>Received</div>
          {
            teamAPieces.map(piece => (
              <PlayerView key={piece.id}>
                {piece.player.full_name}
              </PlayerView>
            ))
          }
        </TeamColumn>
        <TeamColumn>
          <TeamName>{`${teamB.location} ${teamB.nickname}`}</TeamName>
          <div style={{fontStyle: 'italic', marginBottom: '1em' }}>Received</div>
          {
            teamBPieces.map(piece => (
              <PlayerView key={piece.id}>
                {piece.player.full_name}
              </PlayerView>
            ))
          }
        </TeamColumn>
      </TeamsContainer>
    </TradeCard>
  )
}

function TradeCenter() {
  const [trades, setTrades] = useState([]);
  useEffect(() => {
    getAllTrades().then(response => {
      setTrades(sortBy(response, 'accepted_date').reverse());
    })
  }, [])


  return (
    <PageContainer>
      <BodyContainer>
        <TeamHeader>Trade Center</TeamHeader>
        {
          trades.map(trade => (
            <TradeView {...trade} />
          ))
        }
      </BodyContainer>
    </PageContainer>
  );
}

export default TradeCenter;
