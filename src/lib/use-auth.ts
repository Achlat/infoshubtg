import { useEffect, useState, useCallback } from "react";
import { api, getToken, setToken } from "@/lib/api";

export function useAuth() {
  const [session, setSession] = useState<{ user: { id: string; email: string } } | null>(null);
  const [roles, setRoles] = useState<string[]>([]);
  const [loading, setLoading] = useState(true);

  const load = useCallback(async () => {
    const token = getToken();
    if (!token) { setSession(null); setRoles([]); setLoading(false); return; }
    try {
      const { user, roles } = await api.auth.me();
      setSession({ user });
      setRoles(roles);
    } catch {
      setToken(null);
      setSession(null);
      setRoles([]);
    } finally {
      setLoading(false);
    }
  }, []);

  useEffect(() => {
    load();
    window.addEventListener("auth-changed", load);
    return () => window.removeEventListener("auth-changed", load);
  }, [load]);

  return {
    session,
    roles,
    loading,
    isAdmin: roles.includes("admin"),
    isEditor: roles.includes("admin") || roles.includes("editor"),
    reloadRoles: load,
  };
}
