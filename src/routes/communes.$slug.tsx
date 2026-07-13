import { createFileRoute, Link } from "@tanstack/react-router";
import { useQuery } from "@tanstack/react-query";
import { api } from "@/lib/api";
import { ArticleCard } from "@/components/ArticleCard";
import type { Article, Commune } from "@/lib/types";
import { MapPin, ChevronRight } from "lucide-react";

export const Route = createFileRoute("/communes/$slug")({
  component: CommunePage,
});

function CommunePage() {
  const { slug } = Route.useParams();

  const { data, isLoading } = useQuery({
    queryKey: ["commune", slug],
    queryFn: async () => {
      const commune = await api.communes.bySlug(slug);
      if (!commune) return null;
      const articles = await api.articles.list({ commune_id: commune.id, limit: 30 });
      return { commune: commune as Commune, articles: (articles ?? []) as Article[] };
    },
  });

  if (isLoading) {
    return (
      <div className="mx-auto max-w-7xl px-4 py-10 lg:px-6">
        <div className="h-10 w-64 animate-pulse rounded bg-muted" />
        <div className="mt-8 grid gap-6 sm:grid-cols-2 lg:grid-cols-3">
          {Array.from({ length: 6 }).map((_, i) => (
            <div key={i} className="aspect-[4/3] animate-pulse rounded-xl bg-muted" />
          ))}
        </div>
      </div>
    );
  }

  if (!data) {
    return (
      <div className="mx-auto max-w-7xl px-4 py-20 text-center lg:px-6">
        <p className="text-muted-foreground">Commune introuvable.</p>
        <Link to="/communes" className="mt-4 inline-block text-sm font-bold text-primary hover:underline">
          ← Retour aux communes
        </Link>
      </div>
    );
  }

  const { commune, articles } = data;

  return (
    <div>
      {/* Header commune */}
      <section className="py-12" style={{ background: "var(--gradient-hero)" }}>
        <div className="mx-auto max-w-7xl px-4 lg:px-6">
          <nav className="mb-4 flex items-center gap-1.5 text-xs text-primary-foreground/60">
            <Link to="/communes" className="hover:text-primary-foreground">Communes</Link>
            <ChevronRight className="h-3 w-3" />
            <span className="text-primary-foreground">{commune.name}</span>
          </nav>
          <div className="flex items-start gap-4">
            <div className="flex h-14 w-14 flex-shrink-0 items-center justify-center rounded-xl bg-primary-foreground/20">
              <MapPin className="h-7 w-7 text-primary-foreground" />
            </div>
            <div>
              <span className="text-xs font-bold uppercase tracking-widest text-primary-foreground/70">Commune</span>
              <h1 className="text-4xl font-black text-primary-foreground" style={{ fontFamily: "var(--font-display)" }}>
                {commune.name}
              </h1>
              <div className="mt-2 flex flex-wrap gap-x-5 gap-y-1 text-sm text-primary-foreground/80">
                <span>Région : <strong>{commune.region}</strong></span>
                {commune.prefecture && <span>Préfecture : <strong>{commune.prefecture}</strong></span>}
                {commune.chef_lieu && <span>Chef-lieu : <strong>{commune.chef_lieu}</strong></span>}
              </div>
            </div>
          </div>
        </div>
      </section>

      {/* Articles */}
      <section className="mx-auto max-w-7xl px-4 py-12 lg:px-6">
        <div className="mb-6 flex items-center justify-between">
          <h2 className="text-2xl font-black text-foreground" style={{ fontFamily: "var(--font-display)" }}>
            Actualités de {commune.name}
            <span className="ml-3 text-base font-normal text-muted-foreground">({articles.length})</span>
          </h2>
          <Link to="/actualites" className="text-sm font-bold text-primary hover:underline">
            Toutes les actualités →
          </Link>
        </div>

        {articles.length > 0 ? (
          <div className="grid gap-6 sm:grid-cols-2 lg:grid-cols-3">
            {articles.map((a) => (
              <ArticleCard key={a.id} article={a} />
            ))}
          </div>
        ) : (
          <div className="rounded-xl border border-dashed border-border bg-card p-12 text-center">
            <MapPin className="mx-auto mb-3 h-10 w-10 text-muted-foreground/30" />
            <p className="font-medium text-muted-foreground">Aucun article publié pour cette commune pour le moment.</p>
            <p className="mt-1 text-sm text-muted-foreground/70">Revenez prochainement.</p>
            <Link to="/communes" className="mt-5 inline-block text-sm font-bold text-primary hover:underline">
              ← Voir toutes les communes
            </Link>
          </div>
        )}
      </section>
    </div>
  );
}
