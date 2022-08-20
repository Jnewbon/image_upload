rem Install Certs
cd certs
mkcert-windows.exe --install
mkcert-windows.exe -cert-file website.docker.crt -key-file website.docker.key "website.docker" "*.website.docker"
cd ../..

rem Start docker containers
docker-compose up -d

rem Copy .env.local to .env
copy .env.local .env

rem Install composer things
docker-compose exec web composer install

rem Run migration
docker-compose exec web php artisan migrate:fresh

rem Seed Data
docker-compose exec web php artisan db:seed

rem Compile frontend assets
docker-compose exec node npm install
docker-compose exec node npm run prod

rem link storage folder to public folder
docker-compose exec web php artisan storage:link
