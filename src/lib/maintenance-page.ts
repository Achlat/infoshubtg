export function renderMaintenancePage(): string {
  return `<!doctype html>
<html lang="fr">
  <head>
    <meta charset="utf-8" />
    <title>Site en maintenance — Communes-Infos.TG</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <meta name="robots" content="noindex" />
    <style>
      body { font: 16px/1.6 system-ui, -apple-system, sans-serif; background: #fafafa; color: #111; display: grid; place-items: center; min-height: 100vh; margin: 0; padding: 1.5rem; }
      .card { max-width: 28rem; width: 100%; text-align: center; padding: 2rem; }
      h1 { font-size: 1.5rem; margin: 0 0 0.75rem; }
      p { color: #4b5563; margin: 0; }
    </style>
  </head>
  <body>
    <div class="card">
      <h1>Site en maintenance</h1>
      <p>Ce site est temporairement indisponible. Merci de votre patience.</p>
    </div>
  </body>
</html>`;
}
