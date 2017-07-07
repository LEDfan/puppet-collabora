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

# Firewall
For dev disable the firewall
```
sudo systemctl stop firewalld
sudo systemctl disable firewalld
```

# Ignore cert errors in richdocuments app
edit line 84 of apps/richdocuments/lib/WOPI/DiscoveryManager.php to:
```
$response = $client->get($wopiDiscovery, ["verify" => false]);
```

# add exception in firefox for the IP/url

# change `/etc/loolwsd/loolwsd.xml` servername to name of Nextcloud instance

# change the default apache config
```
  ProxyPass   /lool/adminws wss://127.0.0.1:9980/lool/adminws nocanon
```

# add nextcloud to allowed hosts for WOPI
Add at line 79 of `/etc/loolwsd/loolwsd.xml`
```
<host desc="Regex pattern of hostname to allow or deny." allow="true">pp-nc\.local</host>
```

# add nextcloud host to /etc/hosts


And then everything will fail because loolwsd needs to connect to WOPI (the storage backend which is running on Nextcloud) but only wants to do it over ssl.
