import 'package:hiatunisie/app/style/app_style.dart';
import 'package:hiatunisie/views/authentication/sign_in.dart';
import 'package:hiatunisie/views/home/exports/export_homescreen.dart';


class OnBoard extends StatefulWidget {
  const OnBoard({super.key});

  @override
  _OnBoardState createState() => _OnBoardState();
}

class _OnBoardState extends State<OnBoard> {
  PageController pageController = PageController(initialPage: 0);

  List<Map<String, dynamic>> sliderList = [
    {
      "icon": 'images/onboard1.png',
      "title": 'Bienvenue sur YummyGo',
      "description": 'Découvrez vos plats préférés dans les restaurants à proximité.',
    },
    {
      "icon": 'images/onboard2.png',
      "title": 'Trouvez votre plat préféré',
      "description": 'Réservez facilement et obtenez un identifiant de confirmation instantanément.',
    },
    {
      "icon": 'images/onboard3.png',
      "title": 'Profitez de votre expérience !',
      "description": 'Accédez à votre réservation et savourez votre moment !',
    }

  ];

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  SmartScaffold(
        backgroundColor: white,
        body: Column(
          children: [    const SizedBox(height: 35), // Adds space from the top

            Consumer<OnBoardingProvider>(
              builder: (context, provider, child) {
                return provider.currentIndexPage < sliderList.length - 1
                    ? Align(
                        //alignement some space from the top
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const SignIn()),
                                (route) => false,
                              );
                            },
                            child: Text(
                              'Passer',
                              style: AppStyles.interMediumHeadline6
                                  .medium()
                                  .copyWith(
                                      color: kSecondaryColor, fontSize: 18),
                            ),
                          ),
                        ),
                      )
                    : const SizedBox(height: 55);
              },
            ),
            Expanded(
              child: PageView.builder(
                itemCount: sliderList.length,
                controller: pageController,
                onPageChanged: (int index) {
                  context
                      .read<OnBoardingProvider>()
                      .setCurrentIndexPage(index);
                },
                itemBuilder: (_, index) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        sliderList[index]['icon'],
                        fit: BoxFit.contain,
                        width: context.width() * 0.8,
                      ),
                      const SizedBox(height: 30),
                      Padding(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text(
                          sliderList[index]['title'].toString(),
                          textAlign: TextAlign.center,
                          style: AppStyles.interMediumHeadline6
                              .bold()
                              .withColor(Colors.blueGrey)
                              .withSize(30),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text(
                          sliderList[index]['description'].toString(),
                          textAlign: TextAlign.center,
                          style: AppStyles.interregularTitle.copyWith(
                              color: Colors.grey, fontSize: 18),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            Consumer<OnBoardingProvider>(
              builder: (context, provider, child) {
                return DotIndicator(
                  currentDotSize: 15,
                  dotSize: 6,
                  pageController: pageController,
                  pages: sliderList,
                  indicatorColor: kMainColor,
                  unselectedIndicatorColor: Colors.blueGrey,
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: GestureDetector(
                onTap: () {
                  final provider =
                      context.read<OnBoardingProvider>();
                  if (provider.currentIndexPage < sliderList.length - 1) {
                    pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  } else {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignIn()),
                      (route) => false,
                    );
                  }
                },
                child: Container(
                  width: double.infinity,
                  height: 55,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(35.0),
                    color: kMainColor,
                  ),
                  child: Center(
                    child: Consumer<OnBoardingProvider>(
                      builder: (context, provider, child) {
                        return Text(
                          provider.currentIndexPage < sliderList.length - 1
                              ? 'Suivant'
                              : 'Commencer',
                          style: kTextStyle.copyWith(
                            color: white,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
  }
}


class OnBoardingProvider with ChangeNotifier {
  int _currentIndexPage = 0;

  int get currentIndexPage => _currentIndexPage;

  void setCurrentIndexPage(int index) {
    _currentIndexPage = index;
    notifyListeners();
  }
}