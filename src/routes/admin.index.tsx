import { createFileRoute, Link } from "@tanstack/react-router";
import { useQuery } from "@tanstack/react-query";
import { api } from "@/lib/api";

export const Route = createFileRoute("/admin/")({
  component: Dashboard,
});

function Dashboard() {
  const { data } = useQuery({
    queryKey: ["dashboard-stats"],
    queryFn: () => api.adminStats.get(),
  });

  const cards = [
    { label: "Articles", value: data?.total ?? 0, color: "var(--togo-green)" },
    { label: "Publiés", value: data?.published ?? 0, color: "var(--togo-red)" },
    { label: "Commentaires en attente", value: data?.pendingComments ?? 0, color: "var(--togo-yellow)" },
    { label: "Abonnés newsletter", value: data?.subs ?? 0, color: "var(--primary)" },
  ];

  return (
    <div>
      <h1 className="text-3xl font-black" style={{ fontFamily: "var(--font-display)" }}>Tableau de bord</h1>
      <p className="mt-1 text-muted-foreground">Vue d'ensemble de votre site.</p>
      <div className="mt-6 grid gap-4 sm:grid-cols-2 lg:grid-cols-4">
        {cards.map((c) => (
          <div key={c.label} className="rounded-xl border border-border bg-card p-5">
            <div className="text-xs font-bold uppercase tracking-wider text-muted-foreground">{c.label}</div>
            <div className="mt-2 text-3xl font-black" style={{ color: c.color }}>{c.value}</div>
          </div>
        ))}
      </div>
      <div className="mt-8 rounded-xl border border-border bg-card p-6">
        <h2 className="text-lg font-bold">Démarrer</h2>
        <p className="mt-1 text-sm text-muted-foreground">Publiez votre premier article en quelques clics.</p>
        <Link to="/admin/articles/new" className="mt-4 inline-block rounded-md px-4 py-2 text-sm font-bold text-primary-foreground" style={{ background: "var(--gradient-hero)" }}>
          + Nouvel article
        </Link>
      </div>
    </div>
  );
}
