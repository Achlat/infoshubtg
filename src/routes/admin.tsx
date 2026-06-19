import { createFileRoute, Outlet, Link, useNavigate } from "@tanstack/react-router";
import { useEffect } from "react";
import { useAuth } from "@/lib/use-auth";
import { supabase } from "@/integrations/supabase/client";
import { toast } from "sonner";
import { LayoutDashboard, FileText, Plus, MessageSquare, Mail, LogOut } from "lucide-react";

export const Route = createFileRoute("/admin")({
  component: AdminLayout,
});

function AdminLayout() {
  const nav = useNavigate();
  const { session, isEditor, isAdmin, loading, reloadRoles } = useAuth();

  useEffect(() => {
    if (!loading && !session) nav({ to: "/auth" });
  }, [loading, session, nav]);

  useEffect(() => {
    // Auto-claim admin if no admin exists yet
    if (session && !isAdmin && !loading) {
      supabase.rpc("claim_first_admin").then(({ data }) => {
        if (data === true) { toast.success("Vous êtes le premier administrateur !"); reloadRoles(); }
      });
    }
  }, [session, isAdmin, loading, reloadRoles]);

  async function logout() {
    await supabase.auth.signOut();
    nav({ to: "/" });
  }

  if (loading || !session) return <div className="p-12 text-center text-muted-foreground">Chargement...</div>;

  if (!isEditor) {
    return (
      <div className="mx-auto max-w-md py-20 text-center">
        <h1 className="text-xl font-bold">Accès refusé</h1>
        <p className="mt-2 text-muted-foreground">Votre compte n'a pas les droits éditeur.</p>
        <button onClick={logout} className="mt-4 rounded-md bg-secondary px-4 py-2 text-sm">Se déconnecter</button>
      </div>
    );
  }

  const NAV = [
    { to: "/admin", label: "Tableau de bord", icon: LayoutDashboard, exact: true },
    { to: "/admin/articles", label: "Articles", icon: FileText },
    { to: "/admin/articles/new", label: "Nouvel article", icon: Plus },
    { to: "/admin/comments", label: "Commentaires", icon: MessageSquare },
    { to: "/admin/newsletter", label: "Newsletter", icon: Mail },
  ];

  return (
    <div className="mx-auto grid max-w-7xl gap-6 px-4 py-8 lg:grid-cols-[240px_1fr] lg:px-6">
      <aside className="rounded-xl border border-border bg-card p-3">
        <div className="mb-3 px-3 py-2">
          <div className="text-xs uppercase tracking-widest text-muted-foreground">Connecté</div>
          <div className="truncate text-sm font-bold">{session.user.email}</div>
          <div className="mt-1 text-[10px] font-bold uppercase tracking-wider" style={{ color: "var(--togo-green)" }}>
            {isAdmin ? "Administrateur" : "Éditeur"}
          </div>
        </div>
        <nav className="flex flex-col gap-0.5">
          {NAV.map((n) => (
            <Link key={n.to} to={n.to}
              className="flex items-center gap-2 rounded-md px-3 py-2 text-sm font-semibold hover:bg-secondary"
              activeOptions={{ exact: !!n.exact }}
              activeProps={{ className: "flex items-center gap-2 rounded-md px-3 py-2 text-sm font-semibold bg-secondary text-primary" }}
            >
              <n.icon className="h-4 w-4" /> {n.label}
            </Link>
          ))}
          <button onClick={logout} className="mt-2 flex items-center gap-2 rounded-md px-3 py-2 text-left text-sm font-semibold text-destructive hover:bg-destructive/10">
            <LogOut className="h-4 w-4" /> Déconnexion
          </button>
        </nav>
      </aside>
      <section><Outlet /></section>
    </div>
  );
}