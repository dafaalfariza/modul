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

⚠️ Jangan pernah meng-upload file id_ed25519 (private key)!

🔐 Upload Public Key ke EC2

Lalu, tambahkan public key ke EC2 instance kamu:

Buka terminal lokal kamu powershell

ssh-keygen -t ed25519 -C "sumut.dafa@gmail.com"

jika muncul: Enter file in which to save the key (C:\Users\MyBook Hype/.ssh/id_ed25519):

- klik enter
- passpharse dan enter passpharse again = klik enter

### Pindahkan key ke ec2
```bash
cat ~/.ssh/id_ed25519.pub
```

Salin hasilnya. Contoh:
```bash
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJBrXGZrlZBfdPTAmJ7SZ0hQ6gvmsymgRVSAadDakZoY sumut.dafa@gmail.com
```

masuk ke terminal ssh ec2

masuk ke folder ec2
```bash
mkdir -p ~/.ssh
chmod 700 ~/.ssh
```
```bash
nano ~/.ssh/authorized_keys
```
Paste isi id_ed25519.pub ke baris baru, lalu tekan CTRL+X, lalu Y, lalu Enter. (yang tadi) pastekan dibawah key ec2 kita
```bash
chmod 600 ~/.ssh/authorized_keys
```

### Logout dari EC2 dan uji koneksi pakai key baru:
```bash
ssh -i ~/.ssh/id_ed25519 ec2-user@3.107.100.123
```

1. Salin Private Key (id_ed25519) ke GitHub Secrets
Private key ini akan dipakai GitHub Actions untuk login ke EC2 lewat SSH.

📍 Di GitHub:
Buka repositori kamu.

Masuk ke Settings > Secrets and variables > Actions.

Klik New repository secret.

Buat secret:

Name: EC2_KEY

Value: isi dengan private key (id_ed25519) kamu.

👉 Untuk ambil isi private key: (powershell)
```bash
cat ~/.ssh/id_ed25519
```

 2. Tambahkan Secrets Lainnya
Lakukan langkah yang sama untuk secrets berikut:

Secret Name	Value
EC2_HOST	Alamat public EC2 kamu, contoh: 3.107.xxx.xxx
EC2_USER	Nama user, biasanya: ec2-user

