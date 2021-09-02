import React, { useEffect, useState } from 'react'
import styled, { css } from 'styled-components';
import { isEmpty, sortBy } from 'lodash';
import { getAllTeams } from '../teams/api';
import { useActiveUserState } from '../../context/ActiveUserContext'
import moment from 'moment';
import { sm, colors } from '../../core/style';
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

const TitleContainer = styled.div`
  display: flex;
  flex-direction: column;
  align-items: center;
  margin-bottom: 1em;
`

const Date = styled.div`
  color: ${colors.midGrey};
  font-weight: 300;
  font-size: 0.8em;
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

const HeaderContainer = styled.div`
  display: flex;
  flex-direction: column;
  width: 100%;
  margin-bottom: 1em;
  ${props => props.hasTeam && css`
    margin-bottom: -2em;
  `}


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
  width: 8em;
  background: transparent;
  color: #444444;
  border: 2px solid #444444;
  cursor: pointer;

  ${props => props.primary && css`
    background: #444444;
    color: white;
  `}
`

const PlayerView = styled.div`
  display: flex;
  width: 80%;
  margin-bottom: 0.5em;
`

const Name = styled.div`
  flex: 2;
  text-align: left;
  font-weight: bold;
`
const Position = styled.div`
  flex: 1;
  text-align: center;
`
const Team = styled.div`
  flex: 2;
  text-align: center;
`

const PositionContainer = styled.div`
  margin-top: 0.5em;
  display: flex;
`

function TransactionPieceDisplay(props) {
  const { full_name: fullName, id, position, pro_team: proTeam = {} } = props;
  const { abbreviation } = position;
  const { name = "Free Agent" } = proTeam;
  return  (
      <PlayerView key={id}>
        <Name>
          {fullName}
        </Name>
        <Position>
          {abbreviation}
        </Position>
        <Team>
          {name}
        </Team>
      </PlayerView>
    );
}

function TeamView(props) {
  const { team_info: teamInfo, trade_block_updated_at: updatedDate, trade_block: tradeBlock, position_need: positionNeed } = props;
  const { location, nickname } = teamInfo;

  return (
    <TradeCard>
      <TitleContainer>
        <TeamName>{`${nickname}`}</TeamName>
        <Date>Last Updated: {moment(updatedDate).format('MMMM Do, YYYY')}</Date>
      </TitleContainer>
      <TeamsContainer>
        <TeamColumn>
          {
            tradeBlock.map(item => (
              <TransactionPieceDisplay key={item.id} {...item} />
            ))
          }
        </TeamColumn>
      </TeamsContainer>
      <PositionContainer>
        <div style={{fontWeight: 'bold', marginRight: '1em'}}>
          Team Need:
        </div>
        <div>
          {positionNeed ? positionNeed.name : 'No Preference'}
        </div>
      </PositionContainer>
    </TradeCard>
  )
}

function TradeBlock() {
  const [teams, setTeams] = useState([]);
  const activeUser = useActiveUserState();
  const history = useHistory();
  const userHasTeam = activeUser.team;
  useEffect(() => {
    getAllTeams().then(response => {
      const teamResponse = sortBy(response, 'trade_block_updated_at').reverse();
      setTeams(teamResponse);
    })
  }, [])

  const handleTradeBlockEdit = () => {
    history.push('/trades/tradeBlock/edit')
  }

  const tradeBlockTeams = teams.filter(t => !isEmpty(t.trade_block));

  return (
    <PageContainer>
      <BodyContainer>
        <HeaderContainer hasTeam={userHasTeam}>
          <TeamHeader>Trade Center</TeamHeader>
          {
            userHasTeam ?
              (
                <ButtonContainer>
                  <Button
                    primary
                    onClick={handleTradeBlockEdit}
                  >
                    Edit Trade Block
                  </Button>
                </ButtonContainer>
              ) :
              (
                null
              )
          }
        </HeaderContainer>
        {
          !isEmpty(tradeBlockTeams) ?
            (
              tradeBlockTeams.map(team => (
                <TeamView key={team.id} {...team} />
              ))
            ) :
            (
              <div style={{fontStyle: 'italic'}}>
                Either there's a bug or everyone is too stingy and there
                are no players on the Trade Block at this time.
              </div>
            )
        }
      </BodyContainer>
    </PageContainer>
  );
}

export default TradeBlock;
