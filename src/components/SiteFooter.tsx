import { Link } from "@tanstack/react-router";
import { Facebook, Twitter, Mail, Phone, MapPin, FileBadge2 } from "lucide-react";
import { NewsletterForm } from "./NewsletterForm";
import logo from "@/assets/logo.jpeg";
import logoRepublicain from "@/assets/logo-republicain-infos.jpeg";

export function SiteFooter() {
  return (
    <footer className="mt-16 border-t border-border bg-foreground text-background">
      <div className="h-1 w-full" style={{ background: "var(--gradient-togo)" }} />
      <div className="mx-auto grid max-w-7xl gap-10 px-4 py-12 lg:grid-cols-4 lg:px-6">
        <div>
          <div className="flex items-center gap-3">
            <img src={logo} alt="Communes-Infos.TG" className="h-12 w-12 rounded-full bg-background object-contain p-1" />
            <div className="text-lg font-black" style={{ fontFamily: "var(--font-display)" }}>
              COMMUNES-INFOS.TG
            </div>
          </div>
          <p className="mt-3 text-sm text-background/70">
            Le portail de référence pour l'actualité des communes togolaises.
          </p>

          <div className="mt-5 flex items-center gap-3 border-t border-background/10 pt-5">
            <img src={logoRepublicain} alt="Le Républicain-Infos" className="h-14 w-14 shrink-0 rounded-full bg-background object-contain p-1" />
            <div className="text-xs leading-relaxed text-background/60">
              <div className="flex items-center gap-1.5 font-semibold text-background/80">
                <FileBadge2 className="h-3.5 w-3.5" /> Récépissé N°0135/HAAC/12-2025/PL-P
              </div>
              <div className="mt-1 flex items-center gap-1.5">
                <MapPin className="h-3.5 w-3.5" /> Siège : Lomé — Togo
              </div>
            </div>
          </div>
        </div>

        <div>
          <h4 className="mb-3 text-xs font-bold uppercase tracking-widest text-background/60">Navigation</h4>
          <ul className="space-y-2 text-sm">
            <li><Link to="/" className="hover:text-background/100 text-background/80">Accueil</Link></li>
            <li><Link to="/actualites" className="hover:text-background/100 text-background/80">Actualités</Link></li>
            <li><Link to="/communes" className="hover:text-background/100 text-background/80">Communes</Link></li>
            <li><Link to="/a-propos" className="hover:text-background/100 text-background/80">À propos</Link></li>
            <li><Link to="/contact" className="hover:text-background/100 text-background/80">Contact</Link></li>
          </ul>
        </div>

        <div>
          <h4 className="mb-3 text-xs font-bold uppercase tracking-widest text-background/60">Contact</h4>
          <ul className="space-y-2 text-sm text-background/80">
            <li className="flex items-center gap-2"><Phone className="h-4 w-4" /> 99 73 09 08</li>
            <li className="flex items-center gap-2"><Phone className="h-4 w-4" /> 90 01 91 77</li>
            <li className="flex items-center gap-2"><Mail className="h-4 w-4" /> contact@communes-infos.tg</li>
            <li className="flex items-center gap-2"><MapPin className="h-4 w-4" /> Siège : Lomé — Togo</li>
          </ul>
          <div className="mt-4 flex gap-2">
            <a href="https://facebook.com" target="_blank" rel="noreferrer" className="rounded-full bg-background/10 p-2 hover:bg-background/20"><Facebook className="h-4 w-4" /></a>
            <a href="https://twitter.com" target="_blank" rel="noreferrer" className="rounded-full bg-background/10 p-2 hover:bg-background/20"><Twitter className="h-4 w-4" /></a>
          </div>
        </div>

        <div>
          <h4 className="mb-3 text-xs font-bold uppercase tracking-widest text-background/60">Newsletter</h4>
          <p className="mb-3 text-sm text-background/70">Recevez l'essentiel de l'actualité communale chaque semaine.</p>
          <NewsletterForm compact />
        </div>
      </div>
      <div className="border-t border-background/10">
        <div className="mx-auto flex max-w-7xl flex-col items-center justify-between gap-2 px-4 py-4 text-xs text-background/60 sm:flex-row lg:px-6">
          <div>© {new Date().getFullYear()} Communes-Infos.TG — Tous droits réservés. Récépissé N°0135/HAAC/12-2025/PL-P.</div>
          <div>Fait au Togo</div>
        </div>
      </div>
    </footer>
  );
}