import { useEffect, useState, useCallback, useRef } from "react";
import type { Session } from "@supabase/supabase-js";
import { supabase } from "@/integrations/supabase/client";

export function useAuth() {
  const [session, setSession] = useState<Session | null>(null);
  const [roles, setRoles] = useState<string[]>([]);
  const [loading, setLoading] = useState(true);
  const loadedForUserId = useRef<string | null>(null);

  const loadRoles = useCallback(async (userId: string) => {
    loadedForUserId.current = userId;
    const { data } = await supabase.from("user_roles").select("role").eq("user_id", userId);
    setRoles(data?.map((r) => r.role) ?? []);
  }, []);

  const reloadRoles = useCallback(async () => {
    if (session) await loadRoles(session.user.id);
  }, [session, loadRoles]);

  useEffect(() => {
    // onAuthStateChange fires once synchronously with the current session
    // right after subscribing, so a separate getSession() call isn't needed
    // and would only duplicate the roles fetch below.
    const { data: sub } = supabase.auth.onAuthStateChange((_event, session) => {
      setSession(session);
      if (session) {
        if (loadedForUserId.current !== session.user.id) loadRoles(session.user.id);
      } else {
        loadedForUserId.current = null;
        setRoles([]);
      }
      setLoading(false);
    });

    return () => sub.subscription.unsubscribe();
  }, [loadRoles]);

  return {
    session,
    roles,
    loading,
    isAdmin: roles.includes("admin"),
    isEditor: roles.includes("admin") || roles.includes("editor"),
    reloadRoles,
  };
}
