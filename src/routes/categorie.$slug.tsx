import { createFileRoute } from "@tanstack/react-router";
import { useQuery } from "@tanstack/react-query";
import { api } from "@/lib/api";
import { ArticleCard } from "@/components/ArticleCard";
import type { Article, Category } from "@/lib/types";

export const Route = createFileRoute("/categorie/$slug")({
  component: CategoryPage,
});

function CategoryPage() {
  const { slug } = Route.useParams();
  const { data } = useQuery({
    queryKey: ["cat", slug],
    queryFn: async () => {
      const cat = await api.categories.bySlug(slug);
      if (!cat) return null;
      const list = await api.articles.list({ category_id: cat.id, limit: 50 });
      return { cat: cat as Category, articles: (list ?? []) as Article[] };
    },
  });

  return (
    <div className="mx-auto max-w-7xl px-4 py-10 lg:px-6">
      <div className="border-l-4 pl-4" style={{ borderColor: data?.cat.color }}>
        <span className="text-xs font-black uppercase tracking-widest" style={{ color: data?.cat.color }}>Catégorie</span>
        <h1 className="text-4xl font-black" style={{ fontFamily: "var(--font-display)" }}>{data?.cat.name ?? "..."}</h1>
        {data?.cat.description && <p className="mt-2 text-muted-foreground">{data.cat.description}</p>}
      </div>
      <div className="mt-8 grid gap-6 sm:grid-cols-2 lg:grid-cols-3">
        {data?.articles.length ? data.articles.map((a) => <ArticleCard key={a.id} article={a} />)
          : <div className="col-span-full rounded-xl border border-dashed border-border bg-card p-8 text-center text-muted-foreground">Aucun article dans cette catégorie.</div>}
      </div>
    </div>
  );
}