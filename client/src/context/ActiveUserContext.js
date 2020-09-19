import React from 'react'

const ActiveUserStateContext = React.createContext()
const ActiveUserDispatchContext = React.createContext()

function activeActiveUserReducer(state, action) {
  switch (action.type) {
    case 'SET_ACTIVE_USER':
      return {
        ...action.user,
        token: action.token,
      }
    case 'REMOVE_ACTIVE_USER':
      return {}
    default: {
      throw new Error(`Unhandled action type: ${action.type}`)
    }
  }
}
function ActiveUserProvider({children}) {
  const userFromStorage = JSON.parse(localStorage.getItem('activeUser'))
  const [state, dispatch] = React.useReducer(activeActiveUserReducer, { ...userFromStorage })
  console.log(state)
  return (
    <ActiveUserStateContext.Provider value={state}>
      <ActiveUserDispatchContext.Provider value={dispatch}>
        {children}
      </ActiveUserDispatchContext.Provider>
    </ActiveUserStateContext.Provider>
  )
}

function useActiveUserState() {
  const context = React.useContext(ActiveUserStateContext)
  if (context === undefined) {
    throw new Error('useActiveUserState must be used within a ActiveUserProvider')
  }
  return context
}

function useActiveUserDispatch() {
  const context = React.useContext(ActiveUserDispatchContext)
  if (context === undefined) {
    throw new Error('useActiveUserDispatch must be used within a ActiveUserProvider')
  }
  return context
}

export {ActiveUserProvider, useActiveUserState, useActiveUserDispatch}
