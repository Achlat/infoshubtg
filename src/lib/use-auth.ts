import { useEffect, useState } from "react";
import { supabase } from "@/integrations/supabase/client";

export function useAuth() {
  const [session, setSession] = useState<any>(null);
  const [roles, setRoles] = useState<string[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    let mounted = true;
    const init = async () => {
      const { data } = await supabase.auth.getSession();
      if (!mounted) return;
      setSession(data.session);
      if (data.session) await loadRoles(data.session.user.id);
      setLoading(false);
    };
    init();
    const { data: sub } = supabase.auth.onAuthStateChange(async (_e, s) => {
      setSession(s);
      if (s) await loadRoles(s.user.id); else setRoles([]);
    });
    return () => { mounted = false; sub.subscription.unsubscribe(); };
  }, []);

  async function loadRoles(uid: string) {
    const { data } = await supabase.from("user_roles").select("role").eq("user_id", uid);
    setRoles((data ?? []).map((r: any) => r.role));
  }

  return { session, roles, loading, isAdmin: roles.includes("admin"), isEditor: roles.includes("admin") || roles.includes("editor"), reloadRoles: () => session && loadRoles(session.user.id) };
}