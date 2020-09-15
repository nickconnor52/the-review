import React, { useEffect, useState } from 'react'
import styled from 'styled-components';
import { getAllTrades } from './api';

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

function TradeCenter() {
  const [trades, setTrades] = useState([]);
  useEffect(() => {
    getAllTrades().then(response => {
      console.log(response)
      setTrades(response);
    })
  }, [])


  return (
    <PageContainer>
      <BodyContainer>
        <TeamHeader>Trade Center</TeamHeader>
      </BodyContainer>
    </PageContainer>
  );
}

export default TradeCenter;
