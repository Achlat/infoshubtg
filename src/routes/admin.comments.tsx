import { createFileRoute } from "@tanstack/react-router";
import { useQuery, useQueryClient } from "@tanstack/react-query";
import { supabase } from "@/integrations/supabase/client";
import { toast } from "sonner";

export const Route = createFileRoute("/admin/comments")({
  component: CommentsModeration,
});

function CommentsModeration() {
  const qc = useQueryClient();
  const { data } = useQuery({
    queryKey: ["admin-comments"],
    queryFn: async () => {
      const { data } = await supabase.from("comments").select("*, article:articles(title,slug)").order("created_at", { ascending: false });
      return data ?? [];
    },
  });

  async function approve(id: string) {
    const { error } = await supabase.from("comments").update({ approved: true }).eq("id", id);
    if (error) toast.error(error.message); else { toast.success("Approuvé"); qc.invalidateQueries({ queryKey: ["admin-comments"] }); }
  }
  async function del(id: string) {
    if (!confirm("Supprimer ?")) return;
    const { error } = await supabase.from("comments").delete().eq("id", id);
    if (error) toast.error(error.message); else { toast.success("Supprimé"); qc.invalidateQueries({ queryKey: ["admin-comments"] }); }
  }

  return (
    <div>
      <h1 className="text-3xl font-black" style={{ fontFamily: "var(--font-display)" }}>Commentaires</h1>
      <div className="mt-6 space-y-3">
        {!data?.length ? <div className="rounded-xl border border-dashed border-border p-8 text-center text-muted-foreground">Aucun commentaire.</div> :
          data.map((c: any) => (
            <div key={c.id} className="rounded-xl border border-border bg-card p-4">
              <div className="flex items-center justify-between text-xs text-muted-foreground">
                <div><strong>{c.author_name}</strong> sur <em>{c.article?.title}</em></div>
                <span className={`rounded-full px-2 py-0.5 text-[10px] font-bold ${c.approved ? "bg-primary/10 text-primary" : "bg-yellow-100 text-yellow-800"}`}>{c.approved ? "Approuvé" : "En attente"}</span>
              </div>
              <p className="mt-2 text-sm">{c.content}</p>
              <div className="mt-3 flex gap-2">
                {!c.approved && <button onClick={() => approve(c.id)} className="rounded-md bg-primary px-3 py-1 text-xs font-bold text-primary-foreground">Approuver</button>}
                <button onClick={() => del(c.id)} className="rounded-md bg-destructive/10 px-3 py-1 text-xs font-bold text-destructive">Supprimer</button>
              </div>
            </div>
          ))}
      </div>
    </div>
  );
}