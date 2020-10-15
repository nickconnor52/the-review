import React, { useEffect, useState } from 'react'
import styled, { css } from 'styled-components';
import { get, sortBy } from 'lodash';
import { getAllTrades } from './api';
import moment from 'moment';
import { sm } from '../../core/style';
import { useHistory } from 'react-router-dom';

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
  text-align: center;
`

const PickPlayer = styled.div`
  color: grey;
  font-size: 0.8em;
  text-align: center;
`

const HeaderContainer = styled.div`
  display: flex;
  flex-direction: column;
  width: 100%;
  margin-bottom: -2em;

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
  width: 7em;
  background: transparent;
  color: #444444;
  border: 2px solid #444444;
  cursor: pointer;

  ${props => props.primary && css`
    background: #444444;
    color: white;
  `}
`

const NoteContainer = styled.div`
  font-size: 12px;
  text-align: center;
  padding: 0.5em 5em;

  @media(max-width: ${sm}) {
    padding: 0.5em 0;
  }
`

function TransactionPieceDisplay(props) {
  const { display_name: displayName, player_id: playerId, id, draft_pick: draftPick, draft_year: draftYear } = props;
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
        <DraftPick>{draftYear} {roundNumber()} Round Pick</DraftPick>
        {
          <div>
            <PickPlayer key={draftPick.id} >Pick {draftPick.round_pick_number}:</PickPlayer>
            <PickPlayer key={`${draftPick.id}-${displayName}`}>{displayName}</PickPlayer>
          </div>
        }
      </div>
    );
}

function TradeView(props) {
  const { accepted_date: acceptedDate, teams, transaction_pieces: transactionPieces, note } = props;
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
      {
        !!note ?
          (
            <NoteContainer>
              <b>Note:</b> {note}
            </NoteContainer>

          ) :
          (
            null
          )
      }
    </TradeCard>
  )
}

function TradeCenter() {
  const [trades, setTrades] = useState([]);
  const history = useHistory();
  useEffect(() => {
    getAllTrades().then(response => {
      setTrades(sortBy(response, 'accepted_date').reverse());
    })
  }, [])

  const handleTradeBlock = () => {
    history.push('/trades/tradeBlock')
  }

  return (
    <PageContainer>
      <BodyContainer>
        <HeaderContainer>
          <TeamHeader>Trade Center</TeamHeader>
          <ButtonContainer>
            <Button
              primary
              onClick={handleTradeBlock}
            >
              Trade Block
            </Button>
          </ButtonContainer>
        </HeaderContainer>
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
