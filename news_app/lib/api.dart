import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:news_app/news.dart';

class INFetchApi {
  static final _dio =
      Dio(BaseOptions(baseUrl: 'https://api.worldnewsapi.com/'));
  static const apiKey = "5757d80b508a4f2889a61138b836aba6";

  static final Map<Map<String, String>, List<INNews>> _cache = {};

  static Future<List<INNews>> getNews(
      {bool forceFetch = false,
      int numTries = 1,
      String? keywords,
      DateTime? startDate}) async {
    String dateToStr(DateTime date) {
      return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    }

    final queryParameters = <String, String>{
      if (keywords != null) 'text': keywords,
      'language': 'en',
      'earliest-publish-date':
          dateToStr((startDate != null) ? startDate : DateTime.now())
    };

    //debugPrint('queryParameters: $queryParameters');

    for (int tryNo = 0; tryNo < numTries; ++tryNo) {
      if (_cache.containsKey(queryParameters) && !forceFetch) {
        debugPrint('returning cached news');
        return Future.value(_cache[queryParameters]);
      }

      try {
        var response = await _dio.get(
          'search-news',
          queryParameters: queryParameters,
          options: Options(headers: {'x-api-key': apiKey}),
        );

        var fetchedNews = response.data;
        var processedNews = <INNews>[];
        for (var news in fetchedNews['news']) {
          processedNews.add(INNews(
              headline: news['title'],
              content: news['text'],
              imageUrl: news['image'],
              tags: [],
              source: 'not impl',
              sourceTitle: 'not impl'));
        }
        _cache[queryParameters] = processedNews;
        return processedNews;
      } on DioException catch (e) {
        debugPrint('Error fetching news: ${e.message}');
        await Future.delayed(Duration(seconds: pow(2, tryNo) as int));
      }
    }

    return Future.value(const <INNews>[
      INNews(
          headline:
              'Air India resumes flight ops to and from Heathrow Airport day after power outage',
          content:
              '''Air India on Saturday said it has recommenced flights to and from London Heathrow Airport, which had witnessed operational disruptions due to a power outage.

From the national capital, apart from Air India, Virgin Atlantic and British Airways also operated their scheduled flights to London Heathrow (LHR).

Travel plans of thousands of passengers who were scheduled to fly to LHR, including from Indian cities, were disrupted on Friday due to the cancellation of flights, as operations were suspended following the power outage.

"Our operations to and from London Heathrow (LHR) have recommenced after the disruption at the airport yesterday due to a power outage," Air India said in a statement on Saturday.

According to Air India, flight AI111 was on schedule and other flights, to and from London, are expected to operate as per schedule.

"Flight AI161 of 21 March, which was diverted to Frankfurt, is expected to leave Frankfurt at 14:05 pm local time," the statement said.

An official said Air India, British Airways and Virgin Atlantic operated their flights to LHR on Saturday morning, and another Air India flight is scheduled to depart in the afternoon.

Delhi Airport has six daily flights connecting with LHR.

British Airways has eight flights per day between India and LHR, including three from Mumbai and two from Delhi. Virgin Atlantic has five daily flights to LHR from Delhi, Mumbai and Bengaluru. Air India has six daily flights to LHR.

In a statement, British Airways said it was planning to operate as many flights as possible to and from LHR Heathrow on Saturday, but to recover an operation of our size after such a significant incident is extremely complex.

"We expect around 85 per cent of our Saturday Heathrow schedule to run, but it is likely that all travelling customers will experience delays as we continue to navigate the challenges posed by Friday's power outage at the airport," the statement said.

In a series of posts on X, LHR airport on Saturday said flights have resumed and "we are open and fully operational".

Teams across the airport continue to do everything they can do to support passengers impacted by yesterday's outage at an off airport substation, it said.''',
          imageUrl:
              'https://akm-img-a-in.tosshub.com/indiatoday/images/story/202503/air-india-223634423-16x9_0.jpg?VersionId=kh451zgXLmg5g_ZZ5VfHXkUb5JCjlySG&size=690:388',
          tags: <String>['Country'],
          source: 'not impl',
          sourceTitle: 'Times of India'),
      INNews(
          headline:
              '''Phil Salt excited to open with 'super competitor' Virat Kohli in IPL 2025''',
          content:
              '''England and Royal Challengers Bengaluru (RCB) batter Philip Salt recently shared his thoughts about opening alongside Virat Kohli in the upcoming Indian Premier League 2025 (IPL 2025). Salt was bought for Rs 11.50 crore by RCB in the mega auction for the 2025 season and will open with Kohli in the upcoming edition of the tournament.

Ahead of the season, Salt shed light on Kohli’s mindset, calling him a super competitor. He also said that he likes to get into fights and on-field battles and revealed that the duo is getting along well.

“Virat Kohli is such a good man. He's so chilled. But for the game, he's a super competitor, he likes to get in this, he likes to fight, he likes battle. We're getting on pretty well, I'm pretty happy alongside batting with him,” he said, speaking to RCB's media team.

Rajat Patidar has been entrusted with the task of leading RCB in the upcoming season. Ahead of their opening game against Kolkata Knight Riders (KKR), head coach Andy Flower said that most of the guys have captained their state teams and hence they’re pleased with having a strong leadership group.

“A lot of these guys have captained state sides, IPL teams and international teams. So, we're very pleased with that, regardless of who was actually captaining our team this year,” said Flower in the pre-match press conference.

RCB will start their campaign against KKR on Saturday, March 22 and will be eager to begin on a winning note. KKR have an upper hand over RCB in their IPL history, having beaten them in 20 out of 34 matches. Hence, the Rajat Patidar-led side will have a big task at hand to defeat their old rivals and get the tournament off to a winning start.

Meanwhile, ahead of the start of the opening game at the Eden Gardens Kolkata, a glitzy opening ceremony has been organised where several celebrities are set to form. Bollywood actor and KKR owner Shah Rukh Khan, actor Disha Patani and singer Shreya Ghoshal amongst others will set the stage on fire.''',
          imageUrl:
              'https://akm-img-a-in.tosshub.com/indiatoday/images/story/202503/virat-kohli--phil-salt-223410881-16x9_0.jpg?VersionId=77bBJaeAmfu5mUbpLYnSlngupYrE4MxD&size=690:388',
          tags: <String>['Sports'],
          source: 'not impl',
          sourceTitle: 'The Telegraph'),
      INNews(
          headline:
              '''Sam Altman says AI is doing 50 percent coding in companies, warns students about career choices''',
          content:
              '''OpenAI CEO Sam Altman has offered crucial advice to students preparing for a tech-driven future, suggesting them to become proficient in using artificial intelligence (AI) tools. In an interview with Stratechery, Altman highlighted how AI is increasingly taking over coding tasks in many companies, estimating that AI now performs over 50 percent of the coding work in several organisations, Business Insider reports. He stressed that learning to work with AI is key to staying relevant in an evolving job market.

Altman compared today’s focus on mastering AI tools to the emphasis on learning coding skills when he was younger. "Like when I was graduating as a senior from high school, the obvious tactical thing was get really good at coding. And this is the new version of that. The obvious tactical thing is just get really good at using AI tools," Altman said. He believes that being well-versed in AI can provide a long-term advantage as the industry transitions further towards automation.

The idea of AI replacing human coders is becoming more prominent, with several industry leaders weighing in. Dario Amodei, CEO of Anthropic, recently predicted that AI could generate as much as 90 percent of code within six months. OpenAI’s Chief Product Officer, Kevin Weil, also suggested that by the end of this year, AI may outperform humans in coding.

Altman backed these predictions, asserting that AI’s role in coding is already substantial. He also touched upon the concept of "agentic coding" – an advanced form of automation where AI could take on even more coding responsibilities. While this concept is still in development, Altman is optimistic about its potential, though he acknowledged that current models still need refinement before reaching that stage.

For students entering the workforce, Altman encouraged focusing on broad skills like adaptability and resilience, which he believes will be valuable in navigating the changing landscape. He stressed the importance of cultivating the ability to learn new technologies and approaches, rather than just mastering specific technical skills.

Looking ahead, Altman also suggested that the demand for software engineers may decline as AI becomes more capable. While he acknowledged that engineers are currently in demand, he predicted that the number of engineers required could decrease as AI takes on more tasks. “Each software engineer will be able to do much more, but over time, we might need fewer engineers,” he said.

Altman further explained that the displacement of jobs due to AI won’t happen suddenly but will accelerate gradually. He described it as a process that will start slow, affecting small areas, but will eventually spread more rapidly across industries. ''',
          imageUrl:
              'https://akm-img-a-in.tosshub.com/indiatoday/images/story/202503/openai-ceo-sam-altman-302741921-16x9.jpg?VersionId=qozq7Y_GjenywII3810S.xj2nTmzocxC',
          tags: <String>['Tech'],
          source: 'not impl',
          sourceTitle: 'NDTV')
    ]);
  }
}

class INLLMApi {
  static final _dio = Dio(BaseOptions(
      baseUrl:
          'https://b7ln7iwhsdek2lkvarroebe64y0juyax.lambda-url.ap-south-1.on.aws/'));
  //static const apiKey = "5757d80b508a4f2889a61138b836aba6";

  static final Map<Map<String, String>, Map<String, String>> _cache = {};

  static Future<String> summarize(
      {required String headline,
      required String content,
      required String srcLink,
      int numTries = 1,
      bool forceFetch = false}) async {
    final queryParameters = {
      'title': headline,
      'body': content,
      'link': srcLink
    };

    for (int tryNo = 0; tryNo < numTries; ++tryNo) {
      if (_cache.containsKey(queryParameters) && !forceFetch) {
        debugPrint('returning cached summary');
        return Future.value(_cache[queryParameters]?['summary']);
      }

      try {
        var response =
            await _dio.get('summarize', queryParameters: queryParameters);

        Map<String, String> summary = response.data;
        _cache[queryParameters] = summary;
        debugPrint('summarization complete!');
        return summary['summary']!;
      } on DioException catch (e) {
        debugPrint('Error fetching news: ${e.message}');
        await Future.delayed(Duration(seconds: pow(2, tryNo) as int));
      }
    }

    return Future<String>.value(content);
  }
}
