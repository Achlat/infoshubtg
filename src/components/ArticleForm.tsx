import { useState, useEffect } from "react";
import { supabase } from "@/integrations/supabase/client";
import { toast } from "sonner";
import { slugify } from "@/lib/types";
import type { Category, Commune } from "@/lib/types";
import { useNavigate } from "@tanstack/react-router";
import { Upload, X } from "lucide-react";

export function ArticleForm({ initial }: { initial?: any }) {
  const nav = useNavigate();
  const [title, setTitle] = useState(initial?.title ?? "");
  const [slug, setSlug] = useState(initial?.slug ?? "");
  const [excerpt, setExcerpt] = useState(initial?.excerpt ?? "");
  const [content, setContent] = useState(initial?.content ?? "");
  const [categoryId, setCategoryId] = useState(initial?.category_id ?? "");
  const [communeId, setCommuneId] = useState(initial?.commune_id ?? "");
  const [tags, setTags] = useState((initial?.tags ?? []).join(", "));
  const [cover, setCover] = useState<string | null>(initial?.cover_image ?? null);
  const [featured, setFeatured] = useState<boolean>(initial?.featured ?? false);
  const [status, setStatus] = useState<"draft" | "published">(initial?.status ?? "draft");
  const [uploading, setUploading] = useState(false);
  const [saving, setSaving] = useState(false);
  const [cats, setCats] = useState<Category[]>([]);
  const [coms, setComs] = useState<Commune[]>([]);

  useEffect(() => {
    supabase.from("categories").select("*").order("name").then(({ data }) => setCats((data ?? []) as Category[]));
    supabase.from("communes").select("*").order("name").then(({ data }) => setComs((data ?? []) as Commune[]));
  }, []);

  useEffect(() => {
    if (!initial && title) setSlug(slugify(title));
  }, [title, initial]);

  async function uploadCover(file: File) {
    setUploading(true);
    const ext = file.name.split(".").pop();
    const path = `${Date.now()}-${Math.random().toString(36).slice(2, 8)}.${ext}`;
    const { error } = await supabase.storage.from("article-images").upload(path, file);
    if (error) { toast.error(error.message); setUploading(false); return; }
    const { data } = supabase.storage.from("article-images").getPublicUrl(path);
    setCover(data.publicUrl);
    setUploading(false);
    toast.success("Image téléversée");
  }

  async function save(publish?: boolean) {
    if (!title.trim() || !content.trim()) { toast.error("Titre et contenu requis."); return; }
    setSaving(true);
    const finalStatus = publish ? "published" : status;
    const { data: { user } } = await supabase.auth.getUser();
    const payload = {
      title: title.trim(),
      slug: (slug || slugify(title)).trim(),
      excerpt: excerpt.trim() || null,
      content,
      cover_image: cover,
      category_id: categoryId || null,
      commune_id: communeId || null,
      tags: tags.split(",").map((t: string) => t.trim()).filter(Boolean),
      featured,
      status: finalStatus,
      published_at: finalStatus === "published" ? (initial?.published_at || new Date().toISOString()) : null,
      author_id: user?.id,
    };
    const res = initial
      ? await supabase.from("articles").update(payload).eq("id", initial.id)
      : await supabase.from("articles").insert(payload);
    setSaving(false);
    if (res.error) { toast.error(res.error.message); return; }
    toast.success(initial ? "Article mis à jour" : "Article créé");
    nav({ to: "/admin/articles" });
  }

  return (
    <div className="space-y-5">
      <div className="grid gap-4 lg:grid-cols-[1fr_320px]">
        <div className="space-y-4">
          <div>
            <label className="text-xs font-bold uppercase tracking-wider text-muted-foreground">Titre *</label>
            <input value={title} onChange={(e) => setTitle(e.target.value)} className="mt-1 w-full rounded-md border border-input bg-background px-3 py-2 text-lg font-bold" placeholder="Titre de l'article" />
          </div>
          <div>
            <label className="text-xs font-bold uppercase tracking-wider text-muted-foreground">Slug (URL)</label>
            <input value={slug} onChange={(e) => setSlug(e.target.value)} className="mt-1 w-full rounded-md border border-input bg-background px-3 py-2 text-sm" />
          </div>
          <div>
            <label className="text-xs font-bold uppercase tracking-wider text-muted-foreground">Chapeau / Résumé</label>
            <textarea value={excerpt} onChange={(e) => setExcerpt(e.target.value)} rows={3} className="mt-1 w-full rounded-md border border-input bg-background px-3 py-2 text-sm" placeholder="Résumé en 2-3 phrases" />
          </div>
          <div>
            <label className="text-xs font-bold uppercase tracking-wider text-muted-foreground">Contenu *</label>
            <textarea value={content} onChange={(e) => setContent(e.target.value)} rows={20} className="mt-1 w-full rounded-md border border-input bg-background px-3 py-2 text-sm leading-relaxed" placeholder="Rédigez votre article ici..." />
            <p className="mt-1 text-[11px] text-muted-foreground">Astuce : laissez des lignes vides entre les paragraphes.</p>
          </div>
          <div>
            <label className="text-xs font-bold uppercase tracking-wider text-muted-foreground">Tags (séparés par des virgules)</label>
            <input value={tags} onChange={(e) => setTags(e.target.value)} className="mt-1 w-full rounded-md border border-input bg-background px-3 py-2 text-sm" placeholder="ex: décentralisation, jeunesse, infrastructure" />
          </div>
        </div>

        <aside className="space-y-4">
          <div className="rounded-xl border border-border bg-card p-4">
            <label className="text-xs font-bold uppercase tracking-wider text-muted-foreground">Image principale</label>
            {cover ? (
              <div className="relative mt-2">
                <img src={cover} alt="" className="aspect-[16/9] w-full rounded-md object-cover" />
                <button onClick={() => setCover(null)} className="absolute right-2 top-2 rounded-full bg-background/90 p-1.5"><X className="h-4 w-4" /></button>
              </div>
            ) : (
              <label className="mt-2 flex aspect-[16/9] cursor-pointer flex-col items-center justify-center gap-2 rounded-md border-2 border-dashed border-border bg-background text-sm text-muted-foreground hover:border-primary">
                {uploading ? "Téléversement..." : (<><Upload className="h-5 w-5" /><span>Téléverser une image</span></>)}
                <input type="file" accept="image/*" className="hidden" onChange={(e) => { const f = e.target.files?.[0]; if (f) uploadCover(f); }} />
              </label>
            )}
          </div>

          <div className="rounded-xl border border-border bg-card p-4">
            <label className="text-xs font-bold uppercase tracking-wider text-muted-foreground">Catégorie</label>
            <select value={categoryId} onChange={(e) => setCategoryId(e.target.value)} className="mt-1 w-full rounded-md border border-input bg-background px-3 py-2 text-sm">
              <option value="">— Choisir —</option>
              {cats.map((c) => <option key={c.id} value={c.id}>{c.name}</option>)}
            </select>

            <label className="mt-4 block text-xs font-bold uppercase tracking-wider text-muted-foreground">Commune</label>
            <select value={communeId} onChange={(e) => setCommuneId(e.target.value)} className="mt-1 w-full rounded-md border border-input bg-background px-3 py-2 text-sm">
              <option value="">— Choisir —</option>
              {coms.map((c) => <option key={c.id} value={c.id}>{c.name} ({c.region})</option>)}
            </select>

            <label className="mt-4 flex items-center gap-2 text-sm">
              <input type="checkbox" checked={featured} onChange={(e) => setFeatured(e.target.checked)} />
              À la une
            </label>
          </div>

          <div className="space-y-2 rounded-xl border border-border bg-card p-4">
            <button onClick={() => save(true)} disabled={saving} className="w-full rounded-md py-2.5 text-sm font-bold text-primary-foreground transition-opacity hover:opacity-90 disabled:opacity-50" style={{ background: "var(--gradient-hero)" }}>
              {saving ? "..." : "Publier"}
            </button>
            <button onClick={() => { setStatus("draft"); save(false); }} disabled={saving} className="w-full rounded-md bg-secondary py-2 text-sm font-bold hover:bg-secondary/80 disabled:opacity-50">
              Enregistrer en brouillon
            </button>
          </div>
        </aside>
      </div>
    </div>
  );
}