import { supabase } from "@/integrations/supabase/client";
import type { TablesInsert, TablesUpdate } from "@/integrations/supabase/types";

const ARTICLE_SELECT = "*, category:categories(*), commune:communes(*)";

function escapeIlike(term: string) {
  return term.replace(/[%,_()]/g, " ").trim();
}

export const api = {
  articles: {
    list: async (p?: {
      featured?: boolean;
      category_id?: string;
      commune_id?: string;
      search?: string;
      limit?: number;
      exclude_id?: string;
    }) => {
      let q = supabase
        .from("articles")
        .select(ARTICLE_SELECT)
        .eq("status", "published")
        .order("published_at", { ascending: false });
      if (p?.featured) q = q.eq("featured", true);
      if (p?.category_id) q = q.eq("category_id", p.category_id);
      if (p?.commune_id) q = q.eq("commune_id", p.commune_id);
      if (p?.exclude_id) q = q.neq("id", p.exclude_id);
      if (p?.search) {
        const term = escapeIlike(p.search);
        if (term) q = q.or(`title.ilike.%${term}%,excerpt.ilike.%${term}%`);
      }
      if (p?.limit !== undefined) q = q.limit(p.limit);
      const { data, error } = await q;
      if (error) throw new Error(error.message);
      return data;
    },
    bySlug: async (slug: string) => {
      const { data, error } = await supabase.from("articles").select(ARTICLE_SELECT).eq("slug", slug).maybeSingle();
      if (error) throw new Error(error.message);
      if (!data) throw new Error("Article introuvable");
      return data;
    },
  },
  categories: {
    list: async () => {
      const { data, error } = await supabase.from("categories").select("*").order("name");
      if (error) throw new Error(error.message);
      return data;
    },
    bySlug: async (slug: string) => {
      const { data, error } = await supabase.from("categories").select("*").eq("slug", slug).maybeSingle();
      if (error) throw new Error(error.message);
      if (!data) throw new Error("Catégorie introuvable");
      return data;
    },
  },
  communes: {
    list: async () => {
      const { data, error } = await supabase.from("communes").select("*").order("name");
      if (error) throw new Error(error.message);
      return data;
    },
    bySlug: async (slug: string) => {
      const { data, error } = await supabase.from("communes").select("*").eq("slug", slug).maybeSingle();
      if (error) throw new Error(error.message);
      if (!data) throw new Error("Commune introuvable");
      return data;
    },
  },
  newsletter: {
    subscribe: async (email: string, first_name?: string) => {
      const { error } = await supabase.from("newsletter_subscribers").insert({ email, first_name });
      if (error) {
        if (error.code === "23505") return { error: "already_subscribed" };
        return { error: error.message };
      }
      return { success: true };
    },
  },

  upload: async (file: File): Promise<{ url: string; kind: "image" | "video" }> => {
    const kind: "image" | "video" = file.type.startsWith("video/") ? "video" : "image";
    const ext = file.name.includes(".") ? file.name.slice(file.name.lastIndexOf(".")) : "";
    const path = `${Date.now()}-${Math.random().toString(36).slice(2)}${ext}`;
    const { error } = await supabase.storage.from("article-images").upload(path, file);
    if (error) throw new Error(error.message || "Échec du téléversement");
    const { data } = supabase.storage.from("article-images").getPublicUrl(path);
    return { url: data.publicUrl, kind };
  },

  adminArticles: {
    list: async () => {
      const { data, error } = await supabase
        .from("articles")
        .select(ARTICLE_SELECT)
        .order("created_at", { ascending: false });
      if (error) throw new Error(error.message);
      return data;
    },
    get: async (id: string) => {
      const { data, error } = await supabase.from("articles").select(ARTICLE_SELECT).eq("id", id).maybeSingle();
      if (error) throw new Error(error.message);
      if (!data) throw new Error("Article introuvable");
      return data;
    },
    create: async (payload: TablesInsert<"articles">) => {
      const { data: userData, error: userError } = await supabase.auth.getUser();
      if (userError) throw new Error(userError.message);
      const { data, error } = await supabase
        .from("articles")
        .insert({ ...payload, author_id: userData.user?.id })
        .select("id")
        .single();
      if (error) throw new Error(error.message);
      return { id: data.id, success: true };
    },
    update: async (id: string, payload: TablesUpdate<"articles">) => {
      const { error } = await supabase.from("articles").update(payload).eq("id", id);
      if (error) throw new Error(error.message);
      return { success: true };
    },
    delete: async (id: string) => {
      const { error, count } = await supabase
        .from("articles")
        .delete({ count: "exact" })
        .eq("id", id);
      if (error) throw new Error(error.message);
      if (!count) throw new Error("Suppression refusée : droits insuffisants ou article introuvable.");
      return { success: true };
    },
  },

  adminComments: {
    list: async () => {
      const { data, error } = await supabase
        .from("comments")
        .select("*, article:articles(title)")
        .order("created_at", { ascending: false });
      if (error) throw new Error(error.message);
      return data;
    },
    approve: async (id: string) => {
      const { error } = await supabase.from("comments").update({ approved: true }).eq("id", id);
      if (error) throw new Error(error.message);
      return { success: true };
    },
    delete: async (id: string) => {
      const { error } = await supabase.from("comments").delete().eq("id", id);
      if (error) throw new Error(error.message);
      return { success: true };
    },
  },

  adminNewsletter: {
    list: async () => {
      const { data, error } = await supabase
        .from("newsletter_subscribers")
        .select("*")
        .order("created_at", { ascending: false });
      if (error) throw new Error(error.message);
      return data;
    },
  },

  adminStats: {
    get: async () => {
      const [total, published, pendingComments, subs] = await Promise.all([
        supabase.from("articles").select("*", { count: "exact", head: true }),
        supabase.from("articles").select("*", { count: "exact", head: true }).eq("status", "published"),
        supabase.from("comments").select("*", { count: "exact", head: true }).eq("approved", false),
        supabase.from("newsletter_subscribers").select("*", { count: "exact", head: true }),
      ]);
      return {
        total: total.count ?? 0,
        published: published.count ?? 0,
        pendingComments: pendingComments.count ?? 0,
        subs: subs.count ?? 0,
      };
    },
  },
};
