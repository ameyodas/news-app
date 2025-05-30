import 'package:card_loading/card_loading.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:news_app/api/llm_tts_api.dart';
import 'package:news_app/news.dart';

class NewsData {
  String headline;
  String content;
  final String sourceUrl;

  NewsData({this.headline = '', this.content = '', required this.sourceUrl});

  NewsData.fromNews(INNews news)
      : headline = news.headline,
        content = news.content,
        sourceUrl = news.sourceUrl;

  NewsData.copyFrom(NewsData other)
      : headline = other.headline,
        content = other.content,
        sourceUrl = other.sourceUrl;

  NewsData cloneWith({String? headline, String? content, String? sourceUrl}) {
    return NewsData(
        headline: headline ?? this.headline,
        content: content ?? this.content,
        sourceUrl: sourceUrl ?? this.sourceUrl);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is NewsData &&
        other.headline == headline &&
        other.content == content;
  }

  @override
  int get hashCode => Object.hash(headline, content, sourceUrl);

  int estimateReadingTime() {
    final wordCount = content.trim().split(RegExp(r'\s+')).length;
    const wordsPerMinute = 225;
    final minutes = wordCount / wordsPerMinute;
    return minutes.ceil().clamp(1, double.infinity).toInt();
  }
}

class NewsAction {
  bool enabled;
  Map<String, String>? config;
  final Future<NewsData> Function(NewsData, Map<String, String>?) onTrigger;

  NewsData? _cacheIn;
  Map<String, String>? _cacheConfig;
  NewsData? _cacheOut;

  NewsAction({required this.onTrigger, this.enabled = false});

  Future<NewsData> call({required NewsData data, bool force = false}) async {
    if (!enabled) return Future.value(data);
    if (data == _cacheIn && config == _cacheConfig && !force) {
      debugPrint('cached action!');
      return Future.value(_cacheOut);
    }
    _cacheOut = await onTrigger(data, config);
    _cacheConfig = config;
    _cacheIn = data;
    return Future.value(_cacheOut!);
  }
}

class ActionButtonData {
  final Icon activeIcon;
  final Icon inactiveIcon;
  final String? label;
  final String? optionsTitle;
  final Icon? optionsIcon;
  final List<String>? options;
  final String? workingTitle;
  final String? errorTitle;
  final Map<String, String> Function(String)? configBuilder;

  NewsAction action;
  String? currentOption;

  ActionButtonData(
      {required this.activeIcon,
      required this.inactiveIcon,
      this.label,
      required this.action,
      this.options,
      this.currentOption,
      this.configBuilder,
      this.optionsTitle,
      this.optionsIcon,
      this.workingTitle,
      this.errorTitle});
}

class ActionBar extends StatefulWidget {
  final bool isVisible;
  final INNews news;
  final void Function(NewsData) onAction;

  const ActionBar(
      {super.key,
      required this.news,
      required this.onAction,
      this.isVisible = true});

  @override
  State<ActionBar> createState() => ActionBarState();
}

class ActionBarState extends State<ActionBar> {
  late List<ActionButtonData> _actions;
  bool _working = false;
  bool _error = false;
  String? _status;

  static const languages = {
    'Hindi • हिन्दी': 'Hindi',
    'Bengali • বাংলা': 'Bengali',
    'Marathi • मराठी': 'Marathi',
    'Telugu • తెలుగు': 'Telugu',
    'Tamil • தமிழ்': 'Tamil',
    'Gujarati • ગુજરાતી': 'Gujarati',
    'Urdu • اُردُو': 'Urdu',
    'Kannada • ಕನ್ನಡ': 'Kannada',
    'Odia • ଓଡ଼ିଆ': 'Odia',
    'Malayalam • മലയാളം': 'Malayalam',
    'Punjabi • ਪੰਜਾਬੀ': 'Punjabi',
    'Assamese • অসমীয়া': 'Assamese',
    'Maithili • मैथिली': 'Maithili',
    'Sanskrit • संस्कृतम्': 'Sanskrit',
    'Konkani • कोंकणी': 'Konkani',
    'Manipuri • মৈতৈলোন্ / মণিপুরী': 'Manipuri',
    'Bodo • बड़ो': 'Bodo',
    'Dogri • डोगरी': 'Dogri',
    'Santhali • ᱥᱟᱱᱛᱟᱲᱤ': 'Santhali',
    'Kashmiri • كٲشُر': 'Kashmiri',
    'Sindhi • سنڌي': 'Sindhi',
    'Nepali • नेपाली': 'Nepali',
  };

  @override
  void initState() {
    super.initState();

    _actions = <ActionButtonData>[
      ActionButtonData(
          activeIcon: const Icon(FluentIcons.filter_12_regular),
          inactiveIcon: const Icon(FluentIcons.filter_12_regular),
          label: 'Summarize',
          workingTitle: 'Summarizing...',
          errorTitle: 'Summarization failed',
          action: NewsAction(onTrigger: (data, config) async {
            final summary = await LLMApi.instance!.summarize(
                headline: data.headline,
                content: data.content,
                srcLink: data.sourceUrl);
            final result = data.cloneWith(content: summary!);
            return Future.value(result);
          })),
      ActionButtonData(
          inactiveIcon: const Icon(FluentIcons.translate_16_regular),
          activeIcon: const Icon(FluentIcons.translate_16_filled),
          label: 'Translate',
          options: languages.keys.toList(),
          optionsTitle: 'Translation Language',
          optionsIcon: const Icon(
            FluentIcons.translate_16_regular,
            color: Colors.blue,
          ),
          currentOption: languages.keys.first,
          workingTitle: 'Translating...',
          errorTitle: 'Translation failed',
          configBuilder: (option) {
            //debugPrint("\n\n\nlanguage: ${languages[option]!}");
            return {'target_lang': languages[option]!};
          },
          action: NewsAction(onTrigger: (data, config) async {
            final translation = await LLMApi.instance!.translate(
                headline: data.headline,
                content: data.content,
                targetLang: config == null
                    ? languages.values.first
                    : (config['target_lang'] ?? languages.values.first));

            final result = data.cloneWith(
                headline: translation!['headline']!,
                content: translation['content']!);
            return Future.value(result);
          })),
      ActionButtonData(
          inactiveIcon: const Icon(FluentIcons.play_circle_20_regular),
          activeIcon: const Icon(FluentIcons.play_circle_20_filled),
          label: 'Stream',
          action: NewsAction(onTrigger: (data, config) async => data)),
    ];
  }

  Future<NewsData> _callActionsStack(NewsData newsData) async {
    setState(() => _working = true);
    String? error;
    int actionIdx = 0;
    try {
      for (; actionIdx < _actions.length; ++actionIdx) {
        if (_actions[actionIdx].action.enabled) {
          setState(
              () => _status = _actions[actionIdx].workingTitle ?? 'Working...');
          error = _actions[actionIdx].errorTitle;
          newsData = await _actions[actionIdx].action.call(data: newsData);
        }
      }
      setState(() {
        _status = null;
        _working = false;
      });
    } catch (_) {
      setState(() {
        for (; actionIdx < _actions.length; ++actionIdx) {
          _actions[actionIdx].action.enabled = false;
        }
        if (error != null && error.isNotEmpty) {
          _working = false;
          _error = true;
          _status = error;
          Future.delayed(const Duration(seconds: 5)).then((_) => setState(() {
                _error = false;
                _status = null;
              }));
        }
      });
    }
    return Future.value(newsData);
  }

  void _showOptions(ActionButtonData actionData) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: false,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        builder: (context) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: [
                        if (actionData.optionsIcon != null)
                          actionData.optionsIcon!,
                        const SizedBox(width: 16.0),
                        Text(
                          actionData.optionsTitle ?? '',
                          style: const TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w600,
                            fontSize: 18.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12.0),
                  Flexible(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: actionData.options!.length,
                      itemBuilder: (context, idx) {
                        final option = actionData.options![idx];
                        final isSelected = option == actionData.currentOption;

                        return ListTile(
                          dense: true,
                          visualDensity: VisualDensity.compact,
                          title: Text(
                            option,
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 14.0,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                          leading: isSelected
                              ? const Icon(
                                  FluentIcons.checkmark_12_filled,
                                  color: Colors.blue,
                                  size: 18.0,
                                )
                              : const SizedBox(width: 18.0),
                          onTap: () {
                            actionData.currentOption = option;
                            if (actionData.configBuilder != null) {
                              actionData.action.config =
                                  actionData.configBuilder!(option);
                            }
                            Navigator.pop(context);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ));
  }

  Widget _buildActionButtons(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final barBgCol = isLight
        ? const Color.fromARGB(255, 240, 240, 240)
        : const Color.fromARGB(255, 16, 16, 16);

    final inactiveBtnBgCol = barBgCol;
    final activeBtnBgCol = isLight
        ? const Color.fromARGB(255, 210, 210, 210)
        : const Color.fromARGB(255, 48, 48, 48);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: _actions
            .map((actionData) => Container(
                  width: 60,
                  height: 36,
                  decoration: BoxDecoration(
                    color: actionData.action.enabled
                        ? activeBtnBgCol
                        : inactiveBtnBgCol,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton.filled(
                    padding: EdgeInsets.zero,
                    icon: actionData.inactiveIcon,
                    selectedIcon: actionData.activeIcon,
                    isSelected: actionData.action.enabled,
                    onPressed: () async {
                      actionData.action.enabled = !actionData.action.enabled;
                      final result = await _callActionsStack(
                          NewsData.fromNews(widget.news));
                      widget.onAction(result);
                    },
                    onLongPress: () {
                      if (actionData.options != null &&
                          actionData.options!.isNotEmpty) {
                        _showOptions(actionData);
                      }
                    },
                  ),
                ))
            .toList(),
      ),
    );
  }

  Widget _buildWorkingWidget(BuildContext context) {
    return Stack(
      children: [
        CardLoading(
          height: 58.0,
          cardLoadingTheme: CardLoadingTheme(
              colorOne: Theme.of(context).brightness == Brightness.light
                  ? Colors.white
                  : Colors.black,
              colorTwo: Theme.of(context).brightness == Brightness.light
                  ? Colors.black12
                  : Colors.white10),
        ),
        Center(
            child: Text(
          _status ?? 'Working...',
          style: const TextStyle(fontFamily: 'Montserrat'),
        ))
      ],
    );
  }

  Widget _buildErrorWidget(BuildContext context) {
    return Center(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          _status ?? 'Error',
          style: const TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.bold,
              color: Colors.red),
        ),
        const SizedBox(
          width: 12.0,
        ),
        const Icon(
          FluentIcons.dismiss_12_filled,
          color: Colors.red,
        )
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final barBgCol = isLight
        ? const Color.fromARGB(255, 240, 240, 240)
        : const Color.fromARGB(255, 16, 16, 16);

    return AnimatedSlide(
        offset: widget.isVisible ? Offset.zero : const Offset(0, 1),
        duration: const Duration(milliseconds: 750),
        curve: Curves.easeInOut,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              width: 240.0,
              child: Material(
                clipBehavior: Clip.antiAlias,
                elevation: 24.0,
                borderRadius: BorderRadius.circular(16.0),
                shadowColor: isLight ? Colors.white : Colors.black,
                color: Colors.transparent,
                child: Container(
                    decoration: BoxDecoration(
                        color: barBgCol,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: Colors.grey.withAlpha(64))),
                    clipBehavior: Clip.antiAlias,
                    height: 58.0,
                    padding: const EdgeInsets.symmetric(horizontal: 0.0),
                    child: _error
                        ? _buildErrorWidget(context)
                        : (_working
                            ? _buildWorkingWidget(context)
                            : _buildActionButtons(context))),
              ),
            ),
          ),
        ));
  }
}
