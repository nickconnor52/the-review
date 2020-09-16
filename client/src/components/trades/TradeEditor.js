import React, { useEffect, useState } from 'react';
import styled, { css } from 'styled-components';
import { useHistory, useParams } from 'react-router-dom'
import { isUndefined } from 'lodash'

import { createTrade, getTrade, updateTrade, deleteTrade } from './api';

import ReactMde from 'react-mde';
import ReactMarkdown from 'react-markdown';
import 'react-mde/lib/styles/css/react-mde-all.css';

const EditContainer = styled.div`
  margin-top: 2em;
  display: flex;
  justify-content: center;
  align-items: center;
  flex-direction: column;
`

const Label = styled.span`
  margin-right: 1em;
  font-weight: bold;
`

const TitleInput = styled.input`
  margin-bottom: 1em;
`

const ButtonContainer = styled.div`
  display: flex;
  width: 60%;
  justify-content: center;
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

const inlineStyle = {
  width: '60%',
};

const SummaryContainer = styled.div`
  display: flex;
  flex-direction: row;
  align-items: center;
  margin-bottom: 1em;
  max-width: 90%
`

function TradeEditor() {
  const { id } = useParams();
  const isNew = isUndefined(id);
  const [content, setContent] = useState("");
  const [title, setTitle] = useState("");
  const [summary, setSummary] = useState("");
  const [selectedTab, setSelectedTab] = useState("write");
  const history = useHistory();

  const onDelete = () => {
    if (window.confirm('You serious Clark??')) {
      deleteTrade({id}).then(() => {
        history.push(`/trades`)
      })
    }
  }

  const onSave = () => {
    if (isNew) {
      createTrade({ title, content, summary }).then((trade) => {
        history.push(`/trades/${trade.id}`)
      });
    } else {
      updateTrade({ title, content, summary, id}).then((trade) => {
        history.push(`/trades/${id}`)
      })
    }
  }

  useEffect(() => {
    if (!isNew) {
      getTrade(id).then(trade => {
        setContent(trade.content)
        setTitle(trade.title)
        setSummary(trade.summary)
      })
    }
  }, [isNew, id]);

  return (
    <EditContainer>
      <div>
        <Label>Work in Progress :(</Label>
      </div>
      <ButtonContainer>
        <Button
          disabled
          onClick={() => {}}
        >
          Delete
        </Button>
        <Button
          primary
          onClick={() => {}}
        >
          Save
        </Button>
      </ButtonContainer>
    </EditContainer>
  );
}

export default TradeEditor;
