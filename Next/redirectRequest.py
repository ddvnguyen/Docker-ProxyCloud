# forward_by_host_port.py
from mitmproxy import http, ctx
import re
import time

def request(flow: http.HTTPFlow) -> None:
   host_header = flow.request.headers.get("Host", "")
   ctx.log.info(f"[REQ] Host header: {host_header} Incoming scheme: {flow.request.scheme} {flow.request.http_version}")
       # Match domain:port from the header
   match = re.search(r"host\.docker\.internal:(\d+)", host_header)
   if match:
      port = int(match.group(1))
      scheme = flow.request.scheme 
      flow.request.host = "host.docker.internal"
      flow.request.port = port
      flow.request.scheme = scheme
      # Also rewrite the Host header
      flow.request.headers["Host"] = f"localhost"
      ctx.log.info(f"[REQ] Routing to host.docker.internal:{port} scheme:{scheme}")
   else:
      ctx.log.warn("[REQ] No valid host header found, rejecting")
      flow.response = http.Response(    
         status_code=502,
         http_version="HTTP/1.1",
         reason="Bad Gateway",
         headers={"Content-Type": "text/plain"},
         content=b"Bad Gateway: Host header must be host.docker.internal:<port>",
         trailers=None,
         timestamp_start=now,
         timestamp_end=now
      )

def response(flow: http.HTTPFlow) -> None:
   ctx.log.info(f"[RES] response: {flow.response} Location:{flow.response.headers.get("Location", "")} {flow.response.http_version}")
   # Log headers
   # ctx.log.info("[RESPONSE HEADERS]")
   # for name in flow.response.headers.keys():
   #    for value in flow.response.headers.get_all(name):
   #       ctx.log.info(f"  {name}: {value}")

   # if "host.docker.internal" in location or "localhost" in location:
   #    # Optional: extract port and map to external hostname if needed
   #    new_location = location.replace("http://host.docker.internal", f"https://{flow.request.headers['Host'].split(':')[0]}")
   #    new_location = new_location.replace("http://localhost", f"https://{flow.request.headers['Host'].split(':')[0]}")
   #    flow.response.headers["Location"] = new_location
   #    ctx.log.info(f"[RES] Rewrote redirect Location to: {new_location}")