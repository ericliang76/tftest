#!/bin/bash -v
yum install -y wget > /tmp/wget.log

cat <<-EOF >> /etc/yum.repos.d/nginx.repo
[nginx]
name=nginx repo
baseurl=http://nginx.org/packages/mainline/rhel/7/\$basearch/
gpgcheck=0
enabled=1
EOF



yum install -y nginx > /tmp/nginx.log
#cat <<-EOF >> /etc/yum.repos.d/extras.repo
#[CentOS-extras]
#name=CentOS-7-Extras
#mirrorlist=http://mirrorlist.centos.org/?release=7&arch=\$basearch&repo=extras&infra=\$infra
##baseurl=http://mirror.centos.org/centos/$releasever/extras/\$basearch/
#gpgcheck=0
#gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7
#EOF

yum-config-manager --enable rhui-REGION-rhel-server-extras
yum install -y docker > /tmp/docker.log
useradd eliang
mkdir -p /home/eliang/.ssh
chown -Rf eliang /home/eliang
cat <<-EOF >> /home/eliang/.ssh/authorized_keys
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDLFzQaLOct3lTGUZngX76D0PZ+I9u/axlsrDijplgbkRlp65UZVvlrk7gqenYxMJJO0iV/RlGd+h4Ei4fnXrNmwQV0DeQ+BgcH1oskLIrNDJDFW+4k3+Ir9oPSCoj0UfRX6i/ZgBdBnXa61npbOtIE4Yu0duMzceMOF3xtFQ/K6ZC1kobf1D7uPrpCYC3qVH6Jc0SKrS/aGCtFrr7v0FxNGL4GD1Jm282tQIKXa7tf1yzuB9WwZekwnoAF21vayN8iWe4GsPkgQgsHb8tsaqDtJ//iP5IkCWzyH/MFUxVGu4eWclhr7KBXmZ8IA7BiQscJu2N2S0S4CpacIVZHxA2F useast1-kp
EOF
echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config
sed -i 's/ssh_pwauth:   false/ssh_pwauth:   true/' /etc/cloud/cloud.cfg
echo -e "Passw0rd123!\nPassw0rd123!" | passwd eliang
echo "eliang		ALL = (ALL) ALL" >> /etc/sudoers

systemctl enable nginx
systemctl enable docker
systemctl restart sshd
systemctl start nginx
systemctl start docker



