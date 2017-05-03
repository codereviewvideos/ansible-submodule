---

mysql_databases:
  - name: api_db


website_directories:
  - { name: "api", directory: "api.{{ website_domain_name }}" }


symfony_websites:
  - root_directory: "/var/www/api.{{ ansible_fqdn }}"
    log_directory: "/var/www/api.{{ ansible_fqdn }}/var/logs"
    cache_directory: "/var/www/api.{{ ansible_fqdn }}/var/cache"


nginx_vhosts:
  - listen: "80 default_server"
    server_name: "api.example_host.dev"
    root: "/var/www/api.example_host.dev/web"
    access_log: "/var/log/nginx/api.example_host.dev-access.log"
    error_log: "/var/log/nginx/api.example_host.dev-error.log"

    extra_parameters: |

      charset utf-8;
      charset_types application/json;

      include h5bp/basic.conf;

      location = /favicon.ico { log_not_found off; access_log off; }
      location = /robots.txt  { log_not_found off; access_log off; }

      location / {
          # try to serve file directly, fallback to app.php
          try_files $uri /app.php$is_args$args;
      }

      # DEV
      # This rule should only be placed on your development environment
      # In production, don't include this and don't deploy app_dev.php or config.php
      location ~ ^/(app_.*|config)\.php(/|$) {
          fastcgi_pass {{ symfony_php_fpm_socket }};
          fastcgi_split_path_info ^(.+\.php)(/.*)$;
          include fastcgi_params;
          fastcgi_param SCRIPT_FILENAME $realpath_root$fastcgi_script_name;
          fastcgi_param DOCUMENT_ROOT $realpath_root;
      }

      # PROD
      location ~ ^/app\.php(/|$) {
          fastcgi_pass {{ symfony_php_fpm_socket }};
          fastcgi_split_path_info ^(.+\.php)(/.*)$;
          include fastcgi_params;
          fastcgi_param  SCRIPT_FILENAME $realpath_root$fastcgi_script_name;
          fastcgi_param DOCUMENT_ROOT $realpath_root;
          internal;
      }

      location ~ ^/(status|ping)$ {
          access_log off;
          allow 127.0.0.1;
          allow 192.168.0.7;
          deny all;
          include fastcgi_params;
          fastcgi_pass 127.0.0.1:9000;
      }