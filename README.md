### Tugas 7

1. Widget Tree dan Hubungan Parent-Child

    *Widget tree* adalah struktur pohon tempat seluruh tampilan Flutter disusun. Setiap elemen UI merupakan widget, dan sebuah widget dapat berisi widget lain di dalamnya. Widget yang membungkus disebut *parent*, sedangkan widget yang dibungkus disebut *child*.

    Dalam proses layout, parent mengirimkan batasan ukuran (*constraints*) kepada child. Child kemudian menentukan ukurannya sendiri berdasarkan batasan tersebut dan melaporkannya kembali kepada parent. Selanjutnya, parent menentukan posisi child di dalam layout. Ketika parent di-*rebuild*, child juga dapat ikut dibangun ulang.

    Pada proyek ini, struktur widget tree secara garis besar adalah sebagai berikut:

    ```text
    MaterialApp
    └── Scaffold
        ├── AppBar
        └── Padding
            └── Column
                ├── Row
                │   ├── InfoCard
                │   ├── InfoCard
                │   └── InfoCard
                ├── SizedBox
                └── Center
                    └── Column
                        ├── Text
                        └── GridView
                            └── ItemCard
    ```

    Di dalam `ItemCard`, terdapat susunan widget sebagai berikut:

    ```text
    Material
    └── InkWell
        └── Container
            └── Center
                └── Column
                    ├── Icon
                    └── Text
    ```

    Struktur tersebut menunjukkan bahwa setiap widget memiliki peran dan hubungan hierarkis dalam membentuk tampilan aplikasi.

2. Widget yang Digunakan dan Fungsinya

    Berikut adalah widget yang digunakan dalam proyek beserta fungsinya masing-masing:

    | Widget | Fungsi |
    |---|---|
    | `MaterialApp` | Menjadi root aplikasi yang menyediakan konfigurasi tema, judul, navigasi, dan halaman awal (`home`). |
    | `Scaffold` | Menyediakan kerangka dasar halaman, seperti `AppBar` dan `body`, serta menjadi tempat munculnya `SnackBar`. |
    | `AppBar` | Menampilkan bilah judul di bagian atas halaman. |
    | `Text` | Menampilkan teks, seperti judul, identitas, nama tombol, dan pesan sambutan. |
    | `Padding` | Memberikan jarak di sekeliling child widget. |
    | `Column` | Menyusun child widget secara vertikal. |
    | `Row` | Menyusun child widget secara horizontal, seperti tiga `InfoCard` yang ditampilkan sejajar. |
    | `Center` | Menempatkan child widget di tengah area yang tersedia. |
    | `SizedBox` | Memberikan jarak kosong dengan ukuran tertentu. |
    | `GridView.count` | Menampilkan kumpulan kartu tombol dalam bentuk kisi (*grid*) dengan jumlah kolom tetap, yaitu tiga kolom. |
    | `Card` | Menampilkan kartu bergaya Material Design yang dapat memiliki bayangan. Digunakan pada `InfoCard`. |
    | `Container` | Menampung widget lain sekaligus mengatur ukuran, warna, dan padding. |
    | `Material` | Menyediakan permukaan bergaya Material yang dapat diatur warna dan sudut membulatnya. Digunakan sebagai dasar `ItemCard`. |
    | `InkWell` | Membuat area yang dapat ditekan, memberikan efek riak (*ripple*), dan menjalankan fungsi melalui `onTap`. |
    | `Icon` | Menampilkan ikon pada tombol. |
    | `SnackBar` | Menampilkan notifikasi singkat di bagian bawah layar ketika tombol ditekan melalui `ScaffoldMessenger`. |

    Selain widget bawaan Flutter tersebut, proyek ini juga menggunakan beberapa widget buatan sendiri, yaitu:

    - `MyApp`: Widget utama yang menjadi titik awal aplikasi.
    - `MyHomePage`: Widget yang membangun halaman utama aplikasi.
    - `InfoCard`: Widget untuk menampilkan informasi dalam bentuk kartu.
    - `ItemCard`: Widget untuk menampilkan tombol berbentuk kartu yang dilengkapi ikon dan teks.

3. Fungsi MaterialApp dan Alasan Digunakan sebagai Root Widget

    `MaterialApp` merupakan widget yang menyediakan fondasi Material Design untuk aplikasi Flutter. Widget ini mengatur berbagai konfigurasi utama aplikasi, seperti:

    1. **Tema aplikasi:** Mengatur tampilan melalui properti `theme`, seperti warna dan gaya komponen.
    2. **Judul aplikasi:** Menentukan judul aplikasi melalui properti `title`.
    3. **Halaman awal:** Menentukan halaman pertama yang ditampilkan menggunakan properti `home`.
    4. **Navigasi:** Menyediakan sistem navigasi dan pengaturan rute melalui `Navigator`.
    5. **Konfigurasi tampilan:** Menyediakan akses terhadap informasi dan konfigurasi yang dibutuhkan widget di bawahnya, seperti tema dan informasi perangkat.

    `MaterialApp` umumnya digunakan sebagai *root widget* karena menjadi pembungkus utama yang menyediakan konfigurasi dan layanan bagi widget-widget di bawahnya. Dengan demikian, widget lain dapat mengakses informasi tersebut melalui `BuildContext`, misalnya menggunakan `Theme.of(context)` untuk mengambil tema aplikasi.

4. Perbedaan StatelessWidget dan StatefulWidget

    `StatelessWidget` dan `StatefulWidget` merupakan dua jenis widget dalam Flutter yang memiliki perbedaan utama pada pengelolaan state.

    **A. StatelessWidget**

    `StatelessWidget` adalah widget yang tidak menyimpan state internal yang dapat berubah. Tampilan widget ditentukan berdasarkan konfigurasi atau parameter yang diterima melalui konstruktor. Widget ini cocok digunakan untuk tampilan yang relatif tetap.

    Contohnya adalah tampilan halaman menu portofolio yang tidak membutuhkan perubahan state internal.

    **B. StatefulWidget**

    `StatefulWidget` adalah widget yang memiliki objek `State` terpisah untuk menyimpan data yang dapat berubah selama widget digunakan. Perubahan state dapat dilakukan menggunakan `setState()`, yang memberi tahu Flutter untuk membangun ulang tampilan widget.

    Widget ini cocok digunakan untuk tampilan yang perlu berubah berdasarkan interaksi pengguna atau perubahan data, seperti penghitung angka, isian form, checkbox, toggle, animasi, atau data yang dimuat dari jaringan.

    Perbedaan keduanya dapat dilihat pada tabel berikut:

    | Aspek | StatelessWidget | StatefulWidget |
    |---|---|---|
    | State internal | Tidak memiliki state internal yang dapat berubah. | Memiliki objek `State` untuk menyimpan data yang dapat berubah. |
    | Perubahan tampilan | Berdasarkan konfigurasi atau data yang diterima. | Dapat berubah ketika state diperbarui. |
    | Penggunaan | Tampilan yang relatif tetap. | Tampilan yang interaktif atau dinamis. |
    | Pembaruan | Dibangun ulang ketika konfigurasi berubah. | Dapat dibangun ulang melalui `setState()`. |

    Dengan demikian, `StatelessWidget` sebaiknya digunakan ketika tampilan tidak membutuhkan perubahan state internal, sedangkan `StatefulWidget` digunakan ketika tampilan perlu merespons perubahan data atau interaksi pengguna.

5. BuildContext dan Penggunaannya

    `BuildContext` adalah objek yang merepresentasikan lokasi sebuah widget di dalam *widget tree*. Melalui `BuildContext`, sebuah widget dapat mencari dan mengakses informasi dari widget-widget leluhurnya (*ancestor*).

    Beberapa contoh penggunaannya adalah:

    1. `Theme.of(context)`: Mengambil informasi tema aplikasi, seperti warna dan gaya tampilan.
    2. `MediaQuery.of(context)`: Mengambil informasi perangkat, seperti ukuran layar dan orientasi.
    3. `ScaffoldMessenger.of(context)`: Mengakses `ScaffoldMessenger` untuk menampilkan `SnackBar`.

    Di dalam metode `build(BuildContext context)`, parameter `context` merepresentasikan lokasi widget tersebut di dalam widget tree. Ketika digunakan untuk mencari informasi dari ancestor, pencarian dimulai dari posisi widget tersebut ke arah atas pohon.

    Pada proyek ini, `BuildContext` digunakan untuk mengambil warna tema pada `AppBar`, memperoleh lebar layar pada `InfoCard`, serta menampilkan `SnackBar` pada `ItemCard`.

    Dengan demikian, `BuildContext` berperan sebagai penghubung antara sebuah widget dan lingkungan tempat widget tersebut berada dalam struktur widget tree.

6. Hot Reload, Hot Restart, dan Full Restart

    *Hot reload* dan *hot restart* merupakan fitur Flutter yang membantu developer melihat perubahan kode dengan lebih cepat tanpa harus selalu menjalankan ulang aplikasi secara penuh.

    **A. Hot Reload**

    *Hot reload* adalah fitur yang memungkinkan developer menerapkan perubahan kode ke aplikasi yang sedang berjalan tanpa menghilangkan state aplikasi yang sedang aktif. Flutter akan memperbarui kode dan membangun ulang bagian tampilan yang diperlukan.

    Contoh perubahan yang umumnya dapat menggunakan hot reload:

    - Mengubah warna tombol.
    - Mengubah ukuran atau jenis font.
    - Mengubah teks yang ditampilkan.
    - Mengatur ulang tata letak widget.

    **B. Hot Restart**

    *Hot restart* adalah fitur yang menjalankan ulang aplikasi dari fungsi `main()`. Berbeda dengan hot reload, state aplikasi yang sedang berjalan akan direset dan kembali ke kondisi awal.

    Hot restart diperlukan ketika perubahan kode membutuhkan proses inisialisasi ulang, misalnya:

    - Mengubah isi fungsi `main()` atau inisialisasi variabel global dan static.
    - Mengubah proses inisialisasi state yang dijalankan melalui `initState()`.
    - Mengubah tipe widget dari `StatelessWidget` menjadi `StatefulWidget` atau sebaliknya.
    - Ketika perubahan kode tidak dapat diterapkan dengan hot reload.

    **C. Full Restart**

    *Full restart* dilakukan dengan menghentikan aplikasi yang sedang berjalan, kemudian menjalankannya kembali. Proses ini diperlukan ketika perubahan melibatkan konfigurasi atau kode native pada platform Android/iOS yang tidak dapat diterapkan hanya dengan hot reload atau hot restart.

    Contohnya:

    - Mengubah konfigurasi Gradle atau `AndroidManifest.xml`.
    - Mengubah berkas konfigurasi pada platform iOS.
    - Menambahkan plugin yang memerlukan konfigurasi native.
    - Mengubah konfigurasi build aplikasi.

    Dengan demikian, hot reload cocok digunakan untuk mempercepat proses pengembangan ketika melakukan perubahan kecil. Hot restart digunakan ketika aplikasi perlu menginisialisasi ulang state, sedangkan full restart diperlukan ketika perubahan melibatkan konfigurasi atau kode native platform.

---

### Penggunaan AI Tugas 7

Dalam tugas ini, saya menggunakan Claude untuk membantu mengimplementasikan persyaratan Tugas 7 pada proyek Flutter, termasuk penyesuaian kode dan tampilan aplikasi agar sesuai dengan ketentuan tugas.

**Lampiran Prompting:**
- **Tampilan Menu**: Bagaimana cara menyesuaikan dan mengimplementasikan kode pada proyek Flutter ini agar memenuhi seluruh persyaratan yang telah ditentukan dalam Tugas 7?

**AI Disclosure & Analisis**
- **Tools yang Digunakan**: Claude
- **Analisis Keterbatasan AI**: Saat membantu mengimplementasikan persyaratan tugas, terdapat beberapa masalah pada tampilan aplikasi, seperti tombol yang mengalami *overflow* sehingga tata letak tidak sesuai dengan ukuran layar. Kode yang diberikan AI belum sepenuhnya menghasilkan tampilan yang diharapkan sehingga masih diperlukan penyesuaian.
- **Perbaikan Manual (oleh Saya)**: Untuk mengatasi masalah tersebut, saya memeriksa kembali kode dan menyesuaikan ukuran serta tata letak widget yang mengalami *overflow*. Perbaikan dilakukan agar seluruh elemen dapat ditampilkan dengan baik, tidak saling bertumpuk, dan tetap sesuai dengan ukuran layar.

---