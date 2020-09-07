import React from 'react';
import ReactDOM from 'react-dom';
import './index.css';
import App from './App';
import * as serviceWorker from './serviceWorker';
import axios from 'axios'


console.log(process.env.NODE_ENV)
if (process.env.NODE_ENV === 'production') {
  console.log(process.env.API_BASE_URL)
  axios.defaults.baseURL = process.env.API_BASE_URL || ''
}
if (process.env.NODE_ENV === 'development') {
  axios.defaults.baseURL = 'http://test.com/' || ''
}

ReactDOM.render(<App />, document.getElementById('root'));
// If you want your app to work offline and load faster, you can change
// unregister() to register() below. Note this comes with some pitfalls.
// Learn more about service workers: https://bit.ly/CRA-PWA
serviceWorker.unregister();
