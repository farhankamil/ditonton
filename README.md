# ditonton

Repository ini merupakan project submission kelas Flutter Expert Dicoding.

## Tips Submission Akhir

Jika kamu menerapkan modular pada project, Anda dapat memanfaatkan berkas test.sh pada repository ini. Berkas tersebut dapat mempermudah proses testing melalui terminal atau command prompt. Sebelumnya menjalankan berkas tersebut, ikuti beberapa langkah berikut:

Install terlebih dahulu aplikasi sesuai dengan Operating System (OS) yang Anda gunakan.

Bagi pengguna Linux, jalankan perintah berikut pada terminal.

sudo apt-get update -qq -y
sudo apt-get install lcov -y

Bagi pengguna Mac, jalankan perintah berikut pada terminal.

brew install lcov

Bagi pengguna Windows, ikuti langkah berikut.

Install Chocolatey pada komputermu.
Setelah berhasil, install lcov dengan menjalankan perintah berikut.

choco install lcov

Kemudian cek Environtment Variabel pada kolom System variabels terdapat variabel GENTHTML dan LCOV_HOME. Jika tidak tersedia, Anda bisa menambahkan variabel baru dengan nilai seperti berikut.
