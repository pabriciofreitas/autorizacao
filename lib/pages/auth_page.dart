import 'package:flutter/material.dart';

import '../theme.dart';
import '../utils/bubble_indicator_painter.dart';
import 'widgets/sign_in.dart';
import 'widgets/sign_up.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;

  Color left = Colors.black;
  Color right = Colors.white;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        body: SingleChildScrollView(
      physics:
          const ClampingScrollPhysics(), //impede que scroll role mais do que precisa
      //detecta quando é clicado
      child: GestureDetector(
        //quando clicar em qualquer parte do app
        onTap: () {
          //o foco do teclado será tirado
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Container(
          width: size.width,
          height: size.height,
          decoration: const BoxDecoration(
            //criar o gradiente
            gradient: LinearGradient(
              colors: <Color>[
                CustomTheme.loginGradientStart,
                CustomTheme.loginGradientEnd
              ],
              begin: FractionalOffset(
                  0.0, 0.0), //como as cores serão deslocada no começo
              end: FractionalOffset(
                  1.0, 1.0), //como as cores serão deslocada no fim
              stops: <double>[0.0, 1.0], //criar gradiente linear

              tileMode:
                  TileMode.clamp, //O modo que os gradientes irá se comportar
            ),
          ),
          child: Column(
            //mando a coluna tomar o maximo de tamanho possivel
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                //crio a imagem
                child: Image(
                    height:
                        size.height > 800 ? 191.0 : 150, //#determino o tamanho
                    fit: BoxFit.fill,
                    image: const AssetImage('assets/img/login_logo.png')),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: _buildMenuBar(context), //crio o botão de ir para nova
              ),
              Expanded(
                flex: 2,
                child: PageView(
                  controller: _pageController,
                  physics: const ClampingScrollPhysics(),
                  onPageChanged: (int index) {
                    //remover o foco dos textformfields quando troca de tela
                    FocusScope.of(context).requestFocus(FocusNode());
                    if (index == 0) {
                      //mudar a cor dos textos dos botões
                      setState(() {
                        right = Colors.white;
                        left = Colors.black;
                      });
                    } else if (index == 1) {
                      //mudar a cor dos textos dos botões
                      setState(() {
                        right = Colors.black;
                        left = Colors.white;
                      });
                    }
                  },
                  children: <Widget>[
                    //tela de login
                    ConstrainedBox(
                      constraints: const BoxConstraints.expand(),
                      child: SignIn(),
                    ),
                    //tela de cadastro

                    ConstrainedBox(
                      constraints: const BoxConstraints.expand(),
                      child: SignUp(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }

  Widget _buildMenuBar(BuildContext context) {
    return Container(
      width: 300.0,
      height: 50.0,
      decoration: const BoxDecoration(
        color: Color(0x552B2B2B),
        borderRadius: BorderRadius.all(Radius.circular(25.0)),
      ),
      //serve para desenhar coisas animadas na tela
      child: CustomPaint(
        //Esse componente que criei ele vai controlar animação da parte branca
        painter: BubbleIndicatorPainter(pageController: _pageController),
        //EU crio uma linha horizontal com seus filhos
        child: Row(
          mainAxisAlignment: MainAxisAlignment
              .spaceEvenly, //Aqui ele vai colocar um espaço padrão entre as linhas usando máximo de espaço
          children: <Widget>[
            Expanded(
              child: TextButton(
                style: ButtonStyle(
                  //determinado a cor ao aperta e segurar o botão
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                ),
                //se botão for pressionado ele chama a função dizendo que botão de existente clicou
                onPressed: _onSignInButtonPress,
                child: Text(
                  'Existing',
                  style: TextStyle(
                    color: left,
                    fontSize: 16.0,
                    fontFamily: 'WorkSansSemiBold',
                  ),
                ),
              ),
            ),
            Expanded(
              child: TextButton(
                style: ButtonStyle(
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                ),
                onPressed: _onSignUpButtonPress,
                child: Text(
                  'New',
                  style: TextStyle(
                      color: right,
                      fontSize: 16.0,
                      fontFamily: 'WorkSansSemiBold'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onSignInButtonPress() {
    _pageController.animateToPage(0,
        duration: const Duration(milliseconds: 500), curve: Curves.decelerate);
  }

  void _onSignUpButtonPress() {
    _pageController.animateToPage(1,
        duration: const Duration(milliseconds: 500), curve: Curves.decelerate);
  }
}
