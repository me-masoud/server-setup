#!/bin/bash

# Define the checklist items
CHECKLIST=(
    "Update package list and upgrade packages"
    "Install common tools (unzip, unrar)"
    "Install and configure Nginx"
    "Install Docker"
    "Install Docker Compose"
    "Install Composer"
    "Install PHP 8.1 and extensions"
    "Install MySQL"
    "Install MongoDB"
    "Install Node.js and npm"
    "Install Go programming language"
    "Install pip, virtualenv, and gdown"
    "Disable UFW (Firewall)"
    "Install Certbot"
    "Enable and start Nginx"
    "Enable and start Docker"
)

# Function to display the checklist
show_checklist() {
    clear
    echo "Installation Progress:"
    for i in "${!CHECKLIST[@]}"; do
        if [[ ${STATUS[$i]} == "done" ]]; then
            echo "[$(tput setaf 2)✓$(tput sgr0)] ${CHECKLIST[$i]}"
        else
            echo "[ ] ${CHECKLIST[$i]}"
        fi
    done
}

# Function to mark a step as done
mark_done() {
    STATUS[$1]="done"
    show_checklist
}

# Initialize status array
STATUS=()

# Show initial checklist
show_checklist

# Step 1: Update package list and upgrade packages
sudo apt-get update -y && sudo apt-get upgrade -y
mark_done 0

# Step 2: Install common tools (unzip, unrar)
sudo apt install -y unzip unrar
mark_done 1

# Step 3: Install and configure Nginx
sudo apt-get install nginx -y
sudo unlink /etc/nginx/sites-enabled/default
sudo touch /etc/nginx/sites-available/reverse-proxy.conf
sudo ln -s /etc/nginx/sites-available/reverse-proxy.conf /etc/nginx/sites-enabled/reverse-proxy.conf
sudo nginx -t && sudo systemctl restart nginx
mark_done 2

# Step 4: Install Docker
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update -y && sudo apt-get install -y docker-ce
mark_done 3

# Step 5: Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/download/v2.24.7/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
mark_done 4

# Step 6: Install Composer
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php composer-setup.php --install-dir=/usr/local/bin --filename=composer
php -r "unlink('composer-setup.php');"
mark_done 5

# Step 7: Install PHP 8.1 and extensions
sudo add-apt-repository ppa:ondrej/php -y
sudo apt-get update -y
sudo apt-get install -y php8.1 php8.1-cli php8.1-fpm php8.1-mysql php8.1-xml php8.1-mbstring php8.1-curl php8.1-zip php8.1-gd php8.1-intl php8.1-bcmath php8.1-soap
mark_done 6

# Step 8: Install MySQL
sudo apt-get install -y mysql-server
sudo systemctl start mysql && sudo systemctl enable mysql
mark_done 7

# Step 9: Install MongoDB
wget -qO - https://www.mongodb.org/static/pgp/server-6.0.asc | sudo apt-key add -
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu $(lsb_release -cs)/mongodb-org/6.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-6.0.list
sudo apt-get update -y && sudo apt-get install -y mongodb-org
sudo systemctl start mongod && sudo systemctl enable mongod
mark_done 8

# Step 10: Install Node.js and npm
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt-get install -y nodejs
sudo npm install -g npm@10.7.0
mark_done 9

# Step 11: Install Go programming language
GO_VERSION="1.22.5"
wget https://golang.org/dl/go$GO_VERSION.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go$GO_VERSION.linux-amd64.tar.gz
rm go$GO_VERSION.linux-amd64.tar.gz
echo "export PATH=\$PATH:/usr/local/go/bin" >> ~/.profile
source ~/.profile
mark_done 10

# Step 12: Install pip, virtualenv, and gdown
sudo apt-get install -y python3-pip python3-venv
python3 -m venv /opt/gdown-env
source /opt/gdown-env/bin/activate
pip install gdown
deactivate
mark_done 11

# Step 13: Disable UFW (Firewall)
sudo ufw disable
mark_done 12

# Step 14: Install Certbot
sudo apt-get install -y certbot python3-certbot-nginx
mark_done 13

# Step 15: Enable and start Nginx
sudo systemctl enable nginx && sudo systemctl start nginx
mark_done 14

# Step 16: Enable and start Docker
sudo systemctl enable docker && sudo systemctl start docker
mark_done 15

# Finish
echo -e "\nAll tasks completed successfully!"

