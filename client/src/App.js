import React from 'react';
import {
  BrowserRouter as Router,
  Switch,
  Route,
} from 'react-router-dom';
import styled from 'styled-components';
import { colors, sm } from './core/style';

import NavigationBar from './components/NavigationBar';
import Teams from './components/teams/Teams';
import Team from './components/teams/Team';
import Transactions from './components/transactions/Transactions';
import TradeCenter from './components/trades/TradeCenter';
import PostsDirectory from './components/posts/PostsDirectory';
import Post from './components/posts/Post';
import PostEditor from './components/posts/PostEditor';

import Markdown from 'react-markdown';
import 'github-markdown-css';
import axios from 'axios';

if (process.env.NODE_ENV === 'production') {
  console.log(process.env.REACT_APP_API_BASE_URL)
  axios.defaults.baseURL = process.env.REACT_APP_API_BASE_URL || ''
}

const PageBody = styled.div`
  background-color: ${colors.lightGrey};
  min-height: 100%;
  padding-bottom: 2em;
`

const Footer = styled.div`
  background-color: ${colors.lightGrey};
  height: 5em;
`

const FooterText = styled.div`
  display: flex;
  height: 80%;
  margin-left: 4em;
  font-size: 0.5em;
  align-items: center;
`

const Break = styled.hr`
  border: 0;
  margin-top: 0;
  height: 1px;
  background-image: -webkit-linear-gradient(left, #f0f0f0, #8c8b8b, #f0f0f0);
  background-image: -moz-linear-gradient(left, #f0f0f0, #8c8b8b, #f0f0f0);
  background-image: -ms-linear-gradient(left, #f0f0f0, #8c8b8b, #f0f0f0);
  background-image: -o-linear-gradient(left, #f0f0f0, #8c8b8b, #f0f0f0);
`

export default function App() {
  return (
    <Router>
      <PageBody>
        <NavigationBar />
        {/* A <Switch> looks through its children <Route>s and
            renders the first one that matches the current URL. */}
          <Switch>
            <Route path='/teams/:id'>
              <Team />
            </Route>
            <Route path='/teams'>
              <Teams />
            </Route>
            <Route path='/posts/edit'>
              <PostEditor />
            </Route>
            <Route path='/posts/:id/edit'>
              <PostEditor />
            </Route>
            <Route path='/posts/:id'>
              <Post />
            </Route>
            <Route path='/posts'>
              <PostsDirectory />
            </Route>
            <Route path='/transactions'>
              <Transactions />
            </Route>
            <Route path='/trades'>
              <TradeCenter />
            </Route>
            <Route path='/'>
              <Home />
            </Route>
          </Switch>
      </PageBody>
      <Footer>
        <Break />
        <FooterText>
          The League Review 2020
        </FooterText>
      </Footer>
    </Router>
  );
}

const HomeContainer = styled.div`
  display: flex;
  flex-direction: column;
  align-items: center;
  margin-top: 2em;
`

const Title = styled.div`
  font-size: 1.5em;
  font-weight: 600;
  text-align: center;
`

const Body = styled.div`
  width: 60%;
  margin-top: 1em;
`

const TableContainer = styled.div`
  display: flex;
  justify-content: center;
  flex-direction: column;
  margin-top: 2em;
  align-items: center;

  table {
    padding-top: 1em;
    text-align: center;
    width: auto !important;
    margin-left: auto;
    margin-right: auto;
  }
`

const RankingsContainer = styled.div`
  display: flex;
  flex-direction: row;
  justify-content: space-evenly;

  @media(max-width: ${sm}) {
    flex-direction: column
  }
`

const draftRanking = `
| ** Team ** | ** Power Index ** |
| ---------- | ----------------- |
| ** Mark ** | 100 |
| ** Dan ** | 100 |
| ** Nick ** | 96 |
| ** Josiah ** | 91 |
| ** Matt ** | 86 |
| ** Luke ** | 82 |
| ** Gary ** | 78 |
| ** Derek ** | 70 |
| ** Josias ** | 68 |
| ** Spencer ** | 52 |
`

const dynastyRanking = `
| ** Team ** | ** Power Index ** |
| ---------- | ----------------- |
| ** Nick ** | 100 |
| ** Mark ** | 92 |
| ** Matt ** | 86 |
| ** Luke ** | 85 |
| ** Dan ** | 82 |
| ** Josiah ** | 81 |
| ** Gary ** | 77 |
| ** Derek ** | 73 |
| ** Josias ** | 70 |
| ** Spencer ** | 57 |
`

const playoffChances = `
| ** Team ** | ** Odds ** |
| ---------- | ----------------- |
| ** Nick ** | 89% |
| ** Dan ** | 75% |
| ** Mark ** | 73% |
| ** Josiah ** | 64% |
| ** Matt ** | 41% |
| ** Gary ** | 34% |
| ** Luke ** | 16% |
| ** Derek ** | 8% |
| ** Josias ** | 1% |
| ** Spencer ** | 0% |
`

const SubTitle = styled.div`
font-style: italic;
font-size: 0.8em;
`

function Home() {
  const updated = '9/16/20'
  return (
    <HomeContainer>
      <Title>
        Welcome to The League Review
      </Title>
      <Body>
        It's gonna look pretty bare in here for a while, but I'm working on it. At a bare minimum, check back each week to read
        my latest ramblings about your team, my team, and everything in between. I'll keep y'all posted as things move along.
        <RankingsContainer>
          <TableContainer className="markdown-body">
            <Title>Season Power Rankings</Title>
            <SubTitle>Updated: {updated}</SubTitle>
            <Markdown source={draftRanking} />
          </TableContainer>
          <TableContainer className="markdown-body">
            <Title>Dynasty Power Rankings</Title>
            <SubTitle>Updated: {updated}</SubTitle>
            <Markdown source={dynastyRanking} />
          </TableContainer>
        </RankingsContainer>
        <RankingsContainer>
          <TableContainer className="markdown-body">
            <Title>Playoff Chances</Title>
            <SubTitle>Updated: {updated}</SubTitle>
            <Markdown source={playoffChances} />
          </TableContainer>
        </RankingsContainer>
      </Body>
    </HomeContainer>
  );
}
