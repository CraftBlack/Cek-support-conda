# Gunakan base image yang sudah ada Conda, ini JAUH lebih baik
# Anda tidak perlu lagi mengecek manual, karena sudah dijamin ada.
FROM continuumio/miniconda3:latest

# Tentukan direktori kerja di dalam container
WORKDIR /app

# Salin file environment.yml terlebih dahulu
# Docker akan men-cache layer ini jika file tidak berubah
COPY environment.yml .

# Buat environment Conda dari file .yml
# Ini sekaligus menjadi "tes" bahwa conda berfungsi dengan baik.
# Jika gagal membuat environment, build akan berhenti.
RUN conda env create -f environment.yml

# Salin sisa kode aplikasi Anda
COPY . .

# Cara yang benar untuk mengaktifkan environment Conda untuk perintah selanjutnya
# Ini akan memastikan setiap perintah `RUN`, `CMD`, `ENTRYPOINT` dijalankan di dalam environment `myapp-env`
SHELL ["conda", "run", "-n", "myapp-env", "/bin/bash", "-c"]

# Contoh: Periksa versi Python dari dalam environment yang aktif
RUN echo "Memverifikasi versi Python di dalam environment Conda..." && \
    python --version

# Perintah untuk menjalankan aplikasi Anda saat container dimulai
CMD ["python", "app.py"]
