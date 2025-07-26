## Buat Struktur Folder
project/

├── terraform/

│   ├── main.tf

├── register-app/

│   ├── app.py

│   ├── requirements.txt

│   ├── Dockerfile

|   └── .github/

|      └── workflows/

|        └── deploy.yml  ← file YAML ini

```bash
cd terraform
terraform init
terraform plan
terraform apply
```

sudo systemctl status docker

### Jika belum aktif
```bash
sudo systemctl start docker
sudo systemctl enable docker
```

### Cek apakah phpmyadmin sudah jalan
```bash
sudo docker ps
```

### Jika Belum
```bash
sudo docker run -d --name phpmyadmin \
  -e PMA_HOST=<ENDPOINT_RDS> \
  -e PMA_PORT=3306 \
  -e COOKIE_SECURE=false \
  -p 80:80 \
  phpmyadmin/phpmyadmin
```

Jika sudah buka kembali IP-EC2 akan masuk ke phpmyadmin

## Membuat Docker

cd register-app

code.
### Isi Dockerfile dengan
```bash
FROM python:3.10-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

CMD ["python", "app.py"]
```

### Isi requirements.txt
```bash
flask
pymysql
boto3
```

### Isi app.py

### Isi deploy.yml
```bash
name: Deploy to EC2

on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest

    steps:
    - name: Clone Repo
      uses: actions/checkout@v3

    - name: Upload to EC2 via SCP
      uses: appleboy/scp-action@v0.1.4
      with:
        host: ${{ secrets.EC2_HOST }}
        username: ec2-user
        key: ${{ secrets.EC2_KEY }}
        source: "."
        target: "/home/ec2-user/register-app"

    - name: SSH into EC2 and Build+Run Docker
      uses: appleboy/ssh-action@master
      with:
        host: ${{ secrets.EC2_HOST }}
        username: ec2-user
        key: ${{ secrets.EC2_KEY }}
        script: |
          cd /home/ec2-user/register-app
          docker stop register-app || true
          docker rm register-app || true
          docker build -t register-app .
          docker run -d -p 5000:5000 --name register-app register-app
```
Ubah bagian:

EC2_HOST = IP EC2 PUBLIC

EC2_KEY = Buat ssh key:

✅ Cara Membuat SSH Key (untuk EC2_KEY)

Lakukan ini di terminal (Windows WSL/Linux/macOS):
- ssh-keygen -t ed25519 -C "ci-cd-deploy"

Kalau ditanya lokasi simpan, tekan Enter untuk menyimpan default di:

~/.ssh/id_ed25519 (private)

~/.ssh/id_ed25519.pub (public)

🔐 Upload Public Key ke EC2

Lalu, tambahkan public key ke EC2 instance kamu:

Buka terminal lokal kamu.

ssh-keygen -t ed25519 -C "ci-cd-deploy"

jika muncul: Enter file in which to save the key (C:\Users\MyBook Hype/.ssh/id_ed25519):

- klik enter
