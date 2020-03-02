###
# Start rules
###

include "./recv.start.vcl";

###
# NeptuneLabs general rules
###

##
## robots.txt
###
if (req.url ~ "^/robots.txt$") {
        return(synth(700, "OK"));
}

##
# Replace old FSICache style paths
##
elif (
        req.url ~ "^[/]+fsicache[/]+(server|viewer|static|js|users)"
) {
        set req.url = regsub(req.url, "^[/]+fsicache[/]+", "/fsi/");
        return (hash);
}
elif (
        req.url ~ "^[/]+fsicache[/]+images"
) {
        set req.url = regsub(req.url, "^[/]+fsicache[/]+images", "/fsi/server");
        return (hash);
}

##
# SEO Template V2
# /v2/470x470/path/to/myimage/tif/my-seo-data.jpg
# to
# ?type=image&source=path/to/myimage.tif&width=470&height=470
##
elif (
        req.url ~ "^[/]+v2[/]+"
) {
        # cut last path part
        set req.url = regsub(req.url, "^(.+)/.+$", "\1");

        # replace last slash with an dot
        set req.url = regsub(req.url, "^(.+)/(.+)$", "\1.\2");

        # reform /v2/470x470_r1 = pad
        if (req.url ~ "^[/]+v2[/]+[0-9]+x[0-9]+_r1[/]+") {
                set req.url = regsub(req.url, "^[/]+v2[/]+([0-9]+)x([0-9]+)_r1[/]+", "/fsi/server?type=image&width=\1&height=\2&effects=pad(cc,ffffffff)&source=");
        }

        # reform /v2/470x470_r2 = pad & quality
        elif (req.url ~ "^[/]+v2[/]+[0-9]+x[0-9]+_r2[/]+") {
                set req.url = regsub(req.url, "^[/]+v2[/]+([0-9]+)x([0-9]+)_r2[/]+", "/fsi/server?type=image&width=\1&height=\2&effects=pad(cc,ffffffff)&quality=40&source=");
        }

        # reform /v2/470x470x90
        elif (req.url ~ "^[/]+v2[/]+[0-9]+x[0-9]+x[0-9]{1,3}[/]+") {
                set req.url = regsub(req.url, "^[/]+v2[/]+([0-9]+)x([0-9]+)x([0-9]{1,3})[/]+", "/fsi/server?type=image&width=\1&height=\2&quality=\3&source=");
        }

        # reform /v2/470x470
        elif (req.url ~ "^[/]+v2[/]+[0-9]+x[0-9]+[/]+") {
                set req.url = regsub(req.url, "^[/]+v2[/]+([0-9]+)x([0-9]+)[/]+", "/fsi/server?type=image&width=\1&height=\2&source=");
        }

        # reform /v2/470
        elif (req.url ~ "^[/]+v2[/]+[0-9]+[/]+") {
                set req.url = regsub(req.url, "^[/]+v2[/]+([0-9]+)[/]+", "/fsi/server?type=image&width=\1&source=");
        }

        # reform /v2/x470
        elif (req.url ~ "^[/]+v2[/]+x[0-9]+[/]+") {
                set req.url = regsub(req.url, "^[/]+v2[/]+x([0-9]+)[/]+", "/fsi/server?type=image&height=\1&source=");
        }

        return (hash);
}
##
# /fsi/server/ab/def.jpg?type=image&width=400&height=300&source=images/here/abc.jpg&width=400&height=300
# to
# /fsi/server?type=image&width=400&height=300&source=images/here/abc.jpg&width=400&height=300
##
elif (
        req.url ~ "^[/]+fsi[/]+server/.+\?"
) {
        # cut
        set req.url = regsub(req.url, "^([/]+fsi[/]+server)/.+?(\?.+)$", "\1\2");

        return (hash);
}

##
# deliver all exepting index
##
elif (
                req.url != "/" && req.url !~ "^[/]+fsi[/]+service" && req.url !~ "^[/]+fsi[/]+interface"
     ) {
        return (hash);
}


return(synth(666, "OK"));
