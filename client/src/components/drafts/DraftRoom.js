import React, { useEffect, useState } from 'react';
import styled from 'styled-components';
import DataTable from '../../core/DataTable';
import { get, sortBy } from 'lodash';
import { getDraftByYear } from './api';

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

const HeaderBar = styled.div`
  display: flex;
  align-items: center;
  width: 90%;
  justify-content: center;
  flex-direction: column;
`

const TableContainer = styled.div`
  display: flex;
  margin-top: 2em;
  width: 90%;
  height: 800px;
`


function DraftRoom() {
  const [draftPicks, setDraftPicks] = useState([]);
  const [year, setDraftYear] = useState('2020');

  useEffect(() => {
    getDraftByYear(year).then(response => {
      const picks = response.draft_picks || []
      setDraftPicks(picks);
    })
  }, [year])

  const columnDefs = [
    { headerName: 'Overall Pick Number', field: 'pickNumber' },
    { headerName: 'Player', field: 'player' },
    { headerName: 'Position', field: 'position' },
    { headerName: 'Team', field: 'team' },
    { headerName: 'Round Number', field: 'roundNumber' },
    { headerName: 'Round Order', field: 'roundPick' },
  ];

  const getTeamInfo = (pick) => {
    const location = get(pick, ['team_info', 'location'], 'Not Listed');
    const nickname = get(pick, ['team_info', 'nickname'], 'Not Listed');

    return `${location} ${nickname}`
  }

  const rowData = draftPicks.map(pick => ({
    pickNumber: pick.overall_pick_number,
    player: get(pick, ['player', 'full_name'], 'Not Listed'),
    position: get(pick, ['player', 'position', 'abbreviation'], 'Not Listed'),
    team: getTeamInfo(pick),
    roundNumber: pick.round_number,
    roundPick: pick.round_pick_number,
  }))

  return (
    <PageContainer>
      <BodyContainer>
        <TeamHeader>Draft Room</TeamHeader>
        <ContentContainer>
            <HeaderBar>
              <YearDropdown>
                <select onChange={(e) => setDraftYear(e.target.value)} id="rosterPicker">
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
  );
}

export default DraftRoom;
