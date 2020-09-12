import React, { useState } from 'react';
import styled from 'styled-components';
import { AgGridColumn, AgGridReact } from 'ag-grid-react';
import { get } from 'lodash';
import './table-style.scss';
import 'ag-grid-community/dist/styles/ag-grid.css';
import 'ag-grid-community/dist/styles/ag-theme-alpine.css';

const TableContainer = styled.div`
  display: flex;
  margin-top: 2em;
  width: 90%;
  height: 400px;
`

const columnDefs = [
  { headerName: 'Player', field: 'fullName' },
  { headerName: 'Position', field: 'position' },
  { headerName: 'Team', field: 'team' },
  { headerName: 'Number', field: 'number' },
]

const RosterTable = (props) => {
  const { roster } = props;

  const gridOptions = {
    columnDefs,
    defaultColDef: {
      sortable: true,
      flex: '1',
      cellStyle: {
        textAlign: 'center',
      }
    }
  }

  const rowData = roster.map(player => ({
    fullName: player.full_name,
    position: get(player, ['position', 'abbreviation'], 'Not Listed'),
    team: get(player, ['pro_team', 'name'], 'Not Listed'),
    number: player.jersey_number,
  }));

    return (
      <TableContainer>
        <div className="ag-theme-alpine" style={{height: '100%', width: '100%'}}>
          <AgGridReact
            rowData={rowData}
            gridOptions={gridOptions}
          />
        </div>
      </TableContainer>
    );
};

export default RosterTable;
