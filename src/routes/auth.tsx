import { createFileRoute, useNavigate } from "@tanstack/react-router";
import { useState, useEffect } from "react";
import { supabase } from "@/integrations/supabase/client";
import { toast } from "sonner";
import logo from "@/assets/logo.jpeg";

export const Route = createFileRoute("/auth")({
  head: () => ({ meta: [{ title: "Connexion — Communes-Infos.TG" }] }),
  component: AuthPage,
});

function AuthPage() {
  const nav = useNavigate();
  const [mode, setMode] = useState<"signin" | "signup">("signin");
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [name, setName] = useState("");
  const [loading, setLoading] = useState(false);

  useEffect(() => {
    supabase.auth.getSession().then(({ data }) => { if (data.session) nav({ to: "/admin" }); });
  }, [nav]);

  async function submit(e: React.FormEvent) {
    e.preventDefault();
    setLoading(true);
    try {
      if (mode === "signup") {
        const { error } = await supabase.auth.signUp({
          email, password,
          options: { data: { display_name: name }, emailRedirectTo: `${window.location.origin}/admin` },
        });
        if (error) throw error;
        toast.success("Compte créé. Vous êtes connecté(e).");
        nav({ to: "/admin" });
      } else {
        const { error } = await supabase.auth.signInWithPassword({ email, password });
        if (error) throw error;
        nav({ to: "/admin" });
      }
    } catch (err: any) {
      toast.error(err.message ?? "Erreur");
    } finally {
      setLoading(false);
    }
  }

  return (
    <div className="mx-auto flex min-h-[80vh] max-w-md flex-col items-center justify-center px-4 py-12">
      <img src={logo} alt="" className="h-16 w-16 rounded-full object-contain" />
      <h1 className="mt-4 text-2xl font-black" style={{ fontFamily: "var(--font-display)" }}>
        {mode === "signin" ? "Connexion" : "Créer un compte"}
      </h1>
      <p className="mt-1 text-sm text-muted-foreground">Espace réservé à la rédaction</p>
      <form onSubmit={submit} className="mt-6 w-full space-y-3 rounded-xl border border-border bg-card p-5">
        {mode === "signup" && (
          <input value={name} onChange={(e) => setName(e.target.value)} placeholder="Nom d'affichage" required className="w-full rounded-md border border-input bg-background px-3 py-2 text-sm" />
        )}
        <input type="email" value={email} onChange={(e) => setEmail(e.target.value)} placeholder="Email" required className="w-full rounded-md border border-input bg-background px-3 py-2 text-sm" />
        <input type="password" value={password} onChange={(e) => setPassword(e.target.value)} placeholder="Mot de passe (min. 6 caractères)" required minLength={6} className="w-full rounded-md border border-input bg-background px-3 py-2 text-sm" />
        <button type="submit" disabled={loading} className="w-full rounded-md py-2 text-sm font-bold text-primary-foreground transition-opacity hover:opacity-90 disabled:opacity-50" style={{ background: "var(--gradient-hero)" }}>
          {loading ? "..." : mode === "signin" ? "Se connecter" : "Créer mon compte"}
        </button>
        <button type="button" onClick={() => setMode(mode === "signin" ? "signup" : "signin")} className="w-full text-center text-xs text-muted-foreground hover:text-foreground">
          {mode === "signin" ? "Pas encore de compte ? S'inscrire" : "Déjà un compte ? Se connecter"}
        </button>
      </form>
      <p className="mt-4 text-center text-xs text-muted-foreground">
        Le premier compte créé devient automatiquement administrateur.
      </p>
    </div>
  );
}