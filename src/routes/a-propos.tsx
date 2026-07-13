import { createFileRoute, Link } from "@tanstack/react-router";
import { BookOpen, Users, MapPin, Award, Target, Eye, Heart, Globe } from "lucide-react";

export const Route = createFileRoute("/a-propos")({
  head: () => ({
    meta: [
      { title: "À propos — Communes-Infos.TG" },
      { name: "description", content: "Découvrez la mission, les valeurs et l'équipe de Communes-Infos.TG, le portail dédié à l'actualité des communes togolaises." },
    ],
  }),
  component: AProposPage,
});

function AProposPage() {
  return (
    <div>
      {/* Hero */}
      <section className="overflow-hidden py-16 lg:py-24" style={{ background: "var(--gradient-hero)" }}>
        <div className="mx-auto max-w-4xl px-4 text-center lg:px-6">
          <span className="inline-block rounded-full border border-primary-foreground/30 px-4 py-1.5 text-xs font-bold uppercase tracking-widest text-primary-foreground/80">
            À propos de nous
          </span>
          <h1 className="mt-4 text-4xl font-black text-primary-foreground lg:text-5xl" style={{ fontFamily: "var(--font-display)" }}>
            L'actualité des communes du Togo,<br />avec rigueur journalistique
          </h1>
          <p className="mt-6 text-lg text-primary-foreground/80">
            Communes-Infos.TG est un journal numérique indépendant qui couvre l'actualité
            politique, économique, sociale et culturelle des communes togolaises au quotidien.
          </p>
        </div>
      </section>

      {/* Stats */}
      <section className="border-b border-border bg-card">
        <div className="mx-auto max-w-5xl px-4 py-10 lg:px-6">
          <div className="grid grid-cols-2 gap-6 text-center sm:grid-cols-4">
            {[
              { icon: MapPin, value: "117", label: "Communes couvertes" },
              { icon: BookOpen, value: "5", label: "Régions" },
              { icon: Users, value: "10+", label: "Journalistes" },
              { icon: Globe, value: "2024", label: "Année de création" },
            ].map(({ icon: Icon, value, label }) => (
              <div key={label} className="flex flex-col items-center gap-2">
                <Icon className="h-7 w-7 text-primary" />
                <span className="text-3xl font-black text-foreground" style={{ fontFamily: "var(--font-display)" }}>{value}</span>
                <span className="text-xs font-medium text-muted-foreground">{label}</span>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* Mission */}
      <section className="mx-auto max-w-3xl px-4 py-16 lg:px-6">
        <div className="text-center">
          <h2 className="text-3xl font-black text-foreground" style={{ fontFamily: "var(--font-display)" }}>Notre mission</h2>
          <p className="mt-2 text-muted-foreground">Ce qui nous anime au quotidien</p>
        </div>
        <div className="mt-10 space-y-6 text-base leading-relaxed text-foreground/80">
          <p>
            Les communes du Togo constituent le premier niveau de gouvernance de proximité. Elles jouent
            un rôle central dans le développement socio-économique du pays, mais restent trop souvent
            absentes des grands médias nationaux.
          </p>
          <p>
            <strong className="text-foreground">Communes-Infos.TG</strong> est né de la conviction que chaque habitant, chaque élu local,
            chaque acteur du développement mérite une information municipale fiable, accessible et de qualité —
            quelle que soit sa commune d'origine ou de résidence.
          </p>
          <p>
            Nous offrons aux citoyens togolais et à la diaspora une fenêtre sur les décisions qui impactent
            leur quotidien : budgets communaux, projets d'infrastructure, élections locales, initiatives
            culturelles, actualités sanitaires et environnementales.
          </p>
        </div>
      </section>

      {/* Valeurs */}
      <section className="bg-secondary/30 py-16">
        <div className="mx-auto max-w-5xl px-4 lg:px-6">
          <div className="text-center">
            <h2 className="text-3xl font-black text-foreground" style={{ fontFamily: "var(--font-display)" }}>Nos valeurs</h2>
            <p className="mt-2 text-muted-foreground">Les principes qui guident notre travail</p>
          </div>
          <div className="mt-10 grid gap-6 sm:grid-cols-2 lg:grid-cols-4">
            {[
              {
                icon: Target,
                title: "Rigueur",
                desc: "Chaque information est vérifiée avant publication. Nous ne publions que ce que nous pouvons confirmer.",
              },
              {
                icon: Eye,
                title: "Transparence",
                desc: "Nous indiquons nos sources, corrigeons nos erreurs publiquement et distinguons faits et opinions.",
              },
              {
                icon: Heart,
                title: "Proximité",
                desc: "Nos journalistes sont sur le terrain, au plus près des réalités communales et des habitants.",
              },
              {
                icon: Award,
                title: "Indépendance",
                desc: "Notre ligne éditoriale est libre de toute pression politique ou commerciale.",
              },
            ].map(({ icon: Icon, title, desc }) => (
              <div key={title} className="rounded-xl border border-border bg-card p-6">
                <div className="mb-4 inline-flex h-11 w-11 items-center justify-center rounded-lg" style={{ background: "var(--gradient-hero)" }}>
                  <Icon className="h-5 w-5 text-primary-foreground" />
                </div>
                <h3 className="text-base font-black text-foreground" style={{ fontFamily: "var(--font-display)" }}>{title}</h3>
                <p className="mt-2 text-sm text-muted-foreground leading-relaxed">{desc}</p>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* Équipe */}
      <section className="mx-auto max-w-5xl px-4 py-16 lg:px-6">
        <div className="text-center">
          <h2 className="text-3xl font-black text-foreground" style={{ fontFamily: "var(--font-display)" }}>Notre équipe</h2>
          <p className="mt-2 text-muted-foreground">Des journalistes engagés, à l'écoute du terrain</p>
        </div>
        <div className="mt-10 grid gap-6 sm:grid-cols-2 lg:grid-cols-3">
          {[
            { name: "Akossiwa Mensah", role: "Directrice de la rédaction", region: "Lomé-Commune" },
            { name: "Koffi Agbenyega", role: "Journaliste — Politique & Gouvernance", region: "Région des Plateaux" },
            { name: "Ama Dossou", role: "Journaliste — Économie & Développement", region: "Région Maritime" },
            { name: "Yves Kokou", role: "Journaliste — Culture & Société", region: "Région Centrale" },
            { name: "Sena Adzoa", role: "Journaliste — Santé & Environnement", region: "Région de la Kara" },
            { name: "Mawuli Gbedema", role: "Journaliste — Éducation & Jeunesse", region: "Région des Savanes" },
          ].map(({ name, role, region }) => (
            <div key={name} className="flex items-start gap-4 rounded-xl border border-border bg-card p-5">
              <div className="flex h-12 w-12 flex-shrink-0 items-center justify-center rounded-full text-sm font-black text-primary-foreground" style={{ background: "var(--gradient-togo)" }}>
                {name.split(" ").map((n) => n[0]).join("")}
              </div>
              <div>
                <div className="font-bold text-foreground">{name}</div>
                <div className="text-xs text-muted-foreground">{role}</div>
                <div className="mt-1 flex items-center gap-1 text-[11px] text-primary">
                  <MapPin className="h-3 w-3" />
                  {region}
                </div>
              </div>
            </div>
          ))}
        </div>
      </section>

      {/* CTA */}
      <section className="border-t border-border bg-card py-14">
        <div className="mx-auto max-w-3xl px-4 text-center lg:px-6">
          <h2 className="text-2xl font-black text-foreground" style={{ fontFamily: "var(--font-display)" }}>Vous avez une information à partager ?</h2>
          <p className="mt-3 text-muted-foreground">Notre rédaction est à l'écoute. Signalez-nous un fait, proposez un sujet ou collaborez avec nous.</p>
          <div className="mt-6 flex flex-wrap justify-center gap-3">
            <Link to="/contact" className="rounded-md px-5 py-2.5 text-sm font-bold text-primary-foreground" style={{ background: "var(--gradient-hero)" }}>
              Nous contacter
            </Link>
            <Link to="/actualites" className="rounded-md border border-border bg-background px-5 py-2.5 text-sm font-bold text-foreground hover:bg-secondary">
              Lire nos articles
            </Link>
          </div>
        </div>
      </section>
    </div>
  );
}
