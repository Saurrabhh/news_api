import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quantum_assignment/models/person.dart';
import 'package:quantum_assignment/services/firebase_auth_service.dart';
import 'package:quantum_assignment/services/new_service.dart';
import 'package:quantum_assignment/ui/auth/auth_page.dart';
import '../../constants.dart';
import '../../models/news.dart';
import 'components/news_card.dart';
import 'components/search_text_field.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  final searchController = TextEditingController();

  signOut(BuildContext context) {
    Provider.of<FirebaseAuthService>(context, listen: false).signOut().then(
        (value) => Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const AuthPage()),
            (route) => false));
  }

  @override
  Widget build(BuildContext context) {
    final newsService = Provider.of<NewsService>(context, listen: false)
      ..loadNews();
    final person = Provider.of<Person>(context,listen: false)..saveToLocal();
    return RefreshIndicator(
      onRefresh: () { return newsService.loadNews(); },
      child: Scaffold(
        appBar: AppBar(
          leading: const Icon(Icons.search,color: kSecondaryColor,size: 40,),
          title: SearchTextField(searchController: searchController, newsService: newsService),
          backgroundColor: Colors.white,
          actions: [
            IconButton(
                onPressed: () => signOut(context), icon: const Icon(Icons.logout,color: kSecondaryColor,))
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(5),
              child: Text("Hello ${person.name}",style: const TextStyle(fontSize: 20),),
            ),
            const Padding(
              padding: EdgeInsets.all(5),
              child: Text("Here is your feed.",style: TextStyle(fontSize: 20),),
            ),
            Expanded(
              child: Consumer<NewsService>(
                builder: (BuildContext context, newsService, Widget? child) {
                  if (newsService.size == 0) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  String query = searchController.text.toLowerCase();
                  return ListView.builder(
                      itemCount: newsService.size,
                      itemBuilder: (context, index) {
                        News news = newsService.newsList[index];
                        if (news.title.toLowerCase().contains(query) ||
                            news.description.toLowerCase().contains(query) ||
                            news.source.toLowerCase().contains(query)) {
                          return NewsCard(news: news);
                        }
                        return const SizedBox();
                      });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}


