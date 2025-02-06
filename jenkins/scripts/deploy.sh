#!/bin/bash

# Ambil variabel dari environment Jenkins
VM_USER="maviism"        # Ganti dengan username di VM
VM_HOST="http://98.66.137.249/"           # Ganti dengan IP VM
VM_PASSWORD="B@ndirma2025" # Diambil dari Jenkins Environment Variable

# File log untuk debugging
LOG_FILE="/tmp/deploy.log"

# Fungsi untuk eksekusi SSH dengan password pakai `sshpass`
ssh_execute() {
    sshpass -p "$VM_PASSWORD" ssh -o StrictHostKeyChecking=no "$VM_USER@$VM_HOST" "$1"
}

# 1️⃣ Pastikan `sshpass` tersedia
if ! command -v sshpass &> /dev/null; then
    echo "sshpass tidak ditemukan, install dulu" | tee -a "$LOG_FILE"
    exit 1
fi

# 2️⃣ Kirim file hasil build ke VM
echo "Mengirim file ke $VM_HOST..." | tee -a "$LOG_FILE"
sshpass -p "$VM_PASSWORD" scp -o StrictHostKeyChecking=no -r build "$VM_USER@$VM_HOST:/home/$VM_USER/react-app/"

# 3️⃣ Jalankan Docker di VM
echo "Menjalankan aplikasi di $VM_HOST..." | tee -a "$LOG_FILE"
ssh_execute "docker stop myapp-production || true"
ssh_execute "docker rm myapp-production || true"
ssh_execute "docker run -d --name myapp-production -p 3001:3001 -v /home/$VM_USER/react-app/build:/usr/share/nginx/html nginx:alpine"

echo "✅ Deployment selesai!" | tee -a "$LOG_FILE"
