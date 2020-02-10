###
# Fallback Image
###

#if(req.http.X-FallbackImage == "1") {
#  set req.url = regsub(req.url, "^(.+)source=[^&]+(.*)$", "\1source=connector/fallback.png\2");
#}

# demo: transform url like /x-images/width/height/path/to/image.jpg

#elif ( req.url ~ "^/x-images/" && req.url ~ "\.jpg$" ) {
#  set req.url = regsub(req.url,"^/x-images/([^/]+)/([^/]+)/(.+)$","/fsi/server?type=image&source=\3&width=\1&height=\2&format=jpeg");
#}
