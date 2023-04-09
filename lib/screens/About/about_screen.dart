import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  String? appVersion;
  @override
  void initState() {
    super.initState();
  }

  Future<void> main() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      appVersion = packageInfo.version;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
              Color.fromARGB(255, 6, 6, 59),
              Color.fromARGB(255, 0, 0, 35),
              Color.fromARGB(255, 0, 0, 12),
            ])),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: const Color.fromARGB(255, 4, 4, 54),
            elevation: 0,
            title: const Text(
              'About',
              style: TextStyle(
                  color: Colors.white,
                  fontStyle: FontStyle.italic,
                  letterSpacing: 2,
                  fontWeight: FontWeight.w600,
                  fontSize: 17.5),
            ),
          ),
          floatingActionButton: //user about
              Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                '       Made with ❤️ by Sahil Sorte',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    //fontStyle: FontStyle.italic,
                    letterSpacing: 0.5,
                    fontWeight: FontWeight.w400,
                    fontSize: 12),
              ),
              SizedBox(
                height: 40,
              )
            ],
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 30,
                ),
                Image.asset(
                  'images/logoh.png',
                  width: 150,
                  height: 150,
                ),
                const SizedBox(
                  height: 30,
                ),
                const Text(
                  'ChatX',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      //fontStyle: FontStyle.italic,
                      letterSpacing: 2,
                      fontWeight: FontWeight.w600,
                      fontSize: 35),
                ),
                if (appVersion == null)
                  const Text(
                    'v1.0.0',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        //fontStyle: FontStyle.italic,
                        letterSpacing: 1,
                        //fontWeight: FontWeight.w600,
                        fontSize: 15),
                  ),
                const SizedBox(
                  height: 40,
                ),
                const Text(
                  'This is an open-source project and can be found\non',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      //fontStyle: FontStyle.italic,
                      letterSpacing: 0.5,
                      fontWeight: FontWeight.w500,
                      fontSize: 15),
                ),

                const SizedBox(
                  height: 15,
                ),

                MaterialButton(
                  onPressed: () {
                    launchUrl(
                      Uri.parse(
                        'https://github.com/Sahil-pvt/ChatX',
                      ),
                      mode: LaunchMode.externalApplication,
                    );
                  },
                  child: const Text(
                    'GitHub',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        //fontStyle: FontStyle.italic,
                        //letterSpacing: 2,
                        fontWeight: FontWeight.w600,
                        fontSize: 35),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'If you liked my work\nshow some ❤️ and ⭐ the repo',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      //fontStyle: FontStyle.italic,
                      letterSpacing: 0.5,
                      fontWeight: FontWeight.w400,
                      fontSize: 15),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.greenAccent,
                  ),
                  onPressed: () {
                    launchUrl(
                      Uri.parse(
                        'https://www.buymeacoffee.com/sahilsorte',
                      ),
                      mode: LaunchMode.externalApplication,
                    );
                  },
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width / 2,
                    child: const Image(
                      image: AssetImage('images/bmc.png'),
                    ),
                  ),
                ),

                const SizedBox(
                  height: 15,
                ),

                const Text(
                  'Sponsor this project',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      //fontStyle: FontStyle.italic,
                      //letterSpacing: 0.5,
                      fontWeight: FontWeight.w400,
                      fontSize: 12),
                ),

                // const SizedBox(
                //   height: 310,
                // ),
                // Text(
                //   'ChatX- Chatting App',
                //   style: TextStyle(
                //     color: Colors.blue.shade500,
                //     fontStyle: FontStyle.italic,
                //     fontSize: 20,
                //     letterSpacing: .5,
                //   ),
                // )
              ],
            ),
          ),
        ));
  }
}
