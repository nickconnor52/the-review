import React, { useEffect, useState } from 'react';
import styled from 'styled-components';

import { getAllTransactions } from './api';

const Container = styled.div`
  margin-top: 2em;
`

const Header = styled.div`
  font-size: 1.5em;
  font-weight: 600;
  text-align: center;
`

const TransactionsContainer = styled.div`
  margin-top: 2em;
  display: flex;
  width: 100%;
  flex-direction: column;
  align-items: center;
`

function Transactions() {
  const [transactions, setTransactions] = useState([]);
  useEffect(() => {
    getAllTransactions().then(response => {
      setTransactions(response)
    });
  }, []);

  return (
    <Container>
      <Header>Transactions</Header>
        {transactions.map(transaction => {
          const { id } = transaction;
          return (
            <TransactionsContainer key={id}>
              <p>
                {id}
              </p>
            </TransactionsContainer>
          )
        })}
    </Container>
  );
}

export default Transactions
