import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

void main() => runApp(MaterialApp(
      home: const JordanTourismApp(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        brightness: Brightness.light,
      ),
    ));

class JordanTourismApp extends StatefulWidget {
  const JordanTourismApp({super.key});

  @override
  _JordanTourismAppState createState() => _JordanTourismAppState();
}

class _JordanTourismAppState extends State<JordanTourismApp> {
  late VideoPlayerController _videoController;
  final AudioPlayer _audioPlayer = AudioPlayer();
  int _currentQuestionIndex = 0;
  int _score = 0;

  final List<Map<String, Object>> _questions = [
    {
      'question': 'ما هي المدينة الملقبة بالمدينة الوردية؟',
      'answers': ['البتراء', 'عمان', 'العقبة'],
      'correct': 'البتراء'
    },
    {
      'question': 'من هو القائد الذي بنى قلعة عجلون؟',
      'answers': ['صلاح الدين', 'عز الدين أسامة', 'بيبرس'],
      'correct': 'عز الدين أسامة'
    },
    {
      'question': 'ما هي مدينة الألف عمود التاريخية؟',
      'answers': ['إربد', 'جرش', 'السلط'],
      'correct': 'جرش'
    },
    {
      'question': 'أين يقع وادي القمر الشهير في الأردن؟',
      'answers': ['وادي رم', 'وادي الموجب', 'وادي شعيب'],
      'correct': 'وادي رم'
    },
    {
      'question': 'ما هو المنفذ البحري الوحيد للأردن؟',
      'answers': ['البحر الميت', 'نهر الأردن', 'العقبة'],
      'correct': 'العقبة'
    },
  ];

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.asset('assets/video.mp4')
      ..initialize().then((_) => setState(() {}));
  }

  @override
  void dispose() {
    _videoController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _answerQuestion(String selectedAnswer, StateSetter dialogState) {
    if (selectedAnswer == _questions[_currentQuestionIndex]['correct']) {
      _score++;
      _audioPlayer.play(AssetSource('success sound.mp3')); // صوت نجاح
    }
    dialogState(() {
      if (_currentQuestionIndex < _questions.length - 1) {
        _currentQuestionIndex++;
      } else {
        Navigator.pop(context); // إغلاق نافذة الأسئلة
        _showFinalResult(); // عرض النتيجة النهائية
      }
    });
  }

  void _showFinalResult() {
    if (_score >= 4) _audioPlayer.play(AssetSource('clap sound.mp3')); // صوت تصفيق للناجحين
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        title: const Text("النتيجة النهائية", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle_outline, color: Colors.green, size: 80),
            const SizedBox(height: 15),
            Text("لقد حصلت على $_score من 5", textAlign: TextAlign.center, style: TextStyle(fontSize: 22, color: Colors.green.shade800, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            const Text("ممتاز! استمر في استكشاف الهوية الوطنية الأردنية.", textAlign: TextAlign.center),
          ],
        ),
        actions: [
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade700, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
              onPressed: () => Navigator.pop(context),
              child: const Text("تم"),
            ),
          )
        ],
      ),
    );
  }

  void _showQuizDialog() {
    _currentQuestionIndex = 0;
    _score = 0;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          title: Text("سؤال ${_currentQuestionIndex + 1} من 5", textAlign: TextAlign.center, style: TextStyle(color: Colors.green.shade900)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(_questions[_currentQuestionIndex]['question'] as String, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
              const SizedBox(height: 25),
              ...(_questions[_currentQuestionIndex]['answers'] as List<String>).map((answer) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade50,
                      foregroundColor: Colors.green.shade900,
                      minimumSize: const Size(double.infinity, 45),
                      elevation: 3,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    ),
                    onPressed: () => _answerQuestion(answer, setDialogState),
                    child: Text(answer),
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text("اكتشف الهوية الوطنية الأردنية", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18)),
        centerTitle: true,
        backgroundColor: Colors.green.shade800,
        elevation: 8,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(bottom: Radius.circular(20))),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // قسم الفيديو الاحترافي
            if (_videoController.value.isInitialized)
              Container(
                margin: const EdgeInsets.all(15),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 5))]),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      AspectRatio(aspectRatio: _videoController.value.aspectRatio, child: VideoPlayer(_videoController)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: Icon(_videoController.value.isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill, color: Colors.white, size: 55),
                            onPressed: () => setState(() => _videoController.value.isPlaying ? _videoController.pause() : _videoController.play()),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text("أبرز المعالم السياحية والأثرية", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green.shade900)),
            ),

            // المناطق السياحية بمعلومات غنية (متطلب رقم 2)
            _buildModernLocationCard(
              "البتراء (المدينة الوردية)",
              "تعد البتراء من عجائب الدنيا السبع، نحتها الأنباط في الصخر الوردي قبل أكثر من 2000 عام. تضم الخزنة والسيق والدير، وهي رمز الحضارة الأردنية الأصيلة.  ",
              "assets/petra.webp",
              "تقع البتراء في محافظة معان وتعتبر أكبر مقاصد السياحة في الأردن. تم إدراجها في قائمة التراث العالمي لليونسكو عام 1985. اشتهرت بهندستها المعمارية المنحوتة في الصخر ونظام قنوات جر المياه القديم.",
            ),
            _buildModernLocationCard(
              "قلعة عجلون (قلعة الربض)",
              "بناها القائد عز الدين أسامة عام 1184م لحماية المنطقة من الهجمات، وتتميز بإطلالة رائعة على غور الأردن.",
              "assets/ajloun.webp",
              "تقع فوق جبل عوف، وهي مثال حي للعمارة الإسلامية العسكرية. لعبت دوراً حاسماً في الدفاع عن طرق القوافل التاريخية ضد الغزوات الخارجية. تطل على مناظر بانورامية خلابة لمحافظة عجلون وجبال عوف.",
            ),
            _buildModernLocationCard(
              "مدينة جرش الأثرية",
              "تُعرف بمدينة الألف عمود، وهي من أكبر المدن الرومانية المحافظة على معالمها في العالم. تضم المسرح الجنوبي، وشارع الأعمدة.",
              "assets/jerash.webp",
              "تقع جرش في شمال الأردن وتشتهر بكونها مثالاً رائعاً للهندسة المعمارية الرومانية المحافظة عليها. تضم العديد من المعالم البارزة مثل قوس هادريان، المسرح الجنوبي، وشارع الأعمدة المذهل.",
            ),
            _buildModernLocationCard(
              "وادي رم (وادي القمر)",
              "يتميز بجباله الشاهقة ورماله الحمراء الخلابة. يعد مقصداً لمحبي التخييم ومراقبة النجوم.",
              "assets/Rum.webp",
              "يقع في صحراء جنوب الأردن ويشتهر بجماله الطبيعي الفريد وتكويناته الصخرية الرائعة. يعد المكان الأمثل لتجربة مغامرات الصحراء مثل التخييم، رحلات السفاري بالسيارات الجبلية ومراقبة النجوم في سماء صافية.",
            ),
            _buildModernLocationCard(
              "ثغر الأردن الباسم (العقبة)",
              "المنفذ البحري الوحيد للأردن على البحر الأحمر. تشتهر بالشعاب المرجانية، والرياضات المائية.",
              "assets/aqaba.webp",
              "تقع العقبة على شواطئ البحر الأحمر وتعتبر بوابة الأردن البحرية ومنطقتها الاقتصادية والجمالية بمرجانها الخلاب. تعد مقصداً مفضلاً لمحبي الرياضات المائية والغوص لاستكشاف الشعاب المرجانية النادرة وتنوع الحياة البحرية.",
            ),

            // نظام التقييم (متطلب رقم 3)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4))]),
              child: Column(
                children: [
                  Text("قيم تجربتك في استكشاف الهوية الوطنية", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green.shade900)),
                  RatingBar.builder(
                    initialRating: 4,
                    itemBuilder: (context, _) => const Icon(Icons.star, color: Colors.amber),
                    onRatingUpdate: (rating) { if (rating >= 4) _audioPlayer.play(AssetSource('clap sound.mp3')); },
                  ),
                ],
              ),
            ),

            // زر الاختبار العصري (متطلب رقم 4)
            Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [Colors.green.shade700, Colors.red.shade800]), // ألوان علم الأردن
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 5))],
                ),
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  icon: const Icon(Icons.quiz_outlined, size: 28),
                  label: const Text("ابدأ اختبار المعلومات الوطني (5 أسئلة)", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  onPressed: _showQuizDialog,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModernLocationCard(String title, String subtitle, String imagePath, String details) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 5))]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: Image.asset(imagePath, height: 230, width: double.infinity, fit: BoxFit.cover, 
              errorBuilder: (context, error, stackTrace) => Container(height: 230, color: Colors.grey.shade300, child: const Icon(Icons.broken_image, size: 50)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold, color: Colors.green.shade900)),
                const SizedBox(height: 5),
                Text(subtitle, style: TextStyle(fontSize: 14, color: Colors.grey.shade700)),
                const SizedBox(height: 12),
                ExpansionTile(
                  title: const Text("المزيد عن هذه المنطقة", style: TextStyle(fontSize: 14, color: Colors.green, fontWeight: FontWeight.bold)),
                  leading: const Icon(Icons.info_outline, color: Colors.green),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(details, style: const TextStyle(fontSize: 13, color: Colors.black87, height: 1.6), textAlign: TextAlign.justify),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}