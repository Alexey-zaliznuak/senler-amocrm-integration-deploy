DEPLOY_DIR=~/deploy

cd $DEPLOY_DIR &&

sudo git pull &&

# Добавление безопасных директорий в конфигурацию Git
sudo git config --global --add safe.directory $DEPLOY_DIR/backend &&
sudo git config --global --add safe.directory $DEPLOY_DIR/frontend &&

# Обновление подмодулей
sudo git submodule update --init --recursive &&

# Обновление backend
cd $DEPLOY_DIR/backend &&
sudo git fetch &&
sudo git checkout main &&
sudo git pull &&

# Обновление frontend
cd $DEPLOY_DIR/frontend &&
sudo git fetch &&
sudo git checkout master &&
sudo git pull &&

# Запуск Docker
sudo docker compose -f $DEPLOY_DIR/docker-compose.yml up --build -d &&
sudo docker system prune -f &&

cd
