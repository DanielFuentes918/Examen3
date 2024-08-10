import 'package:examen3/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


void main() async{
  await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(VotacionesApp());
}

class VotacionesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Votaciones App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
        '/create_album': (context) => CreateAlbumPage(),
      },
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Album> albums = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Votaciones App'),
      ),
      body: ListView.builder(
        itemCount: albums.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(albums[index].nombreBanda),
            subtitle: Text(albums[index].nombreAlbum),
            trailing: Text(albums[index].votos.toString()),
            onTap: () {
              setState(() {
                albums[index].incrementarVotos();
              });
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/create_album');
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class CreateAlbumPage extends StatefulWidget {
  @override
  _CreateAlbumPageState createState() => _CreateAlbumPageState();
}

class _CreateAlbumPageState extends State<CreateAlbumPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nombreAlbumController = TextEditingController();
  final TextEditingController _nombreBandaController = TextEditingController();
  final TextEditingController _anioLanzamientoController = TextEditingController();

  @override
  void dispose() {
    _nombreAlbumController.dispose();
    _nombreBandaController.dispose();
    _anioLanzamientoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crear Álbum de Rock'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nombreAlbumController,
                decoration: InputDecoration(
                  labelText: 'Nombre del Álbum',
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Por favor ingresa el nombre del álbum';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _nombreBandaController,
                decoration: InputDecoration(
                  labelText: 'Nombre de la Banda',
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Por favor ingresa el nombre de la banda';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _anioLanzamientoController,
                decoration: InputDecoration(
                  labelText: 'Año de Lanzamiento',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Por favor ingresa el año de lanzamiento';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    String nombreAlbum = _nombreAlbumController.text;
                    String nombreBanda = _nombreBandaController.text;
                    int anioLanzamiento = int.parse(_anioLanzamientoController.text);

                    Album album = Album(nombreAlbum, nombreBanda, anioLanzamiento);
                    setState(() {
                      albums.add(album);
                      FirebaseFirestore.instance.collection('DanielFuentes-20212020451').add({
                        'nombreAlbum': nombreAlbum,
                        'nombreBanda': nombreBanda,
                        'anioLanzamiento': anioLanzamiento,
                        'votos': 0,
                      });
                    });

                    Navigator.pop(context);
                  }
                },
                child: Text('Crear Album'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Album {
  String nombreAlbum;
  String nombreBanda;
  int anioLanzamiento;
  int votos;

  Album(this.nombreAlbum, this.nombreBanda, this.anioLanzamiento) : votos = 0;

  void incrementarVotos() {
    votos++;
  }
}