import { createFileRoute } from "@tanstack/react-router";

export const Route = createFileRoute("/a-propos")({
  head: () => ({
    meta: [
      { title: "À propos — Communes-Infos.TG" },
      { name: "description", content: "Découvrez la mission et l'équipe de Communes-Infos.TG, le portail dédié à l'actualité des communes togolaises." },
    ],
  }),
  component: () => (
    <div className="mx-auto max-w-3xl px-4 py-12 lg:px-6">
      <h1 className="text-4xl font-black" style={{ fontFamily: "var(--font-display)" }}>À propos</h1>
      <div className="prose prose-lg mt-6 max-w-none text-foreground">
        <p>Les communes du Togo constituent le premier niveau de gouvernance de proximité et jouent un rôle central dans le développement socio-économique du pays.</p>
        <p><strong>Communes-Infos.TG</strong> est un journal numérique couvrant l'actualité des communes togolaises dans toutes leurs dimensions : politique, culturelle, économique, sociale, sanitaire et environnementale.</p>
        <h2>Notre mission</h2>
        <p>Offrir aux citoyens togolais et à la diaspora une information municipale fiable, accessible et de qualité.</p>
        <h2>Notre équipe</h2>
        <p>Une rédaction engagée, à l'écoute des élus locaux et du terrain.</p>
      </div>
    </div>
  ),
});