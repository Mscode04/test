import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:test/controllers/home_controller.dart';
import 'package:test/controllers/user_controller.dart';
import 'package:test/model/user_model.dart';
import 'package:test/view/const.dart';
import 'package:test/view/web_view_page.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final userController = context.watch<UserController>();
    final homeController = context.watch<HomeController>();

    if (userController.allUsers.isEmpty && !userController.isLoading) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        userController.fetchUsers();
      });
    }

    var kHeight = MediaQuery.of(context).size.height;
    var kWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(110),
          child: AppBar(
            elevation: 5,
            shadowColor: Colors.black,
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            titleSpacing: 0.0,
            toolbarHeight: 110,
            flexibleSpace: Padding(
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const WebViewScreen(
                            url: 'https://www.girmantech.com/',
                            title: "Girman Technologies"),
                      ));
                    },
                    child: SvgPicture.asset(Assets.logoImg),
                  ),
                  PopupMenuButton<int>(
                    color: Colors.white,
                    icon: SvgPicture.asset(Assets.menuIcon),
                    onSelected: (value) {
                      if (value == 1) {
                        homeController.selectSearch();
                      } else {
                        homeController.deselectSearch();
                      }
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('SEARCH',
                                style: TextStyle(
                                    fontSize: 17, color: Colors.black)),
                            if (homeController.isSearchSelected) ...[
                              const SizedBox(height: 4),
                              Container(height: 2, color: Colors.blue),
                            ],
                          ],
                        ),
                      ),
                      PopupMenuItem(
                          value: 2,
                          child: InkWell(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const WebViewScreen(
                                      url: 'https://www.girmantech.com/',
                                      title: "Girman Technologies"),
                                ));
                              },
                              child: const Text('WEBSITE',
                                  style: TextStyle(fontSize: 17)))),
                      PopupMenuItem(
                          value: 3,
                          child: InkWell(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const WebViewScreen(
                                      url:
                                          'https://www.linkedin.com/company/girmantech/posts/?feedView=all',
                                      title: "Girman Technologies"),
                                ));
                              },
                              child: const Text('LINKEDIN',
                                  style: TextStyle(fontSize: 17)))),
                      PopupMenuItem(
                          value: 4,
                          child: InkWell(
                              onTap: () {
                                _launchEmail();
                              },
                              child: const Text('CONTACT',
                                  style: TextStyle(fontSize: 17)))),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.blue.withOpacity(0.01),
                Colors.blue.withOpacity(0.4),
              ],
              stops: [0.0, 1.0],
            ),
          ),
          child: Column(
            children: [
              // Show the search field only when search is selected
              if (homeController.isSearchSelected) ...[
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 35),
                  child: TextFormField(
                    controller: _searchController,
                    onChanged: (value) => userController.searchUser(value),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      hintText: 'Search',
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 15),
              Expanded(
                child: userController.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : userController.users.isEmpty
                        ? Center(child: Image.asset(Assets.emptyState))
                        : ListView.builder(
                            itemCount: userController.users.length,
                            itemBuilder: (context, index) {
                              UserModel user = userController.users[index];
                              return Container(
                                height: kHeight * 0.3,
                                width: kWidth * 0.9,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 40, vertical: 10),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const CircleAvatar(
                                        radius: 30,
                                        backgroundImage:
                                            AssetImage(Assets.userImg),
                                      ),
                                      const SizedBox(height: 20),
                                      Text(
                                        '${user.firstName} ${user.lastName}',
                                        style: const TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Row(children: [
                                        const Icon(Icons.location_on),
                                        const SizedBox(width: 5),
                                        Text(user.city ?? ''),
                                      ]),
                                      const SizedBox(height: 30),
                                      const Divider(),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            children: [
                                              Row(
                                                children: [
                                                  const Icon(Icons.phone),
                                                  const SizedBox(width: 5),
                                                  Text(user.contactNumber ?? '',
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                ],
                                              ),
                                              const Text('Available on phone',
                                                  style: TextStyle(
                                                      color: Colors.grey)),
                                            ],
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              _showFetchDetailsDialog(
                                                  context, user);
                                            },
                                            child: Container(
                                              height: kHeight * 0.04,
                                              width: kWidth * 0.24,
                                              decoration: BoxDecoration(
                                                  color: Colors.black,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: const Center(
                                                child: Text('Fetch Details',
                                                    style: TextStyle(
                                                        color: Colors.white)),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _launchEmail() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'contact@girmantech.com',
    );

    try {
      final String url = emailLaunchUri.toString();
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        print('Could not launch: $url');
      }
    } catch (e) {
      print('Error launching email: $e');
    }
  }

  void _showFetchDetailsDialog(BuildContext context, UserModel user) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Fetch Details',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(
                        Icons.close,
                        size: 27,
                      ))
                ],
              ),
              Text(
                'Here are the details of following employee',
                style: TextStyle(fontSize: 11),
              ),
            ],
          ),
          backgroundColor: Colors.white,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Name: ${user.firstName} ${user.lastName}',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 10),
              Text(
                'Location: ${user.city ?? 'N/A'}',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 10),
              Text(
                'Contact Number: ${user.contactNumber ?? 'N/A'}',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 10),
              Text(
                'Profile Image :',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              ClipRRect(
                child: Transform.scale(
                  scale: 1.5,
                  child: Image.asset(
                    Assets.userImg,
                    fit: BoxFit.cover,
                    width: 200,
                    height: 200,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
