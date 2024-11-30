# Get the admin homepage
GET {{host}}/admin
[Options]
repeat: 2 # repeat so that we confirm caching behaviour
HTTP/2 302 # expect found redirect via HTTP/2
[Asserts]
duration < 1000 # ensure that it loads sub 1s - GitHub Actions networking can be slow...
header "location" == "/" # redirect to homepage
header "x-varnish" exists # served by Varnish
header "age" == "0" # NOT stored in cache
header "cache-status" contains "hits=0" # double-check that it's NOT stored in cache
header "cache-status" contains "miss" # NOT served from cache
