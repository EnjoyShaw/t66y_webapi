worker_processes 4
listen '/var/www/t66y_webapi/shared/tmp/sockets/unicorn.sock', :backlog => 64
pid '/var/www/t66y_webapi/shared/tmp/pids/unicorn.pid'