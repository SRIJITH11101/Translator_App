import 'package:flutter/material.dart';
import 'package:translator/translator.dart';
import 'package:translator_app/constants.dart';

class TranslatorScreen extends StatefulWidget {
  const TranslatorScreen({super.key});

  @override
  State<TranslatorScreen> createState() => _TranslatorScreenState();
}

class _TranslatorScreenState extends State<TranslatorScreen> {
  final translator = GoogleTranslator();

  String? selectedInputLang = "English (US)";
  String? selectedTransLang = "English (US)";
  TextEditingController inputTextController = TextEditingController();
  TextEditingController translatedTextController = TextEditingController();

  void translating(String selectedInputLang, String seletedTransLang,
      String inputText) async {
    String selectedInpCode = langCodes[selectedInputLang]!;
    String selectedOutCode = langCodes[seletedTransLang]!;
    try {
      if (inputText.isEmpty) {
        translatedTextController.text = "";
      } else {
        var translaion = await translator
            .translate(inputText, from: selectedInpCode, to: selectedOutCode)
            .then((value) {
          print(value);
          translatedTextController.text = value.toString();
        });
      }
      //print('${translaion.text}');
    } catch (e) {
      translatedTextController.text = e.toString();
      print(e.toString());
    }
    ;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Center(
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
              Text(
                'Enter the text needed to be translated:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              SizedBox(
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
                // After selecting the desired option,it will
                // change button value to selected value
                onChanged: (String? newValue) {
                  setState(() {
                    //print(newValue);
                    selectedInputLang = newValue;
                    print(selectedInputLang);
                  });
                },
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                height: 50,
                width: MediaQuery.of(context).size.width / 1.2,
                child: TextField(
                  decoration: InputDecoration(hintText: 'Enter the text'),
                  controller: inputTextController,
                  maxLines: 5,
                ),
              ),
              SizedBox(
                height: 25,
              ),
              Text(
                'The translated text is:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              SizedBox(
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
              Container(
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
              SizedBox(
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
                      child: Center(
                        child: Text(
                          'Translate',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                      decoration: BoxDecoration(
                          color: Colors.black45,
                          borderRadius: BorderRadius.circular(20)),
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
                      child: Center(
                        child: Text(
                          'Clear',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                      decoration: BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.circular(20)),
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
