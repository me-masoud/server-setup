#!/bin/bash

# Total steps count
TOTAL_STEPS=21
CURRENT_STEP=0

# Function to display progress
show_progress() {
    CURRENT_STEP=$((CURRENT_STEP + 1))
    PERCENT=$((CURRENT_STEP * 100 / TOTAL_STEPS))
    PROGRESS_BAR=$(printf "%-${PERCENT}s" "=" | tr ' ' '=')
    printf "\r[%-50s] %d%%" "${PROGRESS_BAR}" "${PERCENT}"
}

# Function to run a command and update progress
run_step() {
    "$@" >/dev/null 2>&1
    show_progress
}

# Start progress
echo "Starting installation..."
show_progress

# Step 1: Update package list and upgrade packages
run_step sudo apt-get update -y
run_step sudo apt-get upgrade -y

# Step 2: Install common tools
run_step sudo apt install unzip -y
run_step sudo apt install unrar -y

# Step 3: Install Nginx
run_step sudo apt-get install nginx -y
run_step sudo unlink /etc/nginx/sites-enabled/default
run_step sudo touch /etc/nginx/sites-available/reverse-proxy.conf
run_step sudo ln -s /etc/nginx/sites-available/reverse-proxy.conf /etc/nginx/sites-enabled/reverse-proxy.conf
run_step sudo service nginx configtest
run_step sudo service nginx restart

# Step 4: Install Docker
run_step sudo apt-get install apt-transport-https ca-certificates curl software-properties-common -y
run_step curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
run_step sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
run_step sudo apt-get update -y
run_step sudo apt-get install docker-ce -y

# Step 5: Install Docker Compose version 2.24.7
run_step sudo curl -L "https://github.com/docker/compose/releases/download/v2.24.7/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
run_step sudo chmod +x /usr/local/bin/docker-compose

# Step 6: Install Composer
run_step php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
run_step php composer-setup.php --install-dir=/usr/local/bin --filename=composer
run_step php -r "unlink('composer-setup.php');"

# Step 7: Install PHP 8.1 and common extensions
run_step sudo add-apt-repository ppa:ondrej/php -y
run_step sudo apt-get update -y
run_step sudo apt-get install -y php8.1 php8.1-cli php8.1-fpm php8.1-mysql php8.1-xml php8.1-mbstring php8.1-curl php8.1-zip php8.1-gd php8.1-intl php8.1-bcmath php8.1-soap

# Step 8: Install MySQL
run_step sudo apt-get install mysql-server -y
run_step sudo systemctl start mysql
run_step sudo systemctl enable mysql

# Step 9: Install MongoDB
run_step wget -qO - https://www.mongodb.org/static/pgp/server-6.0.asc | sudo apt-key add -
run_step echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu $(lsb_release -cs)/mongodb-org/6.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-6.0.list
run_step sudo apt-get update -y
run_step sudo apt-get install -y mongodb-org
run_step sudo systemctl start mongod
run_step sudo systemctl enable mongod

# Step 10: Install Node.js version 20
run_step curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
run_step sudo apt-get install -y nodejs

# Step 11: Install npm version 10.7.0
run_step sudo npm install -g npm@10.7.0

# Step 12: Install Go
run_step wget https://golang.org/dl/go1.22.5.linux-amd64.tar.gz
run_step sudo tar -C /usr/local -xzf go1.22.5.linux-amd64.tar.gz
run_step rm go1.22.5.linux-amd64.tar.gz
run_step echo "export PATH=\$PATH:/usr/local/go/bin" >> ~/.profile
run_step source ~/.profile

# Step 13: Install pip and virtualenv
run_step sudo apt-get install -y python3-pip python3-venv
run_step python3 -m venv /opt/gdown-env
run_step source /opt/gdown-env/bin/activate
run_step pip install gdown
deactivate

# Step 14: Disable UFW (Firewall)
run_step sudo ufw disable

# Step 15: Install Certbot
run_step sudo apt-get install certbot python3-certbot-nginx -y

# Step 16: Configure and restart Nginx
run_step sudo systemctl enable nginx
run_step sudo systemctl start nginx

# Final step
echo -e "\nSetup completed successfully!"

