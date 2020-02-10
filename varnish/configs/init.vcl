###
# backend server config
###

backend server1 {
  .host = "my.domain.tld";
  .port = "80";
  .max_connections = 300;

  .probe = {
    # We prefer to only do a HEAD /
    .request =
      "HEAD /fsi/service/sessionrefresh HTTP/1.1"
      "Host: my.domain.tld"
      "Connection: close"
      "User-Agent: Varnish Health Probe";

    .interval  = 5s; # check the health of each backend every 5 seconds
    .timeout   = 1s; # timing out after 1 second.
    .window    = 5;  # If 3 out of the last 5 polls succeeded the backend is considered healthy, otherwise it will be marked as sick
    .threshold = 3;
  }

  .first_byte_timeout     = 300s;   # How long to wait before we receive a first byte from our backend?
  .connect_timeout        = 5s;     # How long to wait for a backend connection?
  .between_bytes_timeout  = 2s;     # How long to wait between bytes received from our backend?
}

sub vcl_init {
  new vdir = directors.round_robin();
  vdir.add_backend(server1);
  # vdir.add_backend(server...);
}

