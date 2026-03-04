import { Header } from "./components/Header.js";
import { AuthPanel } from "./components/AuthPanel.js";
import { PostLoginPanel } from "./components/PostLoginPanel.js";
import { React, html } from "./ui.js";

const SESSION_KEY = "wordle_demo_current_user";

export function App() {
  const [currentUser, setCurrentUser] = React.useState(null);

  React.useEffect(() => {
    try {
      const raw = localStorage.getItem(SESSION_KEY);
      if (!raw) return;
      const parsed = JSON.parse(raw);
      if (parsed && typeof parsed.username === "string" && parsed.username.trim()) {
        setCurrentUser({ username: parsed.username.trim() });
      }
    } catch {
      // ignore corrupt session
    }
  }, []);

  React.useEffect(() => {
    try {
      if (!currentUser) {
        localStorage.removeItem(SESSION_KEY);
        return;
      }
      localStorage.setItem(SESSION_KEY, JSON.stringify({ username: currentUser.username }));
    } catch {
      // ignore storage errors
    }
  }, [currentUser]);

  return html`
    <div className="appRoot">
      <div className="backgroundGlow" aria-hidden="true"></div>
      <${Header} />

      <main className="mainContent">
        <section className="homeCard" aria-label="Wordle Arcade home">
          <div className="homeCardLeft">
            <div className="brandBlock">
              <div className="brandTitle">Wordle Arcade</div>
              <div className="brandSubtitle">Sign in to keep your streak alive.</div>
            </div>

            <div className="tileBoardPreview" aria-hidden="true">
              <div className="tileRow">
                <div className="tile tileAccent">W</div>
                <div className="tile">O</div>
                <div className="tile">R</div>
                <div className="tile">D</div>
                <div className="tile">L</div>
                <div className="tile">E</div>
              </div>
              <div className="tileRow">
                <div className="tile">A</div>
                <div className="tile">R</div>
                <div className="tile tileAccent2">C</div>
                <div className="tile">A</div>
                <div className="tile">D</div>
                <div className="tile">E</div>
              </div>
            </div>
          </div>

          <div className="homeCardRight">
            ${!currentUser
              ? html`<${AuthPanel} onAuthSuccess=${setCurrentUser} />`
              : html`<${PostLoginPanel}
                  username=${currentUser.username}
                  onLogout=${() => setCurrentUser(null)}
                />`}
          </div>
        </section>
      </main>
    </div>
  `;
}

