import { Link } from "@tanstack/react-router";
import type { Article } from "@/lib/types";
import { formatDate } from "@/lib/types";

export function ArticleCard({ article, size = "md" }: { article: Article; size?: "sm" | "md" | "lg" }) {
  const cat = article.category;
  return (
    <Link
      to="/article/$slug" params={{ slug: article.slug }}
      className="group flex flex-col overflow-hidden rounded-xl border border-border bg-card transition-all hover:-translate-y-0.5"
      style={{ boxShadow: "var(--shadow-card)" }}
    >
      <div className={size === "lg" ? "aspect-[16/9]" : "aspect-[16/10]"}>
        {article.cover_image ? (
          <img src={article.cover_image} alt={article.title} loading="lazy" className="h-full w-full object-cover transition-transform group-hover:scale-[1.03]" />
        ) : (
          <div className="h-full w-full" style={{ background: "var(--gradient-hero)" }} />
        )}
      </div>
      <div className="flex flex-1 flex-col gap-2 p-4">
        <div className="flex items-center gap-2">
          {cat && (
            <span className="rounded-sm px-2 py-0.5 text-[10px] font-bold uppercase tracking-wider text-white" style={{ backgroundColor: cat.color }}>
              {cat.name}
            </span>
          )}
          {article.commune && (
            <span className="text-[11px] font-semibold uppercase tracking-wider text-muted-foreground">{article.commune.name}</span>
          )}
        </div>
        <h3 className={`font-bold leading-tight text-foreground group-hover:text-primary ${size === "lg" ? "text-2xl" : "text-base"}`} style={{ fontFamily: "var(--font-display)" }}>
          {article.title}
        </h3>
        {article.excerpt && size !== "sm" && (
          <p className="line-clamp-2 text-sm text-muted-foreground">{article.excerpt}</p>
        )}
        <div className="mt-auto pt-2 text-xs text-muted-foreground">{formatDate(article.published_at || article.created_at)}</div>
      </div>
    </Link>
  );
}