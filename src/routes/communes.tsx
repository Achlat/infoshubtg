import { createFileRoute } from "@tanstack/react-router";
import { useQuery } from "@tanstack/react-query";
import { supabase } from "@/integrations/supabase/client";
import type { Commune } from "@/lib/types";

export const Route = createFileRoute("/communes")({
  head: () => ({
    meta: [
      { title: "Communes du Togo — Communes-Infos.TG" },
      { name: "description", content: "Répertoire des communes du Togo classées par région et préfecture." },
    ],
  }),
  component: CommunesPage,
});

function CommunesPage() {
  const { data } = useQuery({
    queryKey: ["communes-all"],
    queryFn: async () => {
      const { data } = await supabase.from("communes").select("*").order("region").order("name");
      return (data ?? []) as Commune[];
    },
  });

  const byRegion = (data ?? []).reduce<Record<string, Commune[]>>((acc, c) => {
    (acc[c.region] ??= []).push(c); return acc;
  }, {});

  return (
    <div className="mx-auto max-w-7xl px-4 py-10 lg:px-6">
      <h1 className="text-4xl font-black" style={{ fontFamily: "var(--font-display)" }}>Communes du Togo</h1>
      <p className="mt-2 text-muted-foreground">Découvrez les communes togolaises classées par région.</p>
      <div className="mt-8 space-y-8">
        {Object.entries(byRegion).map(([region, list]) => (
          <section key={region}>
            <h2 className="mb-4 inline-block rounded-md px-3 py-1 text-sm font-black uppercase tracking-widest text-white" style={{ background: "var(--gradient-hero)" }}>
              Région {region}
            </h2>
            <div className="grid gap-3 sm:grid-cols-2 lg:grid-cols-4">
              {list.map((c) => (
                <div key={c.id} className="rounded-lg border border-border bg-card p-4">
                  <div className="font-bold text-foreground">{c.name}</div>
                  {c.prefecture && <div className="text-xs text-muted-foreground">Préfecture : {c.prefecture}</div>}
                </div>
              ))}
            </div>
          </section>
        ))}
      </div>
    </div>
  );
}