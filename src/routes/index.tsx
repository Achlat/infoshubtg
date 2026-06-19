import { createFileRoute, Link } from "@tanstack/react-router";
import { useQuery } from "@tanstack/react-query";
import { supabase } from "@/integrations/supabase/client";
import type { Article, Category } from "@/lib/types";
import { ArticleCard } from "@/components/ArticleCard";
import { NewsletterForm } from "@/components/NewsletterForm";
import { formatDate } from "@/lib/types";

export const Route = createFileRoute("/")({
  head: () => ({
    meta: [
      { title: "Communes-Infos.TG — L'actualité des communes du Togo" },
      { name: "description", content: "Politique, développement, éducation, santé, culture, environnement : toute l'actualité des communes togolaises au quotidien." },
      { property: "og:title", content: "Communes-Infos.TG" },
      { property: "og:description", content: "L'actualité des communes du Togo, avec rigueur journalistique." },
    ],
  }),
  component: HomePage,
});

async function fetchHome() {
  const [{ data: featured }, { data: latest }, { data: cats }] = await Promise.all([
    supabase.from("articles").select("*, category:categories(*), commune:communes(*)").eq("status", "published").eq("featured", true).order("published_at", { ascending: false }).limit(5),
    supabase.from("articles").select("*, category:categories(*), commune:communes(*)").eq("status", "published").order("published_at", { ascending: false }).limit(9),
    supabase.from("categories").select("*"),
  ]);
  return {
    featured: (featured ?? []) as unknown as Article[],
    latest: (latest ?? []) as unknown as Article[],
    categories: (cats ?? []) as Category[],
  };
}

function HomePage() {
  const { data, isLoading } = useQuery({ queryKey: ["home"], queryFn: fetchHome });
  const hero = data?.featured?.[0] ?? data?.latest?.[0];
  const sideFeatured = (data?.featured?.length ? data.featured.slice(1, 4) : data?.latest?.slice(1, 4)) ?? [];

  return (
    <div>
      {/* Breaking news bar */}
      <div className="border-b border-border bg-foreground text-background">
        <div className="mx-auto flex max-w-7xl items-center gap-3 px-4 py-2 text-xs lg:px-6">
          <span className="rounded-sm px-2 py-0.5 text-[10px] font-black uppercase tracking-widest" style={{ background: "var(--togo-red)", color: "white" }}>
            En direct
          </span>
          <div className="flex-1 overflow-hidden whitespace-nowrap text-background/80">
            <span className="inline-block animate-[scroll_30s_linear_infinite]">
              Bienvenue sur Communes-Infos.TG — Le portail de référence pour l'actualité des communes du Togo • Suivez l'actualité politique, économique, sociale et culturelle de votre commune •
            </span>
          </div>
        </div>
      </div>

      {/* Hero */}
      <section className="mx-auto max-w-7xl px-4 py-8 lg:px-6">
        {isLoading ? (
          <div className="h-[400px] animate-pulse rounded-xl bg-muted" />
        ) : hero ? (
          <div className="grid gap-6 lg:grid-cols-3">
            <div className="lg:col-span-2">
              <ArticleCard article={hero} size="lg" />
            </div>
            <div className="flex flex-col gap-4">
              {sideFeatured.length === 0 && (
                <EmptyState />
              )}
              {sideFeatured.map((a) => (
                <Link key={a.id} to="/article/$slug" params={{ slug: a.slug }} className="group flex gap-3 rounded-lg border border-border bg-card p-3 transition-colors hover:bg-secondary">
                  {a.cover_image ? (
                    <img src={a.cover_image} alt="" className="h-20 w-28 flex-shrink-0 rounded-md object-cover" />
                  ) : (
                    <div className="h-20 w-28 flex-shrink-0 rounded-md" style={{ background: "var(--gradient-togo)" }} />
                  )}
                  <div className="flex flex-col">
                    {a.category && <span className="text-[10px] font-bold uppercase tracking-wider" style={{ color: a.category.color }}>{a.category.name}</span>}
                    <h4 className="mt-1 line-clamp-3 text-sm font-bold leading-snug text-foreground group-hover:text-primary" style={{ fontFamily: "var(--font-display)" }}>{a.title}</h4>
                    <div className="mt-auto pt-1 text-[11px] text-muted-foreground">{formatDate(a.published_at || a.created_at)}</div>
                  </div>
                </Link>
              ))}
            </div>
          </div>
        ) : (
          <EmptyHero />
        )}
      </section>

      {/* Categories strip */}
      <section className="border-y border-border bg-secondary/40">
        <div className="mx-auto flex max-w-7xl flex-wrap items-center justify-center gap-2 px-4 py-4 lg:px-6">
          {(data?.categories ?? []).map((c) => (
            <Link key={c.id} to="/categorie/$slug" params={{ slug: c.slug }} className="rounded-full border border-border bg-background px-3 py-1.5 text-xs font-bold uppercase tracking-wider transition-colors hover:text-background" style={{ color: c.color }}>
              {c.name}
            </Link>
          ))}
        </div>
      </section>

      {/* Latest */}
      <section className="mx-auto max-w-7xl px-4 py-12 lg:px-6">
        <div className="mb-6 flex items-center justify-between">
          <h2 className="text-2xl font-black text-foreground" style={{ fontFamily: "var(--font-display)" }}>
            Dernières actualités
          </h2>
          <Link to="/actualites" className="text-sm font-bold text-primary hover:underline">Tout voir →</Link>
        </div>
        {isLoading ? (
          <div className="grid gap-6 sm:grid-cols-2 lg:grid-cols-3">
            {Array.from({ length: 6 }).map((_, i) => <div key={i} className="aspect-[4/3] animate-pulse rounded-xl bg-muted" />)}
          </div>
        ) : data?.latest?.length ? (
          <div className="grid gap-6 sm:grid-cols-2 lg:grid-cols-3">
            {data.latest.map((a) => <ArticleCard key={a.id} article={a} />)}
          </div>
        ) : (
          <EmptyState />
        )}
      </section>

      {/* Newsletter */}
      <section className="mx-auto max-w-7xl px-4 pb-16 lg:px-6">
        <div className="overflow-hidden rounded-2xl p-8 lg:p-12" style={{ background: "var(--gradient-hero)" }}>
          <div className="grid items-center gap-6 lg:grid-cols-2">
            <div className="text-primary-foreground">
              <h3 className="text-3xl font-black" style={{ fontFamily: "var(--font-display)" }}>Restez informé(e)</h3>
              <p className="mt-2 text-primary-foreground/80">Inscrivez-vous à notre newsletter hebdomadaire et recevez l'essentiel de l'actualité communale.</p>
            </div>
            <div className="rounded-xl bg-background/95 p-5">
              <NewsletterForm />
            </div>
          </div>
        </div>
      </section>

      <style>{`@keyframes scroll { 0% { transform: translateX(0); } 100% { transform: translateX(-50%); } }`}</style>
    </div>
  );
}

function EmptyHero() {
  return (
    <div className="rounded-2xl border border-dashed border-border p-12 text-center" style={{ background: "var(--gradient-hero)" }}>
      <h2 className="text-3xl font-black text-primary-foreground" style={{ fontFamily: "var(--font-display)" }}>Bienvenue sur Communes-Infos.TG</h2>
      <p className="mt-3 text-primary-foreground/80">Le site est prêt. Connectez-vous à l'espace admin pour publier votre premier article.</p>
      <Link to="/auth" className="mt-6 inline-block rounded-md bg-background px-5 py-2.5 text-sm font-bold text-primary">Accéder à l'admin</Link>
    </div>
  );
}

function EmptyState() {
  return (
    <div className="rounded-xl border border-dashed border-border bg-card p-8 text-center text-sm text-muted-foreground">
      Aucun article publié pour le moment. Publiez le premier depuis l'espace admin.
    </div>
  );
}
