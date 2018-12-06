import './main.css';
import { Elm } from './Main.elm';
import registerServiceWorker from './registerServiceWorker';
// import * as git from 'isomorphic-git'
import elmFs from './elmFs'

function init (fs) {
  Elm.Main.init({
    node: document.getElementById('root'),
    flags: {fs}
  });
}
elmFs(init)

registerServiceWorker();
