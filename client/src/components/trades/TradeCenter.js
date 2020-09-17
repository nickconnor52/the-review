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
  text-align: center;
`

const Value = styled.div`
  text-align: center;
`

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
  text-align: center;
  font-weight: bold;
  font-size: 1.25em;
  margin-bottom: 1rem;
`

const PlayerView = styled.div`
  margin-bottom: 0.5em;
`

const DraftPick = styled.div`

`

const PickPlayer = styled.div`
  color: grey;
  font-size: 0.8em;
  text-align: center;
`



function TransactionPieceDisplay(props) {
  const { display_name: displayName, player_id: playerId, id, draft_pick: draftPick } = props;
  const roundNumber = () => {
    switch (draftPick.round_number) {
      case '1':
        return '1st'
      case '2':
        return '2nd'
      case '3':
        return '3rd'
      default:
        return 'Unknown Round'
    }
  };

  return playerId ?
    (
      <PlayerView key={id}>
        {displayName}
      </PlayerView>
    ) :
    (
      <div style={{marginBottom: '0.5em'}}>
        <DraftPick>{roundNumber()} Round Pick</DraftPick>
        {
          draftPick.player_id ?
            (
            <div>
              <PickPlayer key={draftPick.id} >Pick {draftPick.round_pick_number}:</PickPlayer>
              <PickPlayer key={`${draftPick.id}-${displayName}`}>{displayName}</PickPlayer>
            </div>
            ) :
            (
              null
            )
        }
      </div>
    );
}

function TradeView(props) {
  const { accepted_date: acceptedDate, teams, transaction_pieces: transactionPieces } = props;
  const teamA = get(teams, [0, 'team_info'], {});
  const teamB = get(teams, [1, 'team_info'], {});
  const teamAPieces = transactionPieces.filter(t => (t.to_team_id === teamA.team_id));
  const teamBPieces = transactionPieces.filter(t => (t.to_team_id === teamB.team_id));
  return (
    <TradeCard>
      <Subtitle>
        <Label>Accepted</Label>
        <Value>{moment(acceptedDate).format('MMMM Do, YYYY')}</Value>
      </Subtitle>
      <TeamsContainer>
        <TeamColumn>
          <TeamName>{`${teamA.location} ${teamA.nickname}`}</TeamName>
          <div style={{fontStyle: 'italic', marginBottom: '1em' }}>Received</div>
          {
            teamAPieces.map(piece => (
              <TransactionPieceDisplay key={piece.id} {...piece} />
            ))
          }
        </TeamColumn>
        <TeamColumn>
          <TeamName>{`${teamB.location} ${teamB.nickname}`}</TeamName>
          <div style={{fontStyle: 'italic', marginBottom: '1em' }}>Received</div>
          {
            teamBPieces.map(piece => (
              <TransactionPieceDisplay key={piece.id} {...piece} />
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
            <TradeView key={trade.id} {...trade} />
          ))
        }
      </BodyContainer>
    </PageContainer>
  );
}

export default TradeCenter;
