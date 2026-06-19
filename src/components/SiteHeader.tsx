import { Link } from "@tanstack/react-router";
import { Search, Menu, X, Facebook, Twitter } from "lucide-react";
import { useEffect, useState } from "react";
import logo from "@/assets/logo.jpeg";
import { supabase } from "@/integrations/supabase/client";

const NAV = [
  { to: "/", label: "Accueil" },
  { to: "/actualites", label: "Actualités" },
  { to: "/communes", label: "Communes" },
  { to: "/a-propos", label: "À propos" },
  { to: "/contact", label: "Contact" },
];

export function SiteHeader() {
  const [open, setOpen] = useState(false);
  const [isAuthed, setIsAuthed] = useState(false);

  useEffect(() => {
    supabase.auth.getSession().then(({ data }) => setIsAuthed(!!data.session));
    const { data: sub } = supabase.auth.onAuthStateChange((_e, s) => setIsAuthed(!!s));
    return () => sub.subscription.unsubscribe();
  }, []);

  return (
    <header className="sticky top-0 z-40 border-b border-border bg-background/95 backdrop-blur">
      <div className="h-1 w-full" style={{ background: "var(--gradient-togo)" }} />
      <div className="mx-auto flex max-w-7xl items-center justify-between gap-4 px-4 py-3 lg:px-6">
        <Link to="/" className="flex items-center gap-3">
          <img src={logo} alt="Communes-Infos.TG" className="h-12 w-12 rounded-full object-contain" />
          <div className="hidden flex-col leading-tight sm:flex">
            <span className="text-lg font-black tracking-tight text-foreground" style={{ fontFamily: "var(--font-display)" }}>
              COMMUNES-INFOS<span style={{ color: "var(--togo-red)" }}>.TG</span>
            </span>
            <span className="text-[11px] uppercase tracking-widest text-muted-foreground">L'actualité des communes du Togo</span>
          </div>
        </Link>

        <nav className="hidden items-center gap-1 lg:flex">
          {NAV.map((n) => (
            <Link
              key={n.to}
              to={n.to}
              className="rounded-md px-3 py-2 text-sm font-semibold text-foreground transition-colors hover:bg-secondary hover:text-primary"
              activeProps={{ className: "rounded-md px-3 py-2 text-sm font-semibold text-primary bg-secondary" }}
            >
              {n.label}
            </Link>
          ))}
        </nav>

        <div className="flex items-center gap-2">
          <Link to="/actualites" className="hidden rounded-md p-2 text-muted-foreground hover:bg-secondary hover:text-foreground sm:inline-flex">
            <Search className="h-5 w-5" />
          </Link>
          <a href="https://facebook.com" target="_blank" rel="noreferrer" className="hidden rounded-md p-2 text-muted-foreground hover:bg-secondary hover:text-foreground sm:inline-flex">
            <Facebook className="h-5 w-5" />
          </a>
          <a href="https://twitter.com" target="_blank" rel="noreferrer" className="hidden rounded-md p-2 text-muted-foreground hover:bg-secondary hover:text-foreground sm:inline-flex">
            <Twitter className="h-5 w-5" />
          </a>
          <Link
            to={isAuthed ? "/admin" : "/auth"}
            className="hidden rounded-md px-3 py-2 text-sm font-semibold text-primary-foreground transition-opacity hover:opacity-90 lg:inline-flex"
            style={{ background: "var(--gradient-hero)" }}
          >
            {isAuthed ? "Admin" : "Connexion"}
          </Link>
          <button
            onClick={() => setOpen((v) => !v)}
            className="rounded-md p-2 text-foreground hover:bg-secondary lg:hidden"
            aria-label="Menu"
          >
            {open ? <X className="h-5 w-5" /> : <Menu className="h-5 w-5" />}
          </button>
        </div>
      </div>

      {open && (
        <div className="border-t border-border bg-background lg:hidden">
          <nav className="mx-auto flex max-w-7xl flex-col gap-1 px-4 py-3">
            {NAV.map((n) => (
              <Link key={n.to} to={n.to} onClick={() => setOpen(false)} className="rounded-md px-3 py-2 text-sm font-semibold hover:bg-secondary">
                {n.label}
              </Link>
            ))}
            <Link to={isAuthed ? "/admin" : "/auth"} onClick={() => setOpen(false)} className="rounded-md px-3 py-2 text-sm font-semibold text-primary">
              {isAuthed ? "Espace admin" : "Connexion / Admin"}
            </Link>
          </nav>
        </div>
      )}
    </header>
  );
}