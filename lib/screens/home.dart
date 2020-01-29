import 'package:flutter/material.dart';
import 'package:musica/models/theme_provider.dart';
import 'package:musica/widgets/home_list.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';
import 'package:provider/provider.dart';
import '../models/songs.dart';
import '../widgets/settings.dart';
import '../utils/theme.dart';

class Home extends StatefulWidget {
  static const id = 'homeroute';

  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  var height;
  var width;
  var songData;
  var themeNotifier;

  @override
  Widget build(BuildContext context) {
height = MediaQuery.of(context).size.height;
width = MediaQuery.of(context).size.width;
  songData = Provider.of<SongData>(context);
themeNotifier = Provider.of<ThemeNotifier>(context);
    return SafeArea(
      child: Stack(
        children: <Widget>[
          WaveWidget(
            config: CustomConfig(

              gradients: themeNotifier.theme == darkTheme ? [
                [Color(0xFF212121), Color(0xFF212121)],
                [Color(0xFF212121),  Color(0xFF212121)],
                [Color(0xFF212121),  Color(0xFF212121)],
                [Color(0xFF212121), Color(0xFF212121)]
              ] : [
                [Colors.lightBlueAccent, Colors.lightBlueAccent],
                [Colors.lightBlueAccent, Colors.lightBlueAccent],
                [Colors.lightBlueAccent, Colors.lightBlueAccent],
                [Colors.lightBlueAccent, Colors.lightBlueAccent]
              ],
              durations: [35000, 19440, 10800, 6000],
              heightPercentages: [0.28, 0.31, 0.33, 0.38],
              blur: MaskFilter.blur(BlurStyle.solid, 10),
              gradientBegin: Alignment.bottomLeft,
              gradientEnd: Alignment.topRight,
            ),
            waveAmplitude: 0,

            backgroundColor: themeNotifier.theme == darkTheme ? Color(0xFF212121) : Colors.white,
            size: Size(
              double.infinity,
              double.infinity,
            ),
          ),
          Positioned(top: 15.0, right: 5.0 , child: IconButton(icon: Icon(Icons.settings), color: themeNotifier.theme == darkTheme ? Colors.white : Colors.black54, onPressed: () {showModalBottomSheet(
            context: context,
            builder: (context) => SettingsScreen(),
          );},),),

          Positioned(
   top: 20.0,
   left: 100.0,
   right: 100.0,
   bottom: 20.0,
                      
                        child:    Container(
                          height: height / 3,
                          
                          child: Column(
                           
                               
              children: <Widget>[
                CircleAvatar(
                  
                                backgroundColor: Colors.transparent,            
                                            backgroundImage: AssetImage(
                            'assets/images/Musepng.png',
                          ),
                                            radius: 50,
                                          ),
SizedBox(height: 10.0,),
                                        Text('${songData.songs.length} songs', style: TextStyle(color: themeNotifier.theme == darkTheme ? Colors.white : Colors.black54, fontSize: 15.0, fontStyle: FontStyle.italic),),
              ],
            ),
                        ),
             
                        
          ),
         Positioned(top: height / 3, child: Container(height: height * 0.5, width: width,  child: Padding(
           padding: const EdgeInsets.symmetric(horizontal: 10.0),
           child: HomeList(),
         )))
        ],
      ),
    );
  }
}
