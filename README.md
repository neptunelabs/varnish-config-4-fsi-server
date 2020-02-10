## Varnish Configuration Templates for FSI Server

### Installation

You need a Varnish Cache 6 installation with
[Xkey](https://github.com/varnish/varnish-modules) enabled module.
Xkey activates the tag-based invalidation and allows all derivatives
for an asset to be deleted in one step.

The file default.vcl and the directory configs should replace
the existing default.vcl.

In addition, **both** hosts (my.domain.tld) must be replaced with the real
hosts in configs/init.vcl.
