import React, { useEffect, useState } from 'react';
import styled, { css } from 'styled-components';
import { useHistory } from 'react-router-dom'
import { get, isEmpty } from 'lodash'
import { useActiveUserState } from '../../context/ActiveUserContext'
import DataTable from '../../core/DataTable'

import { getTeam, updateTradeBlock } from '../teams/api';

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

const TableContainer = styled.div`
  display: flex;
  margin-top: 2em;
  width: 90%;
  height: 400px;
`

function TradeBlockEditor() {
  const history = useHistory();
  const activeUser = useActiveUserState();
  const teamId = get(activeUser, ['team', 'id'], '');
  const [gridApi, setGridApi] = useState({});
  const [roster, setRoster] = useState([]);
  const [selectedPlayerIds, setSelectedPlayerIds] = useState(roster.filter(p => p.on_trade_block));

  useEffect(() => {
    if (teamId && !isEmpty(gridApi)) {
      getTeam(teamId).then(response => {
        const playerIds = response.roster.filter(p => p.on_trade_block).map(p => p.id);
        setSelectedPlayerIds(playerIds)
        setRoster(response.roster);
        gridApi.forEachNode((node) => {
          if (playerIds.includes(node.data.id)) {
            node.setSelected(true)
          }
        })
      });
    }
  }, [teamId, gridApi]);

  const onSave = () => {
    updateTradeBlock({ teamId, selectedPlayerIds }).then((response) => {
      history.push(`/trades/tradeBlock`)
    });
  }

  const onGridReady = (api) => {
    setGridApi(api);
  };

  const onRowSelect = (selectedPlayerNodes) => {
    const playerIds = selectedPlayerNodes.map(p => p.data.id)
    setSelectedPlayerIds(playerIds);
  }

  const rowData = roster.map(player => ({
    id: player.id,
    fullName: player.full_name,
    position: get(player, ['position', 'abbreviation'], 'Not Listed'),
    team: get(player, ['pro_team', 'name'], 'Not Listed'),
  }));

  const columnDefs = [
    { headerName: 'Player', field: 'fullName', checkboxSelection: true },
    { headerName: 'Position', field: 'position' },
    { headerName: 'Team', field: 'team' },
  ]

  const gridOptions = {
    rowSelection: 'multiple',
  }

  return (
    <EditContainer>
      <InputContainer>
        <Label>Trade Block</Label>
        <TradeContainer>
          <TableContainer>
            <DataTable
              rowData={rowData}
              columnDefs={columnDefs}
              extraGridOptions={gridOptions}
              onRowSelect={onRowSelect}
              onGridReady={onGridReady}
            />
          </TableContainer>
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

export default TradeBlockEditor;
