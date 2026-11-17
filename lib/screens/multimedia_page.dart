import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';

class MultimediaPage extends StatefulWidget {
  const MultimediaPage({super.key});

  @override
  State<MultimediaPage> createState() => _MultimediaPageState();
}

class _MultimediaPageState extends State<MultimediaPage> {
  final ImagePicker _picker = ImagePicker();
  final AudioRecorder _recorder = AudioRecorder();
  final AudioPlayer _player = AudioPlayer();
  final Stopwatch _recordingWatch = Stopwatch();

  XFile? _image;
  int? _imageSize;
  String? _audioPath;
  Timer? _recordingTimer;

  bool _recording = false;
  bool _busy = false;
  bool _microphonePermanentlyDenied = false;

  String get _formattedDuration {
    final totalSeconds = _recordingWatch.elapsed.inSeconds;
    final minutes = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  void _message(String text) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  Future<void> _chooseImage(ImageSource source) async {
    if (_busy) return;
    setState(() => _busy = true);

    try {
      final selected = await _picker.pickImage(
        source: source,
        imageQuality: 75,
      );
      if (!mounted) return;

      if (selected == null) {
        _message('Sélection annulée.');
        return;
      }

      final size = await selected.length();
      if (!mounted) return;

      setState(() {
        _image = selected;
        _imageSize = size;
      });
    } catch (e) {
      _message('Impossible de récupérer l’image : $e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _clearImage() {
    setState(() {
      _image = null;
      _imageSize = null;
    });
  }

  Future<void> _startRecording() async {
    if (_busy || _recording) return;

    if (kIsWeb || !(Platform.isAndroid || Platform.isIOS)) {
      _message('Enregistrement à tester sur Android ou iOS.');
      return;
    }

    setState(() => _busy = true);

    try {
      final status = await Permission.microphone.request();
      if (!mounted) return;

      setState(() {
        _microphonePermanentlyDenied = status.isPermanentlyDenied;
      });

      if (!status.isGranted) {
        _message('Microphone non autorisé.');
        return;
      }

      if (!await _recorder.hasPermission()) {
        _message('Autorisation microphone indisponible.');
        return;
      }
      if (!mounted) return;

      await _player.stop();
      if (!mounted) return;

      final path = '${Directory.systemTemp.path}/question_emsi.m4a';
      await _recorder.start(
        const RecordConfig(encoder: AudioEncoder.aacLc),
        path: path,
      );
      if (!mounted) return;

      _recordingWatch
        ..reset()
        ..start();

      setState(() {
        _recording = true;
        _audioPath = null;
      });

      _recordingTimer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (mounted) setState(() {});
      });
    } catch (e) {
      _message('Enregistrement impossible : $e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _stopRecording() async {
    if (_busy || !_recording) return;
    setState(() => _busy = true);

    try {
      final path = await _recorder.stop();
      if (!mounted) return;

      _recordingTimer?.cancel();
      _recordingWatch.stop();

      setState(() {
        _recording = false;
        _audioPath = path;
      });

      _message(
        path == null
            ? 'Aucun fichier enregistré.'
            : 'Question vocale enregistrée.',
      );
    } catch (e) {
      _message('Impossible d’arrêter l’enregistrement : $e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _playAudio() async {
    final path = _audioPath;
    if (path == null || _busy || _recording) return;

    setState(() => _busy = true);

    try {
      await _player.stop();
      if (!mounted) return;
      await _player.play(DeviceFileSource(path));
    } catch (e) {
      _message('Lecture impossible : $e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _openMicrophoneSettings() async {
    try {
      final opened = await openAppSettings();
      if (!opened) _message('Impossible d’ouvrir les réglages.');
    } catch (e) {
      _message('Impossible d’ouvrir les réglages : $e');
    }
  }

  @override
  void dispose() {
    _recordingTimer?.cancel();
    _recordingWatch.stop();
    _recorder.dispose();
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final image = _image;

    return PopScope<Object?>(
      canPop: !_recording && !_busy,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && _recording) {
          _message('Appuie sur « Arrêter » avant de quitter.');
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Espace multimédia')),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text('Image', style: TextStyle(fontSize: 20)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton.icon(
                  onPressed: _busy || _recording
                      ? null
                      : () => _chooseImage(ImageSource.camera),
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Prendre une photo'),
                ),
                OutlinedButton.icon(
                  onPressed: _busy || _recording
                      ? null
                      : () => _chooseImage(ImageSource.gallery),
                  icon: const Icon(Icons.photo_library),
                  label: const Text('Galerie'),
                ),
              ],
            ),
            if (image != null) ...[
              const SizedBox(height: 12),
              kIsWeb
                  ? Image.network(image.path, height: 190)
                  : Image.file(File(image.path), height: 190),
              const SizedBox(height: 8),
              Text('Nom du fichier : ${image.name}'),
              Text('Taille : $_imageSize octets'),
              OutlinedButton.icon(
                onPressed: _busy ? null : _clearImage,
                icon: const Icon(Icons.delete_outline),
                label: const Text('Effacer l’image'),
              ),
            ],
            const Divider(height: 40),
            const Text('Question vocale', style: TextStyle(fontSize: 20)),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: _busy
                  ? null
                  : (_recording ? _stopRecording : _startRecording),
              icon: Icon(_recording ? Icons.stop : Icons.mic),
              label: Text(_recording ? 'Arrêter' : 'Enregistrer'),
            ),
            if (_recording || _audioPath != null)
              Text('Durée : $_formattedDuration'),
            if (_audioPath != null && !_recording)
              OutlinedButton.icon(
                onPressed: _busy ? null : _playAudio,
                icon: const Icon(Icons.play_arrow),
                label: const Text('Écouter l’enregistrement'),
              ),
            if (_microphonePermanentlyDenied) ...[
              const SizedBox(height: 12),
              const Text(
                'Le microphone est bloqué. Autorise-le dans les réglages '
                'de l’application, puis réessaie.',
              ),
              OutlinedButton.icon(
                onPressed: _busy ? null : _openMicrophoneSettings,
                icon: const Icon(Icons.settings),
                label: const Text('Ouvrir les réglages'),
              ),
            ],
            if (_busy) const LinearProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
