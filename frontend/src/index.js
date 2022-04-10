import * as monaco from 'monaco-editor/esm/vs/editor/editor.api';
import { setDiagnosticsOptions } from 'monaco-yaml';

import { Elm } from './Main.elm'

import './main.css'

async function init() {

  const app = Elm.Main.init({
    flags: location.origin,
    node: document.getElementById('app')
  });

  monaco.editor.create(document.getElementById('devfile'), {
    value: "",
    language: 'yaml',
      automaticLayout: true
  });
}

document.addEventListener('DOMContentLoaded', () => {
  init();
});
