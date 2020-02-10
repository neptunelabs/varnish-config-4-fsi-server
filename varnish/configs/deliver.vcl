###
# Fallback Image
###

if (resp.status == 404 && req.restarts == 0) {
	set req.http.X-Origin-Path = req.url;
	set req.http.X-FallbackImage = "1";
	set req.http.X-NoCacheForce = "1";

	return (restart);
}
elif (req.restarts > 0) {
	unset resp.http.Cache-Control;
	unset resp.http.Last-Modified;
	unset resp.http.ETag;
	set resp.http.Cache-Control = "public, max-age=120";
}

