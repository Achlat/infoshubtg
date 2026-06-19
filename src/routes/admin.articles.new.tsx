import { createFileRoute } from "@tanstack/react-router";
import { ArticleForm } from "@/components/ArticleForm";

export const Route = createFileRoute("/admin/articles/new")({
  component: () => (
    <div>
      <h1 className="text-3xl font-black" style={{ fontFamily: "var(--font-display)" }}>Nouvel article</h1>
      <p className="mt-1 text-muted-foreground">Rédigez et publiez votre article.</p>
      <div className="mt-6"><ArticleForm /></div>
    </div>
  ),
});