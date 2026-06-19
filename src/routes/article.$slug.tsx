import { createFileRoute, Link } from "@tanstack/react-router";
import { useQuery } from "@tanstack/react-query";
import { supabase } from "@/integrations/supabase/client";
import type { Article } from "@/lib/types";
import { formatDate } from "@/lib/types";
import { ArticleCard } from "@/components/ArticleCard";

export const Route = createFileRoute("/article/$slug")({
  component: ArticlePage,
  notFoundComponent: () => <NotFound />,
  errorComponent: () => <NotFound />,
});

function NotFound() {
  return (
    <div className="mx-auto max-w-3xl px-4 py-20 text-center">
      <h1 className="text-3xl font-bold">Article introuvable</h1>
      <Link to="/actualites" className="mt-4 inline-block text-primary underline">Retour aux actualités</Link>
    </div>
  );
}

function ArticlePage() {
  const { slug } = Route.useParams();
  const { data, isLoading } = useQuery({
    queryKey: ["article", slug],
    queryFn: async () => {
      const { data: art } = await supabase
        .from("articles")
        .select("*, category:categories(*), commune:communes(*)")
        .eq("slug", slug).eq("status", "published").maybeSingle();
      if (!art) return null;
      const { data: related } = await supabase
        .from("articles")
        .select("*, category:categories(*), commune:communes(*)")
        .eq("status", "published")
        .eq("category_id", (art as any).category_id)
        .neq("id", (art as any).id)
        .order("published_at", { ascending: false })
        .limit(3);
      return { article: art as unknown as Article, related: (related ?? []) as unknown as Article[] };
    },
  });

  if (isLoading) return <div className="mx-auto max-w-3xl px-4 py-12"><div className="h-96 animate-pulse rounded-xl bg-muted" /></div>;
  if (!data) return <NotFound />;
  const a = data.article;
  const url = typeof window !== "undefined" ? window.location.href : "";

  return (
    <article className="mx-auto max-w-4xl px-4 py-10 lg:px-6">
      <div className="flex flex-wrap items-center gap-3 text-sm">
        {a.category && (
          <span className="rounded-sm px-2 py-1 text-[11px] font-black uppercase tracking-wider text-white" style={{ backgroundColor: a.category.color }}>
            {a.category.name}
          </span>
        )}
        {a.commune && <span className="font-semibold text-muted-foreground">📍 {a.commune.name}</span>}
        <span className="text-muted-foreground">{formatDate(a.published_at || a.created_at)}</span>
      </div>
      <h1 className="mt-4 text-4xl font-black leading-tight text-foreground lg:text-5xl" style={{ fontFamily: "var(--font-display)" }}>
        {a.title}
      </h1>
      {a.excerpt && <p className="mt-4 text-lg leading-relaxed text-muted-foreground">{a.excerpt}</p>}

      {a.cover_image && (
        <img src={a.cover_image} alt={a.title} className="mt-6 aspect-[16/9] w-full rounded-xl object-cover" />
      )}

      <div className="prose prose-lg mt-8 max-w-none whitespace-pre-wrap text-foreground" style={{ lineHeight: 1.8 }}>
        {a.content}
      </div>

      {a.tags?.length > 0 && (
        <div className="mt-8 flex flex-wrap gap-2">
          {a.tags.map((t) => <span key={t} className="rounded-full bg-secondary px-3 py-1 text-xs text-secondary-foreground">#{t}</span>)}
        </div>
      )}

      <div className="mt-10 flex flex-wrap items-center gap-3 border-y border-border py-4">
        <span className="text-sm font-bold">Partager :</span>
        <a className="rounded-md bg-secondary px-3 py-1.5 text-sm hover:bg-secondary/80" target="_blank" rel="noreferrer" href={`https://wa.me/?text=${encodeURIComponent(a.title + " " + url)}`}>WhatsApp</a>
        <a className="rounded-md bg-secondary px-3 py-1.5 text-sm hover:bg-secondary/80" target="_blank" rel="noreferrer" href={`https://www.facebook.com/sharer/sharer.php?u=${encodeURIComponent(url)}`}>Facebook</a>
        <a className="rounded-md bg-secondary px-3 py-1.5 text-sm hover:bg-secondary/80" target="_blank" rel="noreferrer" href={`https://twitter.com/intent/tweet?url=${encodeURIComponent(url)}&text=${encodeURIComponent(a.title)}`}>X / Twitter</a>
        <button className="rounded-md bg-secondary px-3 py-1.5 text-sm hover:bg-secondary/80" onClick={() => { navigator.clipboard.writeText(url); }}>Copier le lien</button>
      </div>

      {data.related.length > 0 && (
        <div className="mt-12">
          <h3 className="mb-4 text-2xl font-black" style={{ fontFamily: "var(--font-display)" }}>À lire aussi</h3>
          <div className="grid gap-6 sm:grid-cols-3">
            {data.related.map((r) => <ArticleCard key={r.id} article={r} size="sm" />)}
          </div>
        </div>
      )}
    </article>
  );
}