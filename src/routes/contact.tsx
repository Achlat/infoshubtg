import { createFileRoute } from "@tanstack/react-router";
import { Mail, Phone } from "lucide-react";

export const Route = createFileRoute("/contact")({
  head: () => ({
    meta: [
      { title: "Contact — Communes-Infos.TG" },
      { name: "description", content: "Contactez la rédaction de Communes-Infos.TG par téléphone ou par email." },
    ],
  }),
  component: () => (
    <div className="mx-auto max-w-3xl px-4 py-12 lg:px-6">
      <h1 className="text-4xl font-black" style={{ fontFamily: "var(--font-display)" }}>Contact</h1>
      <p className="mt-2 text-muted-foreground">Une information à partager ? Une question ? Notre équipe vous répond.</p>
      <div className="mt-8 grid gap-4 sm:grid-cols-2">
        <a href="tel:+22890019177" className="flex items-center gap-3 rounded-xl border border-border bg-card p-5 hover:bg-secondary">
          <Phone className="h-6 w-6 text-primary" />
          <div>
            <div className="text-xs uppercase tracking-wider text-muted-foreground">Téléphone</div>
            <div className="font-bold">+228 90 01 91 77</div>
          </div>
        </a>
        <a href="mailto:contact@communes-infos.tg" className="flex items-center gap-3 rounded-xl border border-border bg-card p-5 hover:bg-secondary">
          <Mail className="h-6 w-6 text-primary" />
          <div>
            <div className="text-xs uppercase tracking-wider text-muted-foreground">Email</div>
            <div className="font-bold">contact@communes-infos.tg</div>
          </div>
        </a>
      </div>
    </div>
  ),
});