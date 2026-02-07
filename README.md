# Open5GS + USRP 5G Network Simulation

Project ini dipakai buat simulasi jaringan 5G pakai **Open5GS sebagai core network** plus perangkat radio / simulator (UERANSIM atau USRP) buat testing UE dan RAN. Cocok buat belajar 5G core, network testing, sampai eksperimen performa jaringan.

---

## Overview

Di project ini kamu bisa:

- Jalankan core network 5G pakai Open5GS  
- Simulasi UE dan gNodeB (UERANSIM / USRP)  
- Setup subscriber lewat WebUI Open5GS  
- Tes koneksi jaringan pakai ping dan iperf  
- Eksperimen konfigurasi jaringan 5G langsung  

Biasanya dijalankan di Ubuntu (VM VirtualBox atau native Linux).

---

## Persiapan sebelum install

Pastikan sudah ada:

- Ubuntu 20.04 / 22.04 (recommended)
- Internet aktif
- Basic Linux command
- VirtualBox kalau pakai VM

---

## Install semua dependency + Open5GS + MongoDB + NodeJS

Update package dulu:

```bash
sudo apt update
sudo apt install -y gnupg wget curl git make gcc g++ \
libsctp-dev lksctp-tools iproute2 software-properties-common
```

### Install MongoDB

```bash
wget -qO - https://www.mongodb.org/static/pgp/server-6.0.asc | sudo apt-key add -

echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu \
focal/mongodb-org/6.0 multiverse" | \
sudo tee /etc/apt/sources.list.d/mongodb-org-6.0.list

sudo apt update
sudo apt install -y mongodb-org mongodb-org-database

sudo systemctl start mongodb
sudo systemctl enable mongodb
```

Cek MongoDB:

```bash
systemctl status mongodb
```

---

### Install NodeJS (buat WebUI Open5GS)

```bash
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt install nodejs
```

Cek:

```bash
node -v
npm -v
```

---

### Install Open5GS Core Network

```bash
sudo add-apt-repository ppa:open5gs/latest
sudo apt update
sudo apt install open5gs
```

Biasanya service langsung aktif setelah install.

---

### Install Open5GS WebUI

```bash
curl -fsSL https://open5gs.org/open5gs/assets/webui/install | sudo -E bash -
```

Akses di browser:

```
http://localhost:3000
```

Login default biasanya:

```
admin / 1423
```

---

## Tambahkan Subscriber (WAJIB)

Masuk ke WebUI:

1. Klik **Subscribers**
2. Klik **Add Subscriber**
3. Isi:

- IMSI  
- Key  
- OP / OPc  
- APN sesuai config UE  

Kalau subscriber belum ada → UE nggak bakal connect.

---

Nanti bakal muncul:

```
nr-gnb
nr-ue
```

---

## Konfigurasi gNodeB dan UE

Edit file config:

```
gnb.yaml
ue.yaml
```

Biasanya disesuaikan:

- IP core network
- IMSI subscriber
- Security key
- APN

Harus sama dengan data subscriber di Open5GS WebUI.

---

## Menjalankan simulasi

Jalankan gNodeB dulu:

```bash
./nr-gnb -c gnb.yaml
```

Baru jalankan UE:

```bash
./nr-ue -c ue.yaml
```

Kalau benar, UE bakal attach ke core network.

---

## Testing koneksi jaringan

### Ping Test

```bash
ping -I <ue-ip> <server-ip>
```

Kalau reply berarti koneksi berhasil.

---

### Bandwidth Test pakai iperf

Server:

```bash
iperf3 -s -B <server-ip>
```

Client:

```bash
iperf3 -c <server-ip> -B <ue-ip>
```

Bisa lihat throughput jaringan realtime.

---

## Struktur Project (contoh)

```
project-folder/
├── config/
│   ├── gnb.yaml
│   ├── ue.yaml
├── build/
│   ├── nr-gnb
│   ├── nr-ue
├── logs/
└── scripts/
```

---

## Kalau Ada Error Biasanya Karena:

- Subscriber belum ditambahkan  
- IMSI / Key beda  
- IP config salah  
- Service Open5GS belum jalan
- kesalahan pada penggunaan frekuensi
- interupsi terhadap perangkat asing yang menggunakan frekuensi kerja yang sama

Cek service:

```bash
systemctl status open5gs-*
```

---
