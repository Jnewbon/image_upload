# Stop docker containers
docker-compose down

# Install certs
cd ./.devops/certs/
rm website.docker*
./mkcert-linux --install
./mkcert-linux -cert-file website.docker.crt -key-file website.docker.key "website.docker" "*.website.docker"
cd ../..


# Start docker containers
docker-compose up -d

# Copy .env.local to .env
cp .env.local .env

# Composer install
docker-compose exec web composer install

# Run migration
docker-compose exec web php artisan migrate:fresh


# Ensure the packag lock file is regenerated.
rm package-lock.json

# Compile frontend assets
docker-compose exec node npm install
docker-compose exec node npm run prod

#Import database
docker-compose exec web php artisan import:database-v1

# Seed Data
docker-compose exec web php artisan db:seed

#Set permission on storage dir
docker-compose exec web chmod -R 777 storage
