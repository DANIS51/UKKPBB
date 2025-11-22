class ImageModel {
  final String url;

  ImageModel({required this.url});

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(url: json['url'] ?? '');
  }
}

class Product {
  final String namaProduk;
  final int harga;
  final String deskripsi;
  final int stok;
  final String tanggalUpload;
  final List<ImageModel> images;

  Product({
    required this.namaProduk,
    required this.harga,
    required this.deskripsi,
    required this.stok,
    required this.tanggalUpload,
    required this.images,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      namaProduk: json['nama_produk'] ?? '',
      harga: int.tryParse(json['harga'] ?? '0') ?? 0,
      deskripsi: json['deskripsi'] ?? '',
      stok: int.tryParse(json['stok'] ?? '0') ?? 0,
      tanggalUpload: json['tanggal_upload'] ?? '',
      images: (json['images'] as List<dynamic>? ?? [])
          .map((e) => ImageModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
