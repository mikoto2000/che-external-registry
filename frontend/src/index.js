import * as monaco from 'monaco-editor/esm/vs/editor/editor.api';
import { setDiagnosticsOptions } from 'monaco-yaml';

import { Elm } from './Main.elm'

import './main.css'

async function init() {

  const app = Elm.Main.init({
    flags: location.origin,
    node: document.getElementById('app')
  });

  const SCHEMA_URL = './schemas/devfile.json';

  async function getJsonFromUri(jsonUri) {
    const response = await fetch(jsonUri);
    const json = await response.json();
    return json;
  }

  const schema = await getJsonFromUri(SCHEMA_URL);

  setDiagnosticsOptions({
    enableSchemaRequest: true,
    hover: true,
    completion: true,
    format: true,
    validate: true,
    schemas: [
      {
        uri: SCHEMA_URL,
        fileMatch: ['*'],
        schema: schema
      }
    ]
  });

  const editor = monaco.editor.create(document.getElementById('devfile'), {
    value: "",
    language: 'yaml',
    automaticLayout: true
  });

  app.ports.sendDevfileContentToMonaco.subscribe((devfileContent) => {
      editor.getModel().setValue(devfileContent);
  });

  editor.getModel().onDidChangeContent((event) => {
    const devfileContent = editor.getModel().getValue();
    app.ports.sendDevfileContentToElmModel.send(devfileContent);
  });
}

document.addEventListener('DOMContentLoaded', () => {
  init();
});
