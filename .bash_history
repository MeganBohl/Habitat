sudo yum update
export HAB_ORIGIN=mbohl
echo $HAB_ORIGIN
exportHAB_AUTH_TOKEN=_Qk9YLTEKYmxkci0yMDE3MDkyNzAyMzcxNApibGRyLTIwMTcwOTI3MDIzNzE0CmVPTndFTzh0Vy9qOFErYmhJZDFqaHgrWHBybEdXTFpSCjlLa1NtWkdMRlFmNTdiUDUwSlNSeWdqOFd0ZFJ5V1Nxak9RQnUxQUlSZ21uOWl1bQ==
echo $HAB_AUTH_TOKEN
export HAB_AUTH_TOKEN=_Qk9YLTEKYmxkci0yMDE3MDkyNzAyMzcxNApibGRyLTIwMTcwOTI3MDIzNzE0CmVPTndFTzh0Vy9qOFErYmhJZDFqaHgrWHBybEdXTFpSCjlLa1NtWkdMRlFmNTdiUDUwSlNSeWdqOFd0ZFJ5V1Nxak9RQnUxQUlSZ21uOWl1bQ==
echo $HAB_AUTH_TOKEN
cd /usr/local/bin
curl https://raw.githubusercontent.com/habitat-sh/habitat/master/components/hab/install.sh | sudo bash
cd ~
hab cli setup
hab --version
ls ~/.hab/cache/keys
sudo curl -L https://github.com/docker/compose/releases/download/1.22.0/docker-compose-Linux-x86_64$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
docker -v
docker-compose --version
sudo curl -L https://github.com/docker/compose/releases/download/1.22.0/docker-compose-Linux-x86_64-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
sudo curl -L https://github.com/docker/compose/releases/download/1.21.2/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
docker-compose --version
cd ~
git clone https://github.com/learn-chef/hab-two-tier.git
sudo yum install git
git clone https://github.com/learn-chef/hab-two-tier.git
cd hab-two-tier
tree
yum install tree
sudo yum install tree
tree
hab studio enter
hab origin key export --type secret mboh
hab origin key generate mbohl
hab studio enter
docker images | grep $HAB_ORIGIN
sudo curl -L https://github.com/docker/compose/releases/download/1.22.0/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
cd hab-two-tier
docker-compose --version
sudo yum install -y yum-utils   device-mapper-persistent-data   lvm2
sudo yum-config-manager     --add-repo     https://download.docker.com/linux/centos/docker-ce.repo
sudo yum-config-manager --enable docker-ce-edge
sudo yum-config-manager --enable docker-ce-test
sudo yum-config-manager --disable docker-ce-edge
sudo yum install docker-ce
sudo systemctl start docker
sudo docker run hello-world
hab studio enter
systemctl docker start
sudo systemctl start docker
sudo systemctl status docker
hab studio enter
docker images | grep $HAB_ORIGIN
sudo docker images | grep $HAB_ORIGIN
grep
grep --help
sudo yum install grep
docker images | grep $HAB_ORIGIN
docker images
docker run hello-world
sudo gpasswd -a $USER docker
docker run hello-world
sudo addgroup --system docker
usermod -aG docker ${USER}
sudo usermod -aG docker ${USER}
sudo service docker restart
sudo service docker status
docker run hello-world
sudo systemctl restart docker.service
sudo systemctl status docker.service
docker run hello-world
sudo chmod +x /usr/local/bin/docker
cd /usr/local/bin
ls
sudo systemctl start docker
sudo systemctl restart docker
sudo systemctl status docker
cd ~
locate docker
sudo yum install docker-ce
locate docker-ce
docker --v
docker -v
docker images
sudo groupadd docker
sudo gpasswd -a $USER docker
newgrp docker
docker run hello-world
docker images | grep $HAB_ORIGIN
docker images
docker images | grep $HAB_ORIGIN
cd hab-two-tier/
docker images | grep $HAB_ORIGIN
docker images
ls
docker-compose -p habquickstart up -d
grep $HAB_ORIGIN
sudo nano ~/.hab/etc/cli.toml
export HAB_ORIGIN
export HAB_AUTH_TOKEN
grep $HAB_ORIGIN
docker-compose -p habquickstart up -d
hab config show
hab config show mbohl
hab config show webapp
hab config show habquickstart
hab config
hab config show mbohl/webapp
hab studio enter
ls
sudo nano docker-compose.yml
docker-compose -p habquickstart up -d
sudo systemctl enable docker
sudo systemctl status docker
sudo systemctl status docker-compose
docker-compose -p habquickstart up -d
HAB_ORIGIN
export HAB_ORIGIN=mbohl
echo  HAB_ORIGIN
echo $HAB_ORIGIN
docker-compose -p habquickstart up -d
docker-compose logs -f
docker ps
docker network ls
curl -s http://127.0.0.1:8000 | grep 'The time is'
sudo systemctl start docker
sudo systemctl status docker
curl -s http://127.0.0.1:8000 | grep 'The time is'
docker-compose -p habquickstart up -d`
docker-compose -p habquickstart up -d
ls
cd hab-two-tier/
docker-compose -p habquickstart up -d
export HAB_ORIGIN=mbohl
docker-compose -p habquickstart up -d
curl -s http://127.0.0.1:8000 | grep 'The time is'
docker ps
curl -s http://127.0.0.1:8000 | grep 'The time is'
docker images
curl -s http://127.0.0.1:8000
docker-compose logs -f
sudo yum install telnet
telnet 40.124.40.145 8000
curl -s http://127.0.0.1:8000 | grep 'The time is'
curl -s http://127.0.0.1:8000
sudo systemctl start docker
sudo systemctl status docker
sudo docker run hello-world
docker-compose -p habquickstart up -d
ls
cd hab-two-tier/
docker-compose -p habquickstart up -d
export HAB_ORIGIN=mbohl
docker-compose -p habquickstart up -d
curl -s http://127.0.0.1:8000 | grep 'The time is'
curl -s http://127.0.0.1:8000
hab pkg install core/curl -b
hab pkg export docker $HAB_ORIGIN/webapp
docker images
ls
cd hab-two-tier/
export HAB_ORIGIN=mbohl
exportHAB_AUTH_TOKEN=_Qk9YLTEKYmxkci0yMDE3MDkyNzAyMzcxNApibGRyLTIwMTcwOTI3MDIzNzE0CmVPTndFTzh0Vy9qOFErYmhJZDFqaHgrWHBybEdXTFpSCjlLa1NtWkdMRlFmNTdiUDUwSlNSeWdqOFd0ZFJ5V1Nxak9RQnUxQUlSZ21uOWl1bQ==
sudo systemctl status docker
curl -s 127.0.0.1 | grep 'The time is'
curl -s 127.0.0.1
docker-compose -p habquickstart up -d
docker-compose logs -f
docker-compose logs
docker ps
curl -s http://127.0.0.1:8000 | grep 'The time is'
curl -s http://127.0.0.1:8000
hab studio enter
docker images
docker-compose -p habquickstart up -d
docker-compose logs -f
docker logs
docker ps
curl -s http://127.0.0.1:8000 | grep 'The time is'
docker exec habquickstart_load-balancer_1 cat /hab/svc/haproxy/config/haproxy.conf
docker run --network=habquickstart_default --name web-3 -d $HAB_ORIGIN/webapp --peer web-1
curl -s http://127.0.0.1:8000 | grep 'The time is'
docker exec habquickstart_load-balancer_1 cat /hab/svc/haproxy/config/haproxy.conf
docker rm -f web-3
docker-compose -p habquickstart down
docker images | grep $HAB_ORIGIN
docker image rm -f 123927afdbb 009bb563754b
docker images | grep $HAB_ORIGIN
docker image rm -f 4123927afdbb
docker images | grep $HAB_ORIGIN
cd ~
hab origin key upload --pubfile ~/.hab/cache/keys/mbohl-20180723170042.pub
git clone https://github.com/learn-chef/habitat-building-with-scaffolding.git
cd habitat-building-with-scaffolding
hab plan init
ls
cd habitat-building-with-scaffolding/
hab plan init
sudo nano plan.sh
ls
cd habitat
ls
sudo nano plan.sh
hab studio enter
cd ..
hab plan init
hab studio enter
cd habitat/
ls
sudo nano plan.sh
hab studio enter
cd ..
hab studio enter
cd habitat
sudo nano plan.sh
cd ..
hab studio enter
cd habitat/
sudo nano plan.sh
cd ..
hab studio enter
ls
cd habitat/
ls
sudo nano plan.sh
hab studio enter
ls
cd ..
cat habitat/plan.sh
hab studio enter
docker images | grep habitatize
grep habitize
docker images | grep habitize
export HAB_ORIGIN=mbohl
echo $HAB_ORIGIN
docker run -p 8000:8000 $HAB_ORIGIN/habitatize
docker run -p 8000:8000 $HAB_ORIGIN/habitize
git clone https://github.com/learn-chef/habitat-building-dependencies
cd ~/habitat-building-dependencies
hab studio enter
docker run -p 8000:8000 $HAB_ORIGIN/habitatize
docker run --help
ls
docker images
docker run -p 8000:8000 $HAB_ORIGIN/habitatize
docker run -p 8000:8000 mbohl/habitatize
export HAB_ORIGIN=mbohl
docker run -p 8000:8000 $HAB_ORIGIN/habitatize
docker logs
dcoker logs habitatize
docker logs habitatize
sup-logs
sup-log
docker logs mbohl/habitatize
docker-compose logs -f
ls
cd habitat-building-dependencies
docker-compose logs -f
docker logs -f
docker ps
docker logs f99120c2995f
ls
cd results
ls
cd ..
ls
cd assets
ls
cd ..
ls -al
cd lib
ls
cd views
ls
cd ..
ls
locate logs
ls
cd habitat
ls
sudo nano plan.sh
cd ..
mkdir imagemagick
cd imagemagick/
touch imagemagick/plan.sh
sudo touch imagemagick/plan.sh
touch plan.sh
ls
sudo nano plan.sh
hab studio enter
ls
cd ..
hab studio enter
ls
cd habitat
sudo nano plan.sh
ls
cd ..
cd imagemagick/
ls
sudo nano plan.sh
cd ..
hab studio enter
ls
cd habitat
ls
sudo nano plan.sh
cd ..
hab studio enter
export HAB_ORIGIN=mbohl
docker run -p 8000:8000 $HAB_ORIGIN/habitatize
docker stop -p 8000:8000 $HAB_ORIGIN/habitatize
docker stop --help
docker stop f99120c2995f
docker ps
docker run -p 8000:8000 $HAB_ORIGIN/habitatize
ls
cd results
ls
cd ..
ls
git clone https://github.com/learn-chef/hab-custom-config
cd ~/hab-custom-config
ls
hab studio enter
ls
sudo nano habitat/default.toml
hab studio enter
ls
cd hab-custom-config
hab studio enter
ls
cd habitat
ls
sudo nano plan.sh
ls
sudo nano default.toml
hab studio enter
cd ..
hab studio enter
cd ~
mkdir webapp
cd webapp
sudo nano hello-world
hab plan init
ls
cd habitat
ls
sudo nano plan.sh
cd ..
curl -o habitat/config/httpd.conf https://raw.githubusercontent.com/learn-chef/habitat-build-plan-legacy/master/habitat/config/httpd.conf
curl -o habitat/default.toml https://raw.githubusercontent.com/learn-chef/habitat-build-plan-legacy/master/habitat/default.toml
ls
cd habitat
ls
cd config
ls
sudo nano httpd.conf
cd ..
ls
cd habitat
ls
cd hooks
ls
sudo nano init
cd ..
hab studio enter
cd ~
git remote add origin https://github.com/MeganBohl/Habitat.git
ls
cd results
ls
cd ~
ls
sudo yum install git
git remote add origin https://github.com/MeganBohl/Habitat.git
git init
git remote add origin https://github.com/MeganBohl/Habitat.git
git push -u origin master
git status
sudo nano .gitignore
