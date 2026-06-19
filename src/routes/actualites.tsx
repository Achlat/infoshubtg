import { createFileRoute } from "@tanstack/react-router";
import { useQuery } from "@tanstack/react-query";
import { useState } from "react";
import { supabase } from "@/integrations/supabase/client";
import { ArticleCard } from "@/components/ArticleCard";
import type { Article, Category, Commune } from "@/lib/types";

export const Route = createFileRoute("/actualites")({
  head: () => ({
    meta: [
      { title: "Actualités — Communes-Infos.TG" },
      { name: "description", content: "Toutes les actualités des communes togolaises classées par catégorie et par commune." },
      { property: "og:title", content: "Actualités — Communes-Infos.TG" },
      { property: "og:description", content: "Toutes les actualités des communes togolaises." },
    ],
  }),
  component: ActualitesPage,
});

function ActualitesPage() {
  const [q, setQ] = useState("");
  const [cat, setCat] = useState<string>("");
  const [com, setCom] = useState<string>("");

  const filters = useQuery({
    queryKey: ["filters"],
    queryFn: async () => {
      const [c, m] = await Promise.all([
        supabase.from("categories").select("*").order("name"),
        supabase.from("communes").select("*").order("name"),
      ]);
      return { cats: (c.data ?? []) as Category[], coms: (m.data ?? []) as Commune[] };
    },
  });

  const list = useQuery({
    queryKey: ["articles-list", q, cat, com],
    queryFn: async () => {
      let query = supabase
        .from("articles")
        .select("*, category:categories(*), commune:communes(*)")
        .eq("status", "published")
        .order("published_at", { ascending: false })
        .limit(50);
      if (cat) query = query.eq("category_id", cat);
      if (com) query = query.eq("commune_id", com);
      if (q) query = query.ilike("title", `%${q}%`);
      const { data } = await query;
      return (data ?? []) as unknown as Article[];
    },
  });

  return (
    <div className="mx-auto max-w-7xl px-4 py-10 lg:px-6">
      <h1 className="text-4xl font-black text-foreground" style={{ fontFamily: "var(--font-display)" }}>Actualités</h1>
      <p className="mt-2 text-muted-foreground">Filtrez par catégorie, commune ou mot-clé.</p>

      <div className="mt-6 grid gap-3 rounded-xl border border-border bg-card p-4 sm:grid-cols-3">
        <input value={q} onChange={(e) => setQ(e.target.value)} placeholder="Rechercher..." className="rounded-md border border-input bg-background px-3 py-2 text-sm" />
        <select value={cat} onChange={(e) => setCat(e.target.value)} className="rounded-md border border-input bg-background px-3 py-2 text-sm">
          <option value="">Toutes catégories</option>
          {filters.data?.cats.map((c) => <option key={c.id} value={c.id}>{c.name}</option>)}
        </select>
        <select value={com} onChange={(e) => setCom(e.target.value)} className="rounded-md border border-input bg-background px-3 py-2 text-sm">
          <option value="">Toutes communes</option>
          {filters.data?.coms.map((c) => <option key={c.id} value={c.id}>{c.name}</option>)}
        </select>
      </div>

      <div className="mt-8 grid gap-6 sm:grid-cols-2 lg:grid-cols-3">
        {list.isLoading ? (
          Array.from({ length: 6 }).map((_, i) => <div key={i} className="aspect-[4/3] animate-pulse rounded-xl bg-muted" />)
        ) : list.data?.length ? (
          list.data.map((a) => <ArticleCard key={a.id} article={a} />)
        ) : (
          <div className="col-span-full rounded-xl border border-dashed border-border bg-card p-8 text-center text-muted-foreground">
            Aucun article trouvé.
          </div>
        )}
      </div>
    </div>
  );
}