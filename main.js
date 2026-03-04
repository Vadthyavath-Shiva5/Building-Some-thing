import { createRoot } from "https://esm.sh/react-dom@18/client";
import { App } from "./App.js";
import { React, html } from "./ui.js";

const rootEl = document.getElementById("root");
if (!rootEl) {
  throw new Error("Root element #root not found");
}

createRoot(rootEl).render(html`
  <${React.StrictMode}>
    <${App} />
  </${React.StrictMode}>
`);

