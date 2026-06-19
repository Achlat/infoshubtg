import { createFileRoute, Link } from "@tanstack/react-router";
import { useQuery, useQueryClient } from "@tanstack/react-query";
import { supabase } from "@/integrations/supabase/client";
import { toast } from "sonner";
import { formatDate } from "@/lib/types";

export const Route = createFileRoute("/admin/articles")({
  component: AdminArticlesList,
});

function AdminArticlesList() {
  const qc = useQueryClient();
  const { data, isLoading } = useQuery({
    queryKey: ["admin-articles"],
    queryFn: async () => {
      const { data } = await supabase.from("articles").select("*, category:categories(name,color)").order("created_at", { ascending: false });
      return data ?? [];
    },
  });

  async function del(id: string) {
    if (!confirm("Supprimer cet article ?")) return;
    const { error } = await supabase.from("articles").delete().eq("id", id);
    if (error) toast.error(error.message); else { toast.success("Supprimé"); qc.invalidateQueries({ queryKey: ["admin-articles"] }); }
  }

  async function togglePublish(a: any) {
    const status = a.status === "published" ? "draft" : "published";
    const { error } = await supabase.from("articles").update({ status, published_at: status === "published" ? new Date().toISOString() : null }).eq("id", a.id);
    if (error) toast.error(error.message); else { toast.success(status === "published" ? "Publié" : "Dépublié"); qc.invalidateQueries({ queryKey: ["admin-articles"] }); }
  }

  return (
    <div>
      <div className="flex items-center justify-between">
        <h1 className="text-3xl font-black" style={{ fontFamily: "var(--font-display)" }}>Articles</h1>
        <Link to="/admin/articles/new" className="rounded-md px-4 py-2 text-sm font-bold text-primary-foreground" style={{ background: "var(--gradient-hero)" }}>+ Nouveau</Link>
      </div>
      <div className="mt-6 overflow-hidden rounded-xl border border-border bg-card">
        {isLoading ? <div className="p-8 text-center text-muted-foreground">Chargement...</div>
          : !data?.length ? <div className="p-8 text-center text-muted-foreground">Aucun article. Créez le premier !</div>
          : (
            <table className="w-full text-sm">
              <thead className="bg-secondary text-left text-xs uppercase tracking-wider text-muted-foreground">
                <tr><th className="p-3">Titre</th><th className="p-3">Catégorie</th><th className="p-3">Statut</th><th className="p-3">Date</th><th className="p-3"></th></tr>
              </thead>
              <tbody>
                {data.map((a: any) => (
                  <tr key={a.id} className="border-t border-border">
                    <td className="p-3 font-semibold">{a.title}</td>
                    <td className="p-3">{a.category && <span className="rounded-sm px-2 py-0.5 text-[10px] font-bold uppercase text-white" style={{ backgroundColor: a.category.color }}>{a.category.name}</span>}</td>
                    <td className="p-3"><span className={`rounded-full px-2 py-0.5 text-xs font-bold ${a.status === "published" ? "bg-primary/10 text-primary" : "bg-muted text-muted-foreground"}`}>{a.status === "published" ? "Publié" : "Brouillon"}</span></td>
                    <td className="p-3 text-muted-foreground">{formatDate(a.published_at || a.created_at)}</td>
                    <td className="p-3 text-right">
                      <div className="flex justify-end gap-1">
                        <button onClick={() => togglePublish(a)} className="rounded-md bg-secondary px-2 py-1 text-xs hover:bg-secondary/70">{a.status === "published" ? "Dépublier" : "Publier"}</button>
                        <Link to="/admin/articles/$id/edit" params={{ id: a.id }} className="rounded-md bg-secondary px-2 py-1 text-xs hover:bg-secondary/70">Éditer</Link>
                        <button onClick={() => del(a.id)} className="rounded-md bg-destructive/10 px-2 py-1 text-xs text-destructive hover:bg-destructive/20">Suppr.</button>
                      </div>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          )}
      </div>
    </div>
  );
}