#!/bin/bash

# Update package list and upgrade packages
sudo apt-get update -y
sudo apt-get upgrade -y

# Install common tools
sudo apt install unzip
sudo apt install unrar

# Install Nginx
sudo apt-get install nginx -y

#setup reverse proxy
sudo unlink /etc/nginx/sites-enabled/default
sudo touch /etc/nginx/sites-available/reverse-proxy.conf
sudo ln -s /etc/nginx/sites-available/reverse-proxy.conf /etc/nginx/sites-enabled/reverse-proxy.conf
service nginx configtest
service nginx restart

# Install Docker
sudo apt-get install apt-transport-https ca-certificates curl software-properties-common -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update -y
sudo apt-get install docker-ce -y

# Install Docker Compose version 2.24.7
sudo curl -L "https://github.com/docker/compose/releases/download/v2.24.7/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Install Composer
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php -r "if (hash_file('sha384', 'composer-setup.php') === '906a836b9f52c23410da89a3e72a6823a9f4eeccafec97bc6e53f5dd0aa4b1f5') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
php composer-setup.php --install-dir=/usr/local/bin --filename=composer
php -r "unlink('composer-setup.php');"

# Install PHP 8.1 and common extensions
sudo add-apt-repository ppa:ondrej/php -y
sudo apt-get update -y
sudo apt-get install -y php8.1 php8.1-cli php8.1-fpm php8.1-mysql php8.1-xml php8.1-mbstring php8.1-curl php8.1-zip php8.1-gd php8.1-intl php8.1-bcmath php8.1-soap

# Install MySQL
sudo apt-get install mysql-server -y

# Start MySQL service
sudo systemctl start mysql
sudo systemctl enable mysql

# Set root password and create dev user with password xxx
# Using the MySQL root user to run SQL commands

sudo mysql <<EOF
-- Set root password to 'roxasshereDsdfkjasdf@@$12'
ALTER USER 'root'@'localhost' IDENTIFIED BY 'roxasshereDsdfkjasdf@@$12';

-- Create dev user and set password 'roxasshereDsdfkjasdf@@$12'
CREATE USER 'dev'@'localhost' IDENTIFIED BY 'roxasshereDsdfkjasdf@@$12';

-- Grant all privileges to dev user
GRANT ALL PRIVILEGES ON *.* TO 'dev'@'localhost' WITH GRANT OPTION;

-- Apply changes
FLUSH PRIVILEGES;

EOF

# Secure MySQL Installation
# Automatically secure MySQL installation with 'Y' responses
sudo mysql_secure_installation <<EOF

Y
roxasshereDsdfkjasdf@@$12
roxasshereDsdfkjasdf@@$12
Y
Y
Y
Y
EOF

# Restart MySQL service
sudo systemctl restart mysql

echo "MySQL installation and configuration completed."

# Install MongoDB
wget -qO - https://www.mongodb.org/static/pgp/server-6.0.asc | sudo apt-key add -
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu $(lsb_release -cs)/mongodb-org/6.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-6.0.list
sudo apt-get update -y
sudo apt-get install -y mongodb-org
sudo systemctl start mongod
sudo systemctl enable mongod

# Install Node.js version 20
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt-get install -y nodejs

# Install npm version 10.7.0
sudo npm install -g npm@10.7.0


# Install Go
GO_VERSION="1.22.5"
wget https://golang.org/dl/go$GO_VERSION.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go$GO_VERSION.linux-amd64.tar.gz
rm go$GO_VERSION.linux-amd64.tar.gz
echo "export PATH=\$PATH:/usr/local/go/bin" >> ~/.profile
source ~/.profile



# Install pip and virtualenv
sudo apt-get install -y python3-pip python3-venv

# Create a virtual environment and install gdown
python3 -m venv /opt/gdown-env
source /opt/gdown-env/bin/activate
pip install gdown
deactivate


# Disable UFW (Firewall)
sudo ufw disable

# Install Certbot
sudo apt-get install certbot python3-certbot-nginx -y

# Enable and start Nginx
sudo systemctl enable nginx
sudo systemctl start nginx


# Create Nginx reverse proxy configuration
sudo unlink /etc/nginx/sites-enabled/default
sudo tee /etc/nginx/sites-available/reverse-proxy.conf > /dev/null <<EOF
server {
        listen 80;
        server_name x.com;
        location / {
            proxy_pass         http://127.0.0.1:8000;
            proxy_redirect     off;
            proxy_set_header   Host \$host;
            proxy_set_header   X-Real-IP \$remote_addr;
            proxy_set_header   X-Forwarded-For \$proxy_add_x_forwarded_for;
            proxy_set_header   X-Forwarded-Host \$server_name;
        }
}
EOF

# Enable the Nginx reverse proxy configuration
sudo ln -s /etc/nginx/sites-available/reverse-proxy.conf /etc/nginx/sites-enabled/reverse-proxy.conf
sudo nginx -t
sudo systemctl restart nginx

# Enable and start Nginx
sudo systemctl enable nginx
sudo systemctl start nginx



# Enable and start Docker
sudo systemctl enable docker
sudo systemctl start docker



# Install prerequisites
echo "Installing prerequisites..."
sudo apt install -y curl build-essential

# Install Node.js and npm from the NodeSource PPA for bootstrapping
echo "Installing Node.js and npm for initial setup..."
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt install -y nodejs

# Install 'n' globally to manage Node.js versions
echo "Installing 'n' (Node.js version manager)..."
sudo npm install -g n
sudo npm install pnpm -g

# Install pm2

sudo npm install pm2 -g


# Install the latest stable version of Node.js using 'n'
echo "Installing the latest stable version of Node.js..."
sudo n latest

# Ensure npm is updated to the latest version
echo "Updating npm to the latest version..."
sudo npm install -g npm

# Verify installations
echo "Verifying installations..."
node_version=$(node -v)
npm_version=$(npm -v)
echo "Node.js version: $node_version"
echo "npm version: $npm_version"

echo "Latest Node.js and npm have been installed successfully."



# Display versions
echo "Nginx version:"
nginx -v
echo "Docker version:"
docker --version
echo "Docker Compose version:"
docker-compose --version
echo "Composer version:"
composer --version
echo "PHP version:"
php -v
echo "Node version:"
node -v
echo "npm version:"
npm -v
echo "MySQL version:"
mysql --version
echo "MongoDB version:"
mongod --version
echo "Go version:"
go version
echo "pip version:"
pip3 --version
echo "gdown version:"
gdown --version

echo "Setup completed successfully."