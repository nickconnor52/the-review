import React from 'react';
import {
  BrowserRouter as Router,
  Switch,
  Route,
} from 'react-router-dom';
import styled from 'styled-components';
import { colors } from './core/colors';

import NavigationBar from './components/NavigationBar';
import Owners from './components/owners/Owners';
import PostsDirectory from './components/posts/PostsDirectory';
import Post from './components/posts/Post';
import PostEditor from './components/posts/PostEditor';

const PageBody = styled.div`
  background-color: ${colors.lightGrey};
  min-height: 100%;
`

export default function App() {
  return (
    <Router>
      <PageBody>
        <NavigationBar />
        {/* A <Switch> looks through its children <Route>s and
            renders the first one that matches the current URL. */}
          <Switch>
            <Route path='/owners'>
              <Owners />
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
            <Route path='/'>
              <Home />
            </Route>
          </Switch>
      </PageBody>
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

function Home() {
  return (
    <HomeContainer>
      <Title>
        Welcome to The League Review
      </Title>
      <Body>
        It's gonna look pretty bare in here for a while, but I'm working on it. At a bare minimum, check back each week to read
        my latest ramblings about your team, my team, and everything in between. I'll keep y'all posted as things move along.
      </Body>
    </HomeContainer>
  );
}
