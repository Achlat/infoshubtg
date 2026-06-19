import { createFileRoute } from "@tanstack/react-router";
import { useQuery } from "@tanstack/react-query";
import { supabase } from "@/integrations/supabase/client";
import { ArticleForm } from "@/components/ArticleForm";

export const Route = createFileRoute("/admin/articles/$id/edit")({
  component: EditPage,
});

function EditPage() {
  const { id } = Route.useParams();
  const { data, isLoading } = useQuery({
    queryKey: ["edit-article", id],
    queryFn: async () => {
      const { data } = await supabase.from("articles").select("*").eq("id", id).maybeSingle();
      return data;
    },
  });

  return (
    <div>
      <h1 className="text-3xl font-black" style={{ fontFamily: "var(--font-display)" }}>Éditer l'article</h1>
      <div className="mt-6">
        {isLoading ? <div className="text-muted-foreground">Chargement...</div>
          : !data ? <div className="text-muted-foreground">Article introuvable.</div>
          : <ArticleForm initial={data} />}
      </div>
    </div>
  );
}