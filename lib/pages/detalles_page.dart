import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:blueboxproject/album/album2.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Detalles extends StatefulWidget {
  const Detalles({super.key});

  @override
  State<Detalles> createState() => _DetallesState();
}

class _DetallesState extends State<Detalles> {
  int? id;
  late Future<List<Album2>> futureAlbum;
  bool isLoading = true;
  @override
  void initState() {
    super.initState();

    _getStoredUserData();
  }

  Future<void> _getStoredUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final storedId = prefs.getInt('id');
    setState(() {
      id = storedId;
    });
    _loadAlbumData();
  }

  void _loadAlbumData() {
    futureAlbum = fetchAlbum(id!).then((result) {
      return result;
    }).catchError((error) {
      print("Error fetching album: $error");
      return <Album2>[];
    }).whenComplete(() {
      setState(() {
        isLoading = false;
      });
    });
  }

  Future<List<Album2>> fetchAlbum(int id) async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://api.themoviedb.org/3/movie/$id?api_key=efbc2b95033e7dde757b6c455744baa2',
        ),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          "Access-Control-Allow-Origin": "*",
          "Access-Control-Allow-Methods":
              "POST, GET, OPTIONS, PUT, DELETE, HEAD",
        },
      );

      if (response.statusCode == 200) {
        print("response.bodyDETALLES:");
        print(response.body);

        final jsonData = jsonDecode(response.body);
        final Album2 albums = Album2.fromJson(jsonData);

        print("Álbum convertido:");
        print(albums);
        print("genresid");
        print(albums.genreids);
        return [albums];
      } else {
        throw Exception('Error al cargar el álbum');
      }
    } catch (e) {
      print("Error en fetchAlbum: $e");
      return <Album2>[];
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
            'Detalles',
            style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : FutureBuilder<List<Album2>>(
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
                        color: const Color.fromARGB(255, 39, 44, 61),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(15.0),
                                topRight: Radius.circular(15.0),
                              ),
                              child: Image.network(
                                movie.logoUrl,
                                height: 200,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(Icons.error,
                                      color: Colors.white);
                                },
                              ),
                            ),
                            const SizedBox(height: 20.0),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Column(
                                children: <Widget>[
                                  Text(
                                    movie.title,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 30.0,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 10.0),
                                  Text(
                                    movie.overview,
                                    style: const TextStyle(
                                      color: Colors.white70,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 20.0),
                                  Container(
                                    width: double.infinity,
                                    color: Color.fromARGB(61, 0, 0, 0),
                                    padding: const EdgeInsets.all(10.0),
                                    child: const Text(
                                      "Géneros",
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 15.0,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  const SizedBox(height: 10.0),
                                  Text(
                                    movie.genreids.join(", "),
                                    style: const TextStyle(
                                      color: Colors.white70,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 20.0),
                                  Container(
                                    width: double.infinity,
                                    color: Color.fromARGB(61, 0, 0, 0),
                                    padding: const EdgeInsets.all(10.0),
                                    child: const Text(
                                      "Budget",
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 15.0,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  const SizedBox(height: 10.0),
                                  Text(
                                    movie.budget.toString(),
                                    style: const TextStyle(
                                      color: Colors.white70,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 20.0),
                                  Container(
                                    width: double.infinity,
                                    color: Color.fromARGB(61, 0, 0, 0),
                                    padding: const EdgeInsets.all(10.0),
                                    child: const Text(
                                      "Popularity",
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 15.0,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  const SizedBox(height: 10.0),
                                  Text(
                                    movie.popularity.toString(),
                                    style: const TextStyle(
                                      color: Colors.white70,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 20.0),
                                  Container(
                                    width: double.infinity,
                                    color: Color.fromARGB(61, 0, 0, 0),
                                    padding: const EdgeInsets.all(10.0),
                                    child: const Text(
                                      "Release day",
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 15.0,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  const SizedBox(height: 10.0),
                                  Text(
                                    movie.releasedate,
                                    style: const TextStyle(
                                      color: Colors.white70,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20.0),
                          ],
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
