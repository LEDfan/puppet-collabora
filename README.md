# Installing Collabora online

```
# import the signing key
wget https://www.collaboraoffice.com/repos/CollaboraOnline/CODE-centos7/repodata/repomd.xml.key && rpm --import repomd.xml.key
# add the repository URL to yum
yum-config-manager --add-repo https://www.collaboraoffice.com/repos/CollaboraOnline/CODE-centos7
# perform the installation
yum install loolwsd CODE-brand
```

# Generating certificates
Needs to be done before `sudo systemctl start loolwsd` will work.
```
./vagrant/generate_ssl.sh
```

