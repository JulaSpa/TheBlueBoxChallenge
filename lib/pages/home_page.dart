import 'package:flutter/material.dart';
import 'package:blueboxproject/album/album.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<List<Album>> futureAlbum;
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    // Obtener los valores de SharedPreferences
    _loadAlbumData();
  }

  void _loadAlbumData() {
    futureAlbum = fetchAlbum().then((result) {
      return result;
    }).catchError((error) {
      print("Error fetching album: $error");
      return <Album>[]; // Devuelve una lista vacía en caso de error.
    }).whenComplete(() {
      setState(() {
        // Cuando se complete la operación, establece isLoading en falso.
        isLoading = false;
      });
    });
  }

  Future<List<Album>> fetchAlbum() async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://api.themoviedb.org/3/trending/movie/week?api_key=efbc2b95033e7dde757b6c455744baa2',
        ),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          "Access-Control-Allow-Origin": "*",
          "Access-Control-Allow-Methods":
              "POST, GET, OPTIONS, PUT, DELETE, HEAD",
        },
      );

      if (response.statusCode == 200) {
        print("response.body:");
        print(response.body);
        // Parseamos la respuesta si es exitosa
        final jsonData = jsonDecode(response.body);
        final moviesList = jsonData['results'] as List;
        print("movie list");
        print(moviesList);
        final List<Album> albums =
            moviesList.map((albumJson) => Album.fromJson(albumJson)).toList();
        print("albums");
        print(albums);
        return albums;
      } else {
        // Si la respuesta no es 200, lanza un error
        throw Exception('Error al cargar el álbum');
      }
    } catch (e) {
      print("Error en fetchAlbum: $e");
      return <Album>[]; // Devuelve una lista vacía en caso de error.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 59, 65, 90),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 39, 44, 61),
        title: const Center(
          child: Text(
            'Lista', // El texto que quieres mostrar
            style: TextStyle(
                color: Color.fromARGB(255, 255, 255, 255)), // Color del texto
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : FutureBuilder<List<Album>>(
              future: futureAlbum,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final movies = snapshot.data!;

                  return ListView.builder(
                    itemCount: movies.length,
                    itemBuilder: (context, index) {
                      final movie = movies[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 16.0),
                        color: Color.fromARGB(255, 39, 44, 61),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(right: 20.0),
                                child: Image.network(
                                  movie.logoUrl,
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(Icons.error,
                                        color: Colors.white);
                                  },
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      movie.title,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.0,
                                      ),
                                    ),
                                    const SizedBox(
                                        height:
                                            10.0), // Espacio entre el título y la descripción
                                    Text(
                                      movie.overview,
                                      style: const TextStyle(
                                          color: Colors.white70),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: IconButton(
                                  icon: const Icon(Icons.add_circle_outline),
                                  color: Colors.blue,
                                  iconSize: 30.0,
                                  onPressed: () async {
                                    final int id = movie.id;
                                    // Guardar en SharedPreferences
                                    final prefs =
                                        await SharedPreferences.getInstance();
                                    await prefs.setInt('id', id);
                                    Navigator.pushNamed(
                                      context,
                                      "/detalles",
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
    );
  }
}
