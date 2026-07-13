import { createFileRoute, Link } from "@tanstack/react-router";
import { useQuery } from "@tanstack/react-query";
import { api } from "@/lib/api";
import type { Commune } from "@/lib/types";
import { ChevronRight } from "lucide-react";

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
    queryFn: async () => (await api.communes.list()) as Commune[],
  });

  const byRegion = (data ?? []).reduce<Record<string, Commune[]>>((acc, c) => {
    (acc[c.region] ??= []).push(c); return acc;
  }, {});

  return (
    <div className="mx-auto max-w-7xl px-4 py-10 lg:px-6">
      <h1 className="text-4xl font-black" style={{ fontFamily: "var(--font-display)" }}>Communes du Togo</h1>
      <p className="mt-2 text-muted-foreground">Découvrez les communes togolaises classées par région. Cliquez sur une commune pour voir ses actualités.</p>
      <div className="mt-8 space-y-8">
        {Object.entries(byRegion).map(([region, list]) => (
          <section key={region}>
            <h2 className="mb-4 inline-block rounded-md px-3 py-1 text-sm font-black uppercase tracking-widest text-white" style={{ background: "var(--gradient-hero)" }}>
              Région {region}
            </h2>
            <div className="grid gap-3 sm:grid-cols-2 lg:grid-cols-4">
              {list.map((c) => (
                <Link
                  key={c.id}
                  to="/communes/$slug"
                  params={{ slug: c.slug }}
                  className="group flex items-center justify-between rounded-lg border border-border bg-card p-4 transition-colors hover:border-primary/40 hover:bg-secondary"
                >
                  <div>
                    <div className="font-bold text-foreground group-hover:text-primary">{c.name}</div>
                    {c.prefecture && <div className="text-xs text-muted-foreground">Préfecture : {c.prefecture}</div>}
                  </div>
                  <ChevronRight className="h-4 w-4 flex-shrink-0 text-muted-foreground/40 transition-colors group-hover:text-primary" />
                </Link>
              ))}
            </div>
          </section>
        ))}
      </div>
    </div>
  );
}