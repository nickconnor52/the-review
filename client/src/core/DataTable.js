import React from 'react';
import { AgGridReact } from 'ag-grid-react';
import './table-style.scss';
import 'ag-grid-community/dist/styles/ag-grid.css';
import 'ag-grid-community/dist/styles/ag-theme-alpine.css';

const DataTable = (props) => {
  const { rowData, columnDefs } = props;

  const gridOptions = {
    columnDefs,
    defaultColDef: {
      sortable: true,
      flex: '1',
      cellStyle: {
        textAlign: 'center',
      },
      minWidth: 150,
      resizable: true,
    }
  }

    return (
      <div className="ag-theme-alpine" style={{height: '100%', width: '100%'}}>
        <AgGridReact
          rowData={rowData}
          gridOptions={gridOptions}
        />
      </div>
    );
};

export default DataTable;
