export type Category = {
  id: string;
  slug: string;
  name: string;
  color: string;
  description: string | null;
};

export type Commune = {
  id: string;
  slug: string;
  name: string;
  region: string;
  prefecture: string | null;
  chef_lieu: string | null;
};

export type Article = {
  id: string;
  slug: string;
  title: string;
  excerpt: string | null;
  content: string;
  cover_image: string | null;
  category_id: string | null;
  commune_id: string | null;
  author_id: string | null;
  tags: string[];
  status: "draft" | "published";
  featured: boolean;
  views: number;
  published_at: string | null;
  created_at: string;
  updated_at: string;
  category?: Category | null;
  commune?: Commune | null;
};

export function slugify(str: string): string {
  return str
    .toLowerCase()
    .normalize("NFD").replace(/[\u0300-\u036f]/g, "")
    .replace(/[^a-z0-9]+/g, "-")
    .replace(/(^-|-$)/g, "")
    .slice(0, 80);
}

export function formatDate(iso: string | null): string {
  if (!iso) return "";
  return new Date(iso).toLocaleDateString("fr-FR", { day: "numeric", month: "long", year: "numeric" });
}