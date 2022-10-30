import 'package:flutter/material.dart';
import 'package:admob_flutter/admob_flutter.dart';

void main(List<String> args) {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize without device test ids.
  Admob.initialize();

  // Or add a list of test ids.
  // Admob.initialize(testDeviceIds: ['YOUR DEVICE ID']);
  runApp(MaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //controladores para manipular os inputs, capturando os valores
  TextEditingController pesoController = new TextEditingController();
  TextEditingController alturaController = new TextEditingController();
  String _infoText = "Informe seus dados!";

  //chave global para validação dos campos
  GlobalKey<FormState> _chave = GlobalKey<FormState>();

  //chave dos anúncios
  final intertstitialAdIdAndroid = "ca-app-pub-5126662077040738/3150405819";
  AdmobInterstitial interstitialAd;

  @override
  void initState() {
    super.initState();

    interstitialAd = AdmobInterstitial(
      adUnitId: intertstitialAdIdAndroid,
      listener: (AdmobAdEvent event, Map<String, dynamic> args) {
        if (event == AdmobAdEvent.closed) interstitialAd.load();
        handleEvent(event, args, 'Interstitial');
      },
    );
    interstitialAd.load();
  }

//funcionalidades adicionais de premiação
  void handleEvent(
      AdmobAdEvent event, Map<String, dynamic> args, String adType) {
    switch (event) {
      case AdmobAdEvent.loaded:
        break;
      case AdmobAdEvent.opened:
        break;
      case AdmobAdEvent.closed:
        break;
      case AdmobAdEvent.failedToLoad:
        break;
      default:
    }
  }

  void _resetaCampo() {
    pesoController.text = "";
    alturaController.text = "";
    setState(() {
      _infoText = "Informe seus dados!";
      _chave = GlobalKey<FormState>();
    });
  }

//metodo responsável por exibir o anúncio
  void showInterstitial() async {
    if (await interstitialAd.isLoaded) {
      interstitialAd.show();
    }
  }

  void _calcular() {
    setState(() {
      double peso = double.parse(pesoController.text);
      double altura = double.parse(alturaController.text) / 100;
      double imc = peso / (altura * altura);
      if (imc < 18.6) {
        _infoText = "IMC - " +
            imc.toStringAsPrecision(3) +
            " está abaixo do peso recomendado";
      } else if (imc >= 18.6 && imc < 24.9) {
        _infoText =
            "IMC - " + imc.toStringAsPrecision(3) + " está no peso recomendado";
      } else if (imc >= 24.9 && imc < 29.9) {
        _infoText = "IMC - " +
            imc.toStringAsPrecision(3) +
            " está levemente acima do peso recomendado";
      } else if (imc >= 29.9 && imc < 34.9) {
        _infoText =
            "IMC - " + imc.toStringAsPrecision(3) + " ATENÇÃO: OBESIDADE GRAU I";
      } else if (imc >= 34.9 && imc < 40) {
        _infoText =
            "IMC - " + imc.toStringAsPrecision(3) + " CUIDADO: OBESIDADE GRAU II";
      } else if (imc >= 40) {
        _infoText =
            "IMC - " + imc.toStringAsPrecision(3) + " PERIGO! OBESIDADE GRAU III";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //extremamente importante para construção de barras e botões
        appBar: AppBar(
          title: Text("IMC - Calculadora"),
          centerTitle: true,
          backgroundColor: Colors.blueAccent,
          actions: <Widget>[
            IconButton(icon: Icon(Icons.refresh), onPressed: _resetaCampo)
          ],
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
          child: Form(
              key: _chave,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Icon(
                    Icons.person,
                    size: 120.0,
                    color: Colors.blueAccent,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        labelText: "Peso (kg)",
                        labelStyle: TextStyle(color: Colors.blueAccent)),
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.blueAccent, fontSize: 25.0),
                    controller: pesoController,
                    validator: (valor) {
                      if (valor.isEmpty) {
                        return "Insira seu peso!";
                      }
                    },
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        labelText: "Altura (cm)",
                        labelStyle: TextStyle(color: Colors.blueAccent)),
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.blueAccent, fontSize: 25.0),
                    controller: alturaController,
                    validator: (valor) {
                      if (valor.isEmpty) {
                        return "Insira sua altura!";
                      }
                    },
                  ),
                  Padding(
                      padding: EdgeInsets.only(top: 15.0, bottom: 10.0),
                      child: Container(
                        height: 50.0,
                        child: RaisedButton(
                          onPressed: () {
                            if (_chave.currentState.validate()) {
                              _calcular();
                              showInterstitial();
                            }
                          },
                          child: Text(
                            "Calcular",
                            style:
                                TextStyle(color: Colors.white, fontSize: 25.0),
                          ),
                          color: Colors.blueAccent,
                        ),
                      )),
                  Text(
                    _infoText,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.blue, fontSize: 25.0),
                  )
                ],
              )),
        ));
  }
}
