import { createFileRoute } from "@tanstack/react-router";
import { Mail, Phone, MapPin, Clock, Send } from "lucide-react";
import { useState } from "react";
import { toast } from "sonner";

export const Route = createFileRoute("/contact")({
  head: () => ({
    meta: [
      { title: "Contact — Communes-Infos.TG" },
      { name: "description", content: "Contactez la rédaction de Communes-Infos.TG par téléphone, email ou via notre formulaire de contact." },
    ],
  }),
  component: ContactPage,
});

function ContactPage() {
  const [form, setForm] = useState({ name: "", email: "", subject: "", message: "" });
  const [sending, setSending] = useState(false);

  function handleChange(e: React.ChangeEvent<HTMLInputElement | HTMLTextAreaElement | HTMLSelectElement>) {
    setForm((prev) => ({ ...prev, [e.target.name]: e.target.value }));
  }

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault();
    if (!form.name || !form.email || !form.message) {
      toast.error("Veuillez remplir tous les champs obligatoires.");
      return;
    }
    setSending(true);
    await new Promise((r) => setTimeout(r, 800));
    setSending(false);
    toast.success("Message envoyé ! Nous vous répondrons sous 48h.");
    setForm({ name: "", email: "", subject: "", message: "" });
  }

  return (
    <div>
      {/* Header */}
      <section className="py-14" style={{ background: "var(--gradient-hero)" }}>
        <div className="mx-auto max-w-4xl px-4 text-center lg:px-6">
          <h1 className="text-4xl font-black text-primary-foreground" style={{ fontFamily: "var(--font-display)" }}>Contactez-nous</h1>
          <p className="mt-3 text-primary-foreground/80">Une information à partager ? Une question ? Notre équipe vous répond.</p>
        </div>
      </section>

      <div className="mx-auto max-w-5xl px-4 py-12 lg:px-6">
        <div className="grid gap-10 lg:grid-cols-5">

          {/* Infos de contact */}
          <div className="space-y-5 lg:col-span-2">
            <h2 className="text-xl font-black text-foreground" style={{ fontFamily: "var(--font-display)" }}>Nos coordonnées</h2>
            {[
              {
                icon: Phone,
                label: "Téléphone",
                value: "+228 90 01 91 77",
                href: "tel:+22890019177",
              },
              {
                icon: Mail,
                label: "Email rédaction",
                value: "contact@communes-infos.tg",
                href: "mailto:contact@communes-infos.tg",
              },
              {
                icon: MapPin,
                label: "Adresse",
                value: "Lomé, Togo",
                href: undefined,
              },
              {
                icon: Clock,
                label: "Horaires",
                value: "Lun – Ven, 8h – 18h",
                href: undefined,
              },
            ].map(({ icon: Icon, label, value, href }) => (
              <div key={label} className="flex items-start gap-4 rounded-xl border border-border bg-card p-5">
                <div className="flex h-10 w-10 flex-shrink-0 items-center justify-center rounded-lg" style={{ background: "var(--gradient-hero)" }}>
                  <Icon className="h-5 w-5 text-primary-foreground" />
                </div>
                <div>
                  <div className="text-xs font-bold uppercase tracking-wider text-muted-foreground">{label}</div>
                  {href ? (
                    <a href={href} className="mt-0.5 font-bold text-foreground hover:text-primary">{value}</a>
                  ) : (
                    <div className="mt-0.5 font-bold text-foreground">{value}</div>
                  )}
                </div>
              </div>
            ))}

            <div className="rounded-xl border border-border bg-secondary/30 p-5">
              <p className="text-sm text-muted-foreground leading-relaxed">
                Vous êtes journaliste, élu local ou acteur associatif ? Nous cherchons des correspondants locaux dans toutes les régions du Togo.
                <a href="mailto:redaction@communes-infos.tg" className="ml-1 font-bold text-primary hover:underline">Écrivez-nous.</a>
              </p>
            </div>
          </div>

          {/* Formulaire */}
          <div className="lg:col-span-3">
            <h2 className="text-xl font-black text-foreground" style={{ fontFamily: "var(--font-display)" }}>Envoyer un message</h2>
            <form onSubmit={handleSubmit} className="mt-5 space-y-4">
              <div className="grid gap-4 sm:grid-cols-2">
                <div className="flex flex-col gap-1.5">
                  <label className="text-xs font-bold uppercase tracking-wider text-muted-foreground">Nom complet <span className="text-destructive">*</span></label>
                  <input
                    name="name"
                    value={form.name}
                    onChange={handleChange}
                    placeholder="Votre nom"
                    required
                    className="rounded-lg border border-input bg-background px-3.5 py-2.5 text-sm focus:outline-none focus:ring-2 focus:ring-primary"
                  />
                </div>
                <div className="flex flex-col gap-1.5">
                  <label className="text-xs font-bold uppercase tracking-wider text-muted-foreground">Email <span className="text-destructive">*</span></label>
                  <input
                    type="email"
                    name="email"
                    value={form.email}
                    onChange={handleChange}
                    placeholder="votre@email.com"
                    required
                    className="rounded-lg border border-input bg-background px-3.5 py-2.5 text-sm focus:outline-none focus:ring-2 focus:ring-primary"
                  />
                </div>
              </div>

              <div className="flex flex-col gap-1.5">
                <label className="text-xs font-bold uppercase tracking-wider text-muted-foreground">Objet</label>
                <select
                  name="subject"
                  value={form.subject}
                  onChange={handleChange}
                  className="rounded-lg border border-input bg-background px-3.5 py-2.5 text-sm focus:outline-none focus:ring-2 focus:ring-primary"
                >
                  <option value="">Sélectionner un objet…</option>
                  <option value="information">Signalement d'une information</option>
                  <option value="correction">Demande de correction</option>
                  <option value="partenariat">Proposition de partenariat</option>
                  <option value="correspondant">Devenir correspondant local</option>
                  <option value="autre">Autre</option>
                </select>
              </div>

              <div className="flex flex-col gap-1.5">
                <label className="text-xs font-bold uppercase tracking-wider text-muted-foreground">Message <span className="text-destructive">*</span></label>
                <textarea
                  name="message"
                  value={form.message}
                  onChange={handleChange}
                  placeholder="Décrivez votre demande…"
                  required
                  rows={6}
                  className="resize-none rounded-lg border border-input bg-background px-3.5 py-2.5 text-sm focus:outline-none focus:ring-2 focus:ring-primary"
                />
              </div>

              <button
                type="submit"
                disabled={sending}
                className="flex w-full items-center justify-center gap-2 rounded-lg py-3 text-sm font-bold text-primary-foreground transition-opacity hover:opacity-90 disabled:opacity-60"
                style={{ background: "var(--gradient-hero)" }}
              >
                <Send className="h-4 w-4" />
                {sending ? "Envoi en cours…" : "Envoyer le message"}
              </button>
            </form>
          </div>
        </div>
      </div>
    </div>
  );
}
