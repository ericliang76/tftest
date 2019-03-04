#!/bin/bash -v

#install bind
yum update -y
yum install -y bind9 bind9utils bind9-doc dnsutils > /tmp/bindinstall.txt

#add eliang user for ssh
adduser eliang
mkdir -p /home/eliang/.ssh
chown -Rf eliang /home/eliang
cat <<-EOF >> /home/eliang/.ssh/authorized_keys
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDLFzQaLOct3lTGUZngX76D0PZ+I9u/axlsrDijplgbkRlp65UZVvlrk7gqenYxMJJO0iV/RlGd+h4Ei4fnXrNmwQV0DeQ+BgcH1oskLIrNDJDFW+4k3+Ir9oPSCoj0UfRX6i/ZgBdBnXa61npbOtIE4Yu0duMzceMOF3xtFQ/K6ZC1kobf1D7uPrpCYC3qVH6Jc0SKrS/aGCtFrr7v0FxNGL4GD1Jm282tQIKXa7tf1yzuB9WwZekwnoAF21vayN8iWe4GsPkgQgsHb8tsaqDtJ//iP5IkCWzyH/MFUxVGu4eWclhr7KBXmZ8IA7BiQscJu2N2S0S4CpacIVZHxA2F useast1-kp
EOF
echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config
sed -i 's/ssh_pwauth:   false/ssh_pwauth:   true/' /etc/cloud/cloud.cfg
echo -e "Passw0rd123!\nPassw0rd123!" | passwd eliang
echo "eliang		ALL = (ALL) ALL" >> /etc/sudoers

#pull over latest dns files from git

#enable/start services
systemctl restart sshd
systemctl enable bind
systemctl start bind



