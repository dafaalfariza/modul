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


