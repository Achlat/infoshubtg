import { createFileRoute } from "@tanstack/react-router";
import { useQuery } from "@tanstack/react-query";
import { supabase } from "@/integrations/supabase/client";

export const Route = createFileRoute("/admin/newsletter")({
  component: NewsletterAdmin,
});

function NewsletterAdmin() {
  const { data } = useQuery({
    queryKey: ["admin-newsletter"],
    queryFn: async () => {
      const { data } = await supabase.from("newsletter_subscribers").select("*").order("created_at", { ascending: false });
      return data ?? [];
    },
  });

  function exportCsv() {
    const csv = ["email,prenom,date", ...(data ?? []).map((s: any) => `${s.email},${s.first_name ?? ""},${s.created_at}`)].join("\n");
    const blob = new Blob([csv], { type: "text/csv" });
    const url = URL.createObjectURL(blob);
    const a = document.createElement("a"); a.href = url; a.download = "abonnes.csv"; a.click();
  }

  return (
    <div>
      <div className="flex items-center justify-between">
        <h1 className="text-3xl font-black" style={{ fontFamily: "var(--font-display)" }}>Newsletter</h1>
        <button onClick={exportCsv} className="rounded-md bg-secondary px-4 py-2 text-sm font-bold hover:bg-secondary/80">Exporter CSV</button>
      </div>
      <p className="mt-1 text-muted-foreground">{data?.length ?? 0} abonné(s)</p>
      <div className="mt-6 overflow-hidden rounded-xl border border-border bg-card">
        {!data?.length ? <div className="p-8 text-center text-muted-foreground">Aucun abonné pour le moment.</div> :
          <table className="w-full text-sm">
            <thead className="bg-secondary text-left text-xs uppercase tracking-wider text-muted-foreground">
              <tr><th className="p-3">Email</th><th className="p-3">Prénom</th><th className="p-3">Inscrit le</th></tr>
            </thead>
            <tbody>
              {data.map((s: any) => (
                <tr key={s.id} className="border-t border-border">
                  <td className="p-3 font-semibold">{s.email}</td>
                  <td className="p-3">{s.first_name ?? "—"}</td>
                  <td className="p-3 text-muted-foreground">{new Date(s.created_at).toLocaleDateString("fr-FR")}</td>
                </tr>
              ))}
            </tbody>
          </table>}
      </div>
    </div>
  );
}