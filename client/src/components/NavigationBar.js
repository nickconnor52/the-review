import React from 'react';
import styled from 'styled-components';
import { Link, useHistory, useLocation } from 'react-router-dom';
import { colors } from '../core/colors';

const NavigationContainer = styled.div`
  display: flex;
  flex-direction: row;
  align-items: center;
  height: 5em;
  background-color: ${colors.washedPurple};
`

const NavLinksContainer = styled.div`
  display: flex;
  flex-direction: row;
  align-items: center;
  margin-left: 10em;
`

const LogoContainer = styled.div`
  margin-left: 2em;
  font-size: 2em;
  font-weight: bold;
  cursor: pointer;
  color: ${colors.lightGrey};
`

const NavButton = styled.div`
  margin-right: 2em;
  font-weight: ${props => props.active ? 'bold' : ''};

  a {
    color: ${colors.lightGrey};
    text-decoration: none
  }
`

function NavItem(props) {
  const { path, name } = props;
  const location = useLocation();
  const active = location.pathname.split('/')[1] === path.split('/')[1];
  return (
    <NavButton active={active}>
      <Link to={path}>
        {name}
      </Link>
    </NavButton>
  )
}

function NavigationBar() {
  const history = useHistory();

  return (
    <NavigationContainer>
      <LogoContainer onClick={() => history.push('/')}>
        The League Review
      </LogoContainer>
      <NavLinksContainer>
        <NavItem path="/" name="Home" />
        <NavItem path="/posts" name="Posts" />
      </NavLinksContainer>
    </NavigationContainer>
  );
}

export default NavigationBar;