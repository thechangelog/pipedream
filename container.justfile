# vim: set tabstop=4 shiftwidth=4 expandtab:

[private]
default:
    @just --list

[private]
fmt:
    just --fmt --check --unstable
    just --version

# Start all processes
up:
    goreman start

# Check $url
check url="http://localhost:9000":
    httpstat {{ url }}

# List Varnish backends
backends:
    varnishadm backend.list

# Tail Varnish backend_health
health:
    varnishlog -g raw -i backend_health

# Varnish top
top:
    varnishtop

# Varnish stat
stat:
    varnishstat

# Show Varnish cache stats
cache:
    varnishncsa -c -f '%m %u %h %{x-cache}o %{x-cache-hits}o'

# Benchmark $url as http version $http with $reqs across $conns
bench url="http://localhost:9000/" http="2" reqs="100000" conns="50":
    oha -n {{ reqs }} -c {{ conns }} {{ url }} --http-version={{ http }}
