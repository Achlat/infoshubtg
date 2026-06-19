import { useState } from "react";
import { supabase } from "@/integrations/supabase/client";
import { toast } from "sonner";

export function NewsletterForm({ compact = false }: { compact?: boolean }) {
  const [email, setEmail] = useState("");
  const [name, setName] = useState("");
  const [loading, setLoading] = useState(false);

  async function onSubmit(e: React.FormEvent) {
    e.preventDefault();
    setLoading(true);
    const { error } = await supabase.from("newsletter_subscribers").insert({ email, first_name: name || null });
    setLoading(false);
    if (error) {
      toast.error(error.code === "23505" ? "Cet email est déjà inscrit." : "Erreur lors de l'inscription.");
    } else {
      toast.success("Merci ! Vous êtes bien inscrit(e).");
      setEmail(""); setName("");
    }
  }

  return (
    <form onSubmit={onSubmit} className="space-y-2">
      {!compact && (
        <input
          value={name} onChange={(e) => setName(e.target.value)}
          placeholder="Prénom"
          className="w-full rounded-md border border-input bg-card px-3 py-2 text-sm text-foreground placeholder:text-muted-foreground"
        />
      )}
      <input
        type="email" required value={email} onChange={(e) => setEmail(e.target.value)}
        placeholder="votre@email.com"
        className={compact
          ? "w-full rounded-md border border-background/20 bg-background/10 px-3 py-2 text-sm text-background placeholder:text-background/40"
          : "w-full rounded-md border border-input bg-card px-3 py-2 text-sm text-foreground placeholder:text-muted-foreground"}
      />
      <button
        type="submit" disabled={loading}
        className="w-full rounded-md px-3 py-2 text-sm font-bold text-primary-foreground transition-opacity hover:opacity-90 disabled:opacity-50"
        style={{ background: "var(--gradient-hero)" }}
      >
        {loading ? "..." : "S'inscrire"}
      </button>
    </form>
  );
}