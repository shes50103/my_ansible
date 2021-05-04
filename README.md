https://cloud.digitalocean.com/

- Ubuntu 18.04 (LTS) x64
- 2G RAM

- 啟動指令
ansible-playbook -v -u root -i `機器IP`, setup.yml
master.key

- 需要這兩個檔案
"~/.ssh/id_rsa"
"~/.ssh/master.key"
