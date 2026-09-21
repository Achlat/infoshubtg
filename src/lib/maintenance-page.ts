export function renderMaintenancePage(): string {
  return `<!doctype html>
<html lang="fr">

<head>
  <meta charset="utf-8">
  <meta content="width=device-width, initial-scale=1.0" name="viewport">
  <title>Site en maintenance</title>
  <meta name="robots" content="noindex, nofollow">
  <style>
    :root {
      --bg: #0f1115;
      --card: #171a21;
      --border: #2a2e38;
      --text: #e8e9ec;
      --muted: #9aa0ac;
      --accent: #d4a017;
    }

    * { box-sizing: border-box; }

    body {
      margin: 0;
      min-height: 100vh;
      display: flex;
      align-items: center;
      justify-content: center;
      background: var(--bg);
      color: var(--text);
      font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Arial, sans-serif;
      padding: 24px;
    }

    .card {
      max-width: 560px;
      width: 100%;
      background: var(--card);
      border: 1px solid var(--border);
      border-radius: 12px;
      padding: 40px 36px;
      text-align: center;
    }

    .icon {
      width: 56px;
      height: 56px;
      margin: 0 auto 20px;
      border-radius: 50%;
      background: rgba(212, 160, 23, 0.12);
      display: flex;
      align-items: center;
      justify-content: center;
    }

    .icon svg { width: 28px; height: 28px; stroke: var(--accent); }

    h1 {
      font-size: 22px;
      margin: 0 0 12px;
      font-weight: 600;
    }

    p {
      color: var(--muted);
      line-height: 1.6;
      margin: 0 0 8px;
      font-size: 15px;
    }

    .status {
      display: inline-flex;
      align-items: center;
      gap: 8px;
      margin-top: 20px;
      padding: 8px 16px;
      border-radius: 999px;
      background: rgba(212, 160, 23, 0.1);
      color: var(--accent);
      font-size: 13px;
      font-weight: 600;
    }

    .dot {
      width: 8px;
      height: 8px;
      border-radius: 50%;
      background: var(--accent);
      animation: pulse 1.6s infinite;
    }

    @keyframes pulse {
      0%, 100% { opacity: 1; }
      50% { opacity: 0.3; }
    }

    .footer {
      margin-top: 28px;
      padding-top: 20px;
      border-top: 1px solid var(--border);
      font-size: 12px;
      color: #6b7280;
    }
  </style>
</head>

<body>
  <div class="card">
    <div class="icon">
      <svg viewBox="0 0 24 24" fill="none" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
        <path d="M2 12h20"></path>
        <path d="M6 12v6a2 2 0 0 0 2 2h8a2 2 0 0 0 2-2v-6"></path>
        <path d="M6 12V6a2 2 0 0 1 2-2h8a2 2 0 0 1 2 2v6"></path>
        <circle cx="9" cy="8" r="0.5" fill="#d4a017"></circle>
      </svg>
    </div>
    <h1>Site temporairement indisponible</h1>
    <p>Nous rencontrons actuellement une interruption de service.</p>
    <p>Nos équipes techniques travaillent à la résolution du problème. Le site sera rétabli dans les meilleurs délais.</p>
    <div class="status"><span class="dot"></span> Intervention en cours</div>
    <div class="footer">
      Merci de votre compréhension.
    </div>
  </div>
</body>

</html>`;
}
