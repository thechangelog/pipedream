# Get the homepage
GET {{host}}
HTTP/2 200 # expect OK response via HTTP/2
[Asserts]
duration < 1000 # ensure that it loads sub 1s - GitHub Actions networking can be slow...
header "x-varnish" exists # served by Varnish
header "age" exists # cache age works
header "cache-status" contains "Edge" # served by an edge cache location
header "cache-status" contains "ttl=" # ttl is set
header "cache-status" contains "grace=" # grace is set
header "cache-status" contains "region=" # region that served this request 

# Get the homepage AGAIN
GET {{host}}
HTTP/2 200 # expect OK response via HTTP/2
[Asserts]
duration < 200 # now that it is cached, ensure that it loads sub 200ms - GitHub Actions networking can be slow...
header "cache-status" contains "hit" # definitely served from cache
