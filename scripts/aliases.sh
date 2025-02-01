alias back-logs="sudo docker compose -f /home/admin/deploy/docker-compose.yml logs backend -f"
alias front-logs="sudo docker compose -f /home/admin/deploy/docker-compose.yml logs frontend -f"
alias nginx-logs="sudo docker compose -f /home/admin/deploy/docker-compose.yml logs nginx -f"
alias deploy='
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
'

alias force-deploy='
DEPLOY_DIR=~/deploy &&
cd $DEPLOY_DIR &&
git fetch origin &&
git reset --hard @{u} &&
deploy
'
