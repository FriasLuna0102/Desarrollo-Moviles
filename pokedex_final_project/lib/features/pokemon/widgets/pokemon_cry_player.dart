import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

// Singleton para el AudioPlayer
class AudioPlayerSingleton {
  static AudioPlayer? _instance;

  static AudioPlayer get instance {
    _instance ??= AudioPlayer();
    return _instance!;
  }

  static void dispose() {
    _instance?.dispose();
    _instance = null;
  }
}

class PokemonCryPlayer extends StatefulWidget {
  final int pokemonId;
  final String pokemonName;
  final Color backgroundColor;

  const PokemonCryPlayer({
    super.key,
    required this.pokemonId,
    required this.pokemonName,
    required this.backgroundColor,
  });

  @override
  State<PokemonCryPlayer> createState() => _PokemonCryPlayerState();
}

class _PokemonCryPlayerState extends State<PokemonCryPlayer> {
  bool _isPlaying = false;
  bool _isLoading = false;
  bool _hasError = false;

  AudioPlayer get _player => AudioPlayerSingleton.instance;

  @override
  void dispose() {
    // No disponemos del player aquí, ya que es compartido
    super.dispose();
  }

  Future<void> _playPokemonCry() async {
    if (_isPlaying || _isLoading) return;

    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      // Detener cualquier reproducción previa
      await _player.stop();

      String cryUrl = 'https://pokemoncries.com/cries/${widget.pokemonId}.mp3';
      debugPrint('Intentando reproducir: $cryUrl');

      final mediaItem = MediaItem(
        id: widget.pokemonId.toString(),
        title: "${widget.pokemonName}'s Cry",
        artist: 'Pokemon',
        artUri: Uri.parse('https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/home/${widget.pokemonId}.png'),
      );

      final audioSource = AudioSource.uri(
        Uri.parse(cryUrl),
        tag: mediaItem,
      );

      await _player.setAudioSource(audioSource);
      await _player.play();

      setState(() {
        _isPlaying = true;
        _isLoading = false;
      });

      _player.playerStateStream.listen((state) {
        if (state.processingState == ProcessingState.completed) {
          if (mounted) {
            setState(() {
              _isPlaying = false;
            });
          }
        }
      }, onError: (error) {
        debugPrint('Error en stream de reproducción: $error');
      });

    } catch (e) {
      debugPrint('Error reproduciendo el sonido: $e');
      setState(() {
        _hasError = true;
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('No se pudo reproducir el sonido de ${widget.pokemonName}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _stopPlaying() async {
    if (!_isPlaying) return;

    try {
      await _player.stop();
      setState(() {
        _isPlaying = false;
      });
    } catch (e) {
      debugPrint('Error deteniendo la reproducción: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: widget.backgroundColor.withOpacity(0.7),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.music_note,
            color: Colors.white,
            size: 24,
          ),
          const SizedBox(width: 8),
          const Text(
            'Escuchar Grito',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 16),
          IconButton(
            onPressed: _isPlaying ? _stopPlaying : _playPokemonCry,
            icon: _isLoading
                ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            )
                : Icon(
              _isPlaying ? Icons.stop : Icons.play_arrow,
              color: Colors.white,
              size: 32,
            ),
          ),
        ],
      ),
    );
  }
}