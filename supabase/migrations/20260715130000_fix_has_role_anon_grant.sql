-- Public/anonymous reads of articles, comments and newsletter policies
-- evaluate has_role(auth.uid(), ...) inside an OR clause even for anon
-- visitors, so anon needs EXECUTE on it too, or every public SELECT
-- errors with "permission denied for function has_role".
GRANT EXECUTE ON FUNCTION public.has_role(uuid, public.app_role) TO anon;
