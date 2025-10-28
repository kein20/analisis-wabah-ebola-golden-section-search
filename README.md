# Analisis Wabah Ebola Menggunakan Regresi Polinomial dan Golden Section Search

Ini adalah Proyek Akhir untuk mata kuliah Sains Komputasi di Universitas Negeri Surabaya. Proyek ini menganalisis dataset wabah Ebola 2014-2016 di Afrika untuk memodelkan hubungan antara jumlah kasus terduga dan jumlah kematian terduga.

Metode yang digunakan adalah **Regresi Polinomial Orde 3** untuk membuat fungsi persamaan dari data, dan **Golden Section Search (GSS)** untuk mencari titik optimal (minimum dan maksimum) dari fungsi tersebut.

---

### 📊 Dataset

Dataset utama yang digunakan dalam analisis ini adalah **"Ebola Virus Dataset 2016 in Africa"** yang bersumber dari Kaggle. Dataset ini berisi data historis wabah, termasuk dua kolom utama yang dianalisis:
* `suspected_cases`: Jumlah kasus yang dicurigai.
* `suspected_deaths`: Jumlah kematian yang dicurigai.

---

### ⚙️ Metodologi

Analisis ini dilakukan menggunakan MATLAB/Octave dengan alur sebagai berikut:
1.  **Memuat Data:** Data kasus dan kematian dibaca dari file `data.csv`.
2.  **Regresi Polinomial:** Dibuat sebuah model regresi polinomial derajat 3 untuk memetakan hubungan antara `suspected_cases` (sebagai input, X) dan `suspected_deaths` (sebagai output, Y). Persamaan yang dihasilkan adalah:
    `y = 0.00000x³ - 0.00006x² + 0.67114x¹ - 71.16929`
3.  **Pencarian Titik Optimal:** Algoritma **Golden Section Search (GSS)** diimplementasikan secara manual dan melalui kode untuk menemukan titik minimum dan maksimum dari fungsi polinomial yang telah dibuat. Hasilnya juga dibandingkan dengan fungsi `fminbnd` bawaan.
4.  **Evaluasi Model:** Kinerja model regresi dievaluasi menggunakan metrik *Root Mean Squared Error* (RMSE) dan *Mean Absolute Error* (MAE).

---

### 🚀 Hasil Analisis

* **Model Regresi:** Model regresi polinomial orde 3 berhasil memetakan tren data dengan baik, dengan nilai **R² sebesar 0.91**.
* **Optimalisasi:** Metode Golden Section Search berhasil menemukan titik maksimum dan minimum dari fungsi.
    * **Titik Minimum (GSS):** x = 648.00, y = 338.22
    * **Titik Maksimum (GSS):** x = 8157.00, y = 3448.34
* **Error Model:**
    * **RMSE:** 265.999
    * **MAE:** 205.176

---

### 📂 File dalam Repository

* `analisis_ebola.m`: Skrip utama MATLAB/Octave yang berisi semua langkah analisis, mulai dari memuat data, regresi, optimasi GSS, hingga visualisasi.
* `data.csv`: Dataset yang digunakan langsung oleh skrip `analisis_ebola.m`, berisi dua kolom: `suspected_cases` dan `suspected_deaths`.
* `ebola_2014_2016_clean.csv`: Dataset mentah asli yang lebih lengkap sebagai referensi.
