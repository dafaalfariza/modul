```bash
-- Membuat database sederhana
CREATE DATABASE IF NOT EXISTS sigap_db;

-- Menggunakan database
USE sigap_db;

-- Membuat tabel users sederhana
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nama VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    no_hp VARCHAR(20) NOT NULL,
    password VARCHAR(255) NOT NULL,
    role VARCHAR(10) DEFAULT 'user' NOT NULL
);
```

```bash
-- Data admin (password dalam plain text - HANYA UNTUK BELAJAR)
INSERT INTO users (nama, email, no_hp, password, role)
VALUES (
    'admin', 
    'admin@sigap.id', 
    '081122334455', 
    'admin123',  -- Password dalam plain text
    'admin'
);

-- Data user biasa (password dalam plain text - HANYA UNTUK BELAJAR)
INSERT INTO users (nama, email, no_hp, password, role)
VALUES (
    'user', 
    'user@test.com', 
    '085678901234', 
    'user123',  -- Password dalam plain text
    'user'
);
```

```bash
-- Buat di sql phpMyAdmin untuk bencana

CREATE TABLE data_bencana (
    id INT AUTO_INCREMENT PRIMARY KEY,
    jenis_bencana VARCHAR(50) NOT NULL,
    lokasi VARCHAR(100) NOT NULL,
    waktu_kejadian DATETIME DEFAULT CURRENT_TIMESTAMP
);
```
