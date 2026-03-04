# Building-Some-thing
For Practice purpose only

## Wordle Arcade (Login Home Page)

This repo now contains a **Wordle-style gaming home + login page** built as a **no-build React SPA** (React loaded from CDN). It supports:

- **Sign up** (username + password + confirm password)
- **Sign in** (username + password)
- **Mock session** (stored in `localStorage`)
- **Wordle-like tile logo** and gaming-themed home layout

### View it in the browser

Because this uses ES modules, you should open it via a local web server (not by double-clicking the file).

- **Option A (recommended)**: Use the VSCode/Cursor extension **Live Server**
  - Right click `index.html` → **Open with Live Server**

- **Option B**: Use the included PowerShell server (no installs)
  - In PowerShell (in this folder) run:

```powershell
.\serve.ps1
```

If PowerShell blocks scripts, run this first (only for the current terminal session):

```powershell
Set-ExecutionPolicy -Scope Process Bypass
```

Then open `http://localhost:5173` in your browser.

### Notes

- **Accounts are demo-only**: users and passwords are stored in your browser `localStorage` for this demo.
- To reset everything, clear site data / localStorage in your browser.

