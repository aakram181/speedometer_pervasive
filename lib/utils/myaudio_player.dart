import 'package:audioplayers/audioplayers.dart';
AudioPlayer player = AudioPlayer();


class MyAudioPlayer{
  late AudioPlayer player;
  bool playing = false;

  MyAudioPlayer(){
    this.player = AudioPlayer();
  }

  void playWarning() async {
    print('hi');

    if(!playing){
      playing = true;
    final cache = AudioCache();
    player = await cache.loop('beep-01a.mp3');
  }
  }

  void stopWarning(){
    playing = false;
    player?.stop();
  }

}