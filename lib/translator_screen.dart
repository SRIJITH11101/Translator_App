import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:translator/translator.dart';
import 'package:translator_app/constants.dart';

class TranslatorScreen extends StatefulWidget {
  const TranslatorScreen({super.key});

  @override
  State<TranslatorScreen> createState() => _TranslatorScreenState();
}

class _TranslatorScreenState extends State<TranslatorScreen> {
  final translator = GoogleTranslator();
  SpeechToText stt = SpeechToText();
  bool _speechEnabled = false;
  String _recognisedWords = '';

  String? selectedInputLang = "English (US)";
  String? selectedTransLang = "English (US)";
  TextEditingController inputTextController = TextEditingController();
  TextEditingController translatedTextController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initSpeech();
  }

  void initSpeech() async {
    _speechEnabled = await stt.initialize();
    setState(() {});
  }

  void startListen() async {
    await stt.listen(
      onResult: (result) {
        setState(() {
          _recognisedWords = result.recognizedWords;
          inputTextController.text = _recognisedWords;
        });
      },
    );
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      if (stt.hasRecognized) {
        _recognisedWords = result.recognizedWords;
      } else {
        print("Not recognised");
        _recognisedWords = '';
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Could not recognise the speech')));
      }
    });
  }

  void stopListen() async {
    await stt.stop();
    setState(() {
      //_recognisedWords = "";
    });
  }

  void translating(String selectedInputLang, String seletedTransLang,
      String inputText) async {
    String selectedInpCode = langCodes[selectedInputLang]!;
    String selectedOutCode = langCodes[seletedTransLang]!;
    try {
      if (inputText.isEmpty) {
        translatedTextController.text = "";
      } else {
        await translator
            .translate(inputText, from: selectedInpCode, to: selectedOutCode)
            .then((value) {
          print(value);
          translatedTextController.text = value.toString();
        });
      }
      //print('${translaion.text}');
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
      print(e.toString());
    }
    ;
  }

  @override
  void dispose() {
    inputTextController.dispose();
    translatedTextController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Translator App',
            style: TextStyle(fontSize: 27, fontWeight: FontWeight.w700),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            //mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Enter the text needed to be translated:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 15,
              ),
              DropdownButton(
                // Initial Value
                value: selectedInputLang,
                // Down Arrow Icon
                icon: const Icon(Icons.keyboard_arrow_down),
                // Array list of items
                items: langNames.map((String item) {
                  return DropdownMenuItem(
                    value: item,
                    child: Text(item),
                  );
                }).toList(),

                onChanged: (String? newValue) {
                  setState(() {
                    //print(newValue);
                    selectedInputLang = newValue;
                    print(selectedInputLang);
                  });
                },
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    height: 50,
                    width: MediaQuery.of(context).size.width / 1.2,
                    child: TextField(
                      decoration:
                          const InputDecoration(hintText: 'Enter the text'),
                      controller: inputTextController,
                      maxLines: 5,
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        if (stt.isNotListening) {
                          _recognisedWords = "";
                          startListen();
                          //print(_recognisedWords);
                          setState(() {
                            //inputTextController.text = _recognisedWords;
                          });
                        } else {
                          stopListen();
                          print(_recognisedWords);
                          setState(() {
                            // inputTextController.text = _recognisedWords;
                          });
                          //inputTextController.text = _recognisedWords;
                          //inputTextController.clear();
                        }
                      },
                      icon:
                          Icon(stt.isNotListening ? Icons.mic_off : Icons.mic))
                ],
              ),
              const SizedBox(
                height: 25,
              ),
              const Text(
                'The translated text is:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 15,
              ),
              DropdownButton(
                // Initial Value
                value: selectedTransLang,
                // Down Arrow Icon
                icon: const Icon(Icons.keyboard_arrow_down),
                // Array list of items
                items: langNames.map((String items) {
                  return DropdownMenuItem(
                    value: items,
                    child: Text(items),
                  );
                }).toList(),
                // After selecting the desired option,it will
                // change button value to selected value
                onChanged: (String? newValue) {
                  setState(() {
                    selectedTransLang = newValue;
                  });
                },
              ),
              SizedBox(
                height: 50,
                width: MediaQuery.of(context).size.width / 1.2,
                child: TextField(
                  readOnly: true,
                  //enabled: false,
                  decoration: InputDecoration(hintText: 'Translate text'),
                  controller: translatedTextController,
                  maxLines: 5,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      translating(selectedInputLang!, selectedTransLang!,
                          inputTextController.text);
                    },
                    child: Container(
                      height: 50,
                      width: 150,
                      decoration: BoxDecoration(
                          color: Colors.black45,
                          borderRadius: BorderRadius.circular(20)),
                      child: const Center(
                        child: Text(
                          'Translate',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      inputTextController.clear();
                      translatedTextController.clear();
                    },
                    child: Container(
                      height: 50,
                      width: 150,
                      decoration: BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.circular(20)),
                      child: const Center(
                        child: Text(
                          'Clear',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    ));
  }
}
