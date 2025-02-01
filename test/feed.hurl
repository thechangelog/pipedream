# Get the changelog feed
GET {{host}}/podcast/feed
HTTP/2 200 # expect OK response via HTTP/2
[Asserts]
duration < 5000 # ensure that it loads sub 5s - GitHub Actions networking can be slow...
header "x-varnish" exists # served by Varnish
header "age" exists # cache age works
header "cache-status" contains "Edge" # served by an edge cache location
header "cache-status" contains "ttl=" # ttl is set
header "cache-status" contains "grace=" # grace is set
header "cache-status" contains "region=" # region that served this request 

# Get the changelog feed AGAIN
GET {{host}}/podcast/feed
[Options]
delay: 65s # wait >60s so that it becomes stale
HTTP/2 200 # expect OK response via HTTP/2
[Asserts]
duration < 2000 # ensure that it loads sub 2s when cached
header "cache-status" contains "hit" # served from cache
header "cache-status" contains "stale" # will need to be refreshed from origin
header "age" toInt > 60 # has been stored in cache for MORE THAN 60s

# Get the changelog feed ONE MORE TIME
GET {{host}}/podcast/feed
[Options]
delay: 5s # wait a bit so that it refreshes from origin
HTTP/2 200 # expect OK response via HTTP/2
[Asserts]
duration < 2000 # ensure that it loads sub 2s when cached
header "cache-status" contains "hit" # served from cache
header "cache-status" not contains "stale" # not stale
header "age" toInt < 60 # has been stored in cache LESS THAN 60s
