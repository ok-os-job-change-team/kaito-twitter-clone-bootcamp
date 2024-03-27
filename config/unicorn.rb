worker_processes 4

# pid "/var/run/unicorn.pid"
# listen "/var/tmp/unicorn.sock"

pid "./tmp/pids/unicorn.pid"
listen "./tmp/sockets/unicorn.sock"

stdout_path "./log/unicorn.stdout.log"
stderr_path "./log/unicorn.stderr.log"