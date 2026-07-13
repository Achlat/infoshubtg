const BASE = 'http://localhost/togo-api/api.php';
const TOKEN_KEY = 'ci_token';

export function getToken(): string | null {
  if (typeof window === 'undefined') return null;
  return localStorage.getItem(TOKEN_KEY);
}

export function setToken(token: string | null) {
  if (typeof window === 'undefined') return;
  if (token) localStorage.setItem(TOKEN_KEY, token); else localStorage.removeItem(TOKEN_KEY);
  window.dispatchEvent(new Event('auth-changed'));
}

function authHeaders(): Record<string, string> {
  const token = getToken();
  return token ? { Authorization: `Bearer ${token}` } : {};
}

async function get<T>(endpoint: string, params: Record<string, string | number> = {}, auth = false): Promise<T> {
  const url = new URL(BASE);
  url.searchParams.set('endpoint', endpoint);
  for (const [k, v] of Object.entries(params)) {
    if (v !== undefined && v !== '') url.searchParams.set(k, String(v));
  }
  const res = await fetch(url.toString(), { headers: auth ? authHeaders() : undefined });
  const data = await res.json();
  if (!res.ok) throw new Error(data?.error || 'Erreur serveur');
  return data;
}

async function post<T>(endpoint: string, body: unknown, auth = false): Promise<T> {
  const url = new URL(BASE);
  url.searchParams.set('endpoint', endpoint);
  const res = await fetch(url.toString(), {
    method: 'POST',
    headers: { 'Content-Type': 'application/json', ...(auth ? authHeaders() : {}) },
    body: JSON.stringify(body),
  });
  const data = await res.json();
  if (!res.ok) throw new Error(data?.error || 'Erreur serveur');
  return data;
}

export const api = {
  articles: {
    list: (p?: { featured?: boolean; category_id?: string; commune_id?: string; search?: string; limit?: number; exclude_id?: string }) =>
      get<any[]>('articles', {
        ...(p?.featured    ? { featured:     1             } : {}),
        ...(p?.category_id ? { category_id:  p.category_id } : {}),
        ...(p?.commune_id  ? { commune_id:   p.commune_id  } : {}),
        ...(p?.search      ? { search:       p.search      } : {}),
        ...(p?.limit       ? { limit:        p.limit       } : {}),
        ...(p?.exclude_id  ? { exclude_id:   p.exclude_id  } : {}),
      }),
    bySlug: (slug: string) => get<any>('articles', { slug }),
  },
  categories: {
    list: () => get<any[]>('categories'),
    bySlug: (slug: string) => get<any>('categories', { slug }),
  },
  communes: {
    list: () => get<any[]>('communes'),
    bySlug: (slug: string) => get<any>('communes', { slug }),
  },
  newsletter: {
    subscribe: (email: string, first_name?: string) =>
      post<{ success?: boolean; error?: string }>('newsletter', { email, first_name }),
  },

  auth: {
    me: () => get<{ user: { id: string; email: string }; roles: string[] }>('auth', { action: 'me' }, true),
    register: (email: string, password: string, display_name?: string) =>
      post<{ token: string; user: { id: string; email: string }; roles: string[] }>('auth', { action: 'register', email, password, display_name }),
    login: (email: string, password: string) =>
      post<{ token: string; user: { id: string; email: string }; roles: string[] }>('auth', { action: 'login', email, password }),
    logout: () => post<{ success: boolean }>('auth', { action: 'logout' }, true),
    claimFirstAdmin: () => post<{ claimed: boolean }>('auth', { action: 'claim_first_admin' }, true),
  },

  upload: async (file: File): Promise<{ url: string; kind: 'image' | 'video' }> => {
    const url = new URL(BASE);
    url.searchParams.set('endpoint', 'upload');
    const form = new FormData();
    form.append('file', file);
    const res = await fetch(url.toString(), { method: 'POST', headers: authHeaders(), body: form });
    const data = await res.json();
    if (!res.ok) throw new Error(data?.error || 'Échec du téléversement');
    return data;
  },

  adminArticles: {
    list: () => get<any[]>('admin_articles', {}, true),
    get: (id: string) => get<any>('admin_articles', { id }, true),
    create: (payload: Record<string, unknown>) => post<{ id: string; success: boolean }>('admin_articles', { action: 'create', ...payload }, true),
    update: (id: string, payload: Record<string, unknown>) => post<{ success: boolean }>('admin_articles', { action: 'update', id, ...payload }, true),
    delete: (id: string) => post<{ success: boolean }>('admin_articles', { action: 'delete', id }, true),
  },

  adminComments: {
    list: () => get<any[]>('admin_comments', {}, true),
    approve: (id: string) => post<{ success: boolean }>('admin_comments', { action: 'approve', id }, true),
    delete: (id: string) => post<{ success: boolean }>('admin_comments', { action: 'delete', id }, true),
  },

  adminNewsletter: {
    list: () => get<any[]>('admin_newsletter', {}, true),
  },

  adminStats: {
    get: () => get<{ total: number; published: number; pendingComments: number; subs: number }>('admin_stats', {}, true),
  },
};
