import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:table_calendar/table_calendar.dart';
import 'dart:convert';
import 'dart:typed_data';

void main() {
  runApp(MaterialApp(debugShowCheckedModeBanner: false, home: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Responsive Dashboard',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF1E1E2F),
      ),
      debugShowCheckedModeBanner: false,
      home: ResponsiveDashboard(),
    );
  }
}

class ResponsiveDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 1000) {
          return DesktopLayout();
        } else if (constraints.maxWidth >= 600) {
          return TabletLayout();
        } else {
          return MobileLayout();
        }
      },
    );
  }
}

class DesktopLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: TopBar(),
      ),
      body: Row(
        children: [
          SideBar(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TopCard(),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(child: AllProjectsCard()),
                      const SizedBox(width: 16),
                      Expanded(child: TopCreatorsCard()),
                    ],
                  ),
                  const SizedBox(height: 16),
                  PerformanceChartCard(),
                ],
              ),
            ),
          ),
          RightSidebar(),
        ],
      ),
    );
  }
}

class TabletLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0), // Adjust height as needed
        child: TopBar(), // Include your TopBar widget here
      ),
      endDrawer: Drawer(
        // Right Drawer
        child: RightSidebar(),
        width: 500,
      ),
      drawer: Drawer(child: SideBar()),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TopCard(),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: AllProjectsCard()),
                const SizedBox(width: 16),
                Expanded(child: TopCreatorsCard()),
              ],
            ),
            const SizedBox(height: 16),
            PerformanceChartCard(),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class MobileLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      drawer: Drawer(child: SideBar()),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 60,
              width: double.infinity,
              color: Colors.white,
              child: TopBar(),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Container(
                    width: screenWidth < 600 ? screenWidth : 600,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TopCard(),
                        const SizedBox(height: 16),
                        AllProjectsCard(),
                        const SizedBox(height: 16),
                        TopCreatorsCard(),
                        const SizedBox(height: 16),
                        PerformanceChartCard(),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SideBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final String base64ImageString =
        "data:image/jpeg;base64,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"
            .split(',')
            .last;
    Uint8List imageBytes = base64Decode(base64ImageString);

    return SafeArea(
      child: Container(
        width: 200,
        color: Colors.black12,
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Section at Top
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: MemoryImage(imageBytes),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Gaurav Kapoor",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Admin",
                    style: TextStyle(fontSize: 13, color: Colors.white60),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Navigation Links
            ListTile(title: Text("Home"), onTap: () {}),
            ListTile(title: Text("Employees"), onTap: () {}),
            ListTile(title: Text("Attendance"), onTap: () {}),
            ListTile(title: Text("Summary"), onTap: () {}),
            ListTile(title: Text("Information"), onTap: () {}),
            ListTile(title: Text("Workspaces"), onTap: () {}),
            Spacer(),

            // Logout Button at Bottom
            ListTile(
              leading: Icon(Icons.settings, color: Colors.white),
              title: Text("Settings"),
              onTap: () {},
            ),

            ListTile(
              leading: Icon(Icons.logout, color: Colors.white),
              title: Text("Logout"),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}

class TopCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final isMobile = screenWidth < 600;

    return Container(
      height: isMobile ? null : 190,
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Colors.purple, Colors.blue]),
        borderRadius: BorderRadius.circular(12),
      ),
      child:
          isMobile
              ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "ETHEREUM 2.0",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Top Rating Project",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Trending project and high rating Project Created by team.",
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {},
                    child: Text("Learn More"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 13, 24, 63),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              )
              : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Column for text and button
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "ETHEREUM 2.0",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Top Rating Project",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Trending project and high rating Project Created by team.",
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () {},
                        child: Text("Learn More"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(
                            255,
                            13,
                            24,
                            63,
                          ),
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
    );
  }
}

class AllProjectsCard extends StatefulWidget {
  @override
  _AllProjectsCardState createState() => _AllProjectsCardState();
}

class _AllProjectsCardState extends State<AllProjectsCard> {
  int? selectedIndex;

  final List<Map<String, String>> projects = [
    {
      'name': 'AI Health Companion',
      'description':
          'A chatbot-based mental wellness assistant built with Flutter and OpenAI.',
      'image':
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSvkUFmp5jSF-DhrD5102bzHU7RbidetfqYfA&s',
    },
    {
      'name': 'Flutter Catalog App',
      'description':
          'A responsive catalog app with cart, login, and theme switching.',
      'image':
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSvkUFmp5jSF-DhrD5102bzHU7RbidetfqYfA&s',
    },
    {
      'name': 'WordPress eCommerce',
      'description': 'Online store built using Elementor and WooCommerce.',
      'image':
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSvkUFmp5jSF-DhrD5102bzHU7RbidetfqYfA&s',
    },
  ];

  @override
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "All Projects",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...projects.asMap().entries.map((entry) {
              final index = entry.key;
              final project = entry.value;
              final isSelected = index == selectedIndex;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedIndex = index;
                  });
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.red : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          project['image'] ?? '',
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          errorBuilder:
                              (context, error, stackTrace) => Icon(Icons.error),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              project['name'] ?? '',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              project['description'] ?? '',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.white70, size: 20),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}

class TopCreatorsCard extends StatelessWidget {
  const TopCreatorsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Top Creators",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ...List.generate(
              4,
              (index) => ListTile(
                leading: SizedBox(
                  height: 40,
                  child: Image(
                    image: NetworkImage(
                      "https://static.vecteezy.com/system/resources/previews/043/348/809/non_2x/3d-cartoon-character-stylish-hipster-man-avatar-with-tablet-isolated-on-transparent-background-png.png",
                    ),
                  ),
                ),
                title: Text("@creator_$index"),
                trailing: Text("${9000 - index * 1000}"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PerformanceChartCard extends StatelessWidget {
  const PerformanceChartCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Performance Over Years",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 200, // fixed height instead of Expanded
              child: LineChart(
                LineChartData(
                  lineBarsData: [
                    LineChartBarData(
                      spots: const [
                        FlSpot(0, 10),
                        FlSpot(1, 30),
                        FlSpot(2, 20),
                        FlSpot(3, 40),
                      ],
                      isCurved: true,
                      barWidth: 3,
                      color: Colors.blue,
                    ),
                    LineChartBarData(
                      spots: const [
                        FlSpot(0, 15),
                        FlSpot(1, 20),
                        FlSpot(2, 25),
                        FlSpot(3, 30),
                      ],
                      isCurved: true,
                      barWidth: 3,
                      color: Colors.red,
                    ),
                  ],
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true),
                    ),
                  ),
                  borderData: FlBorderData(show: true),
                  gridData: FlGridData(show: true),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RightSidebar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      color: Colors.black26,
      padding: const EdgeInsets.all(19.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Center vertically
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Calendar card
            Text(
              "GENERAL 10:00AM TO 7:00PM",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      "Calendar",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TableCalendar(
                      focusedDay: DateTime.now(),
                      firstDay: DateTime.utc(2020, 01, 01),
                      lastDay: DateTime.utc(2030, 12, 31),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Birthday card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      "Birthdays",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ListTile(leading: Text("🎉"), title: Text("John Doe")),
                    ListTile(leading: Text("🎂"), title: Text("Jane Smith")),
                    ListTile(leading: Text("🎈"), title: Text("Robert Brown")),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      "Anniversaries",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ListTile(leading: Text("💍"), title: Text("Alice & Bob")),
                    ListTile(leading: Text("💖"), title: Text("Chris & Sarah")),
                    ListTile(leading: Text("🎉"), title: Text("Tom & Lily")),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TopBar extends StatelessWidget {
  const TopBar({super.key});

  static const desktopBreakpoint = 1024.0;
  static const tabletBreakpoint = 600.0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        if (width >= desktopBreakpoint) {
          return _buildDesktopTopBar();
        } else if (width >= tabletBreakpoint) {
          return _buildTabletTopBar(context);
        } else {
          return _buildMobileTopBar();
        }
      },
    );
  }

  AppBar _buildDesktopTopBar() {
    return AppBar(
      backgroundColor: const Color.fromARGB(255, 1, 5, 8),
      centerTitle: true,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 80,
            height: 80,
            child: Image(
              image: NetworkImage(
                "data:image/png;base64,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",
              ),
            ),
          ),
          // Home Text
          Text(
            'Home',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),

          // Search Bar
          Container(
            width: 400,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextField(
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search, color: Colors.black),
                hintText: 'Search...',
                border: InputBorder.none,
              ),
            ),
          ),

          // Icon Buttons (Messages, Notifications, Profile, and Shutdown)
          Row(
            children: [
              // Messages Icon
              IconButton(
                icon: Icon(Icons.message),
                onPressed: () {
                  print("Messages clicked");
                },
                color: Colors.white,
              ),
              SizedBox(width: 20),

              // Notifications Icon
              IconButton(
                icon: Icon(Icons.notifications),
                onPressed: () {
                  print("Notifications clicked");
                },
                color: Colors.white,
              ),
              SizedBox(width: 20),

              // Shutdown Button (e.g., log out)
              IconButton(
                icon: Icon(Icons.exit_to_app),
                onPressed: () {
                  print("Shut down clicked");
                },
                color: Colors.white,
              ),
              SizedBox(width: 50),

              // Profile Icon
              IconButton(
                icon: Icon(Icons.account_circle),
                onPressed: () {},
                color: Colors.white,
              ),
              SizedBox(width: 20),
            ],
          ),
        ],
      ),
    );
  }

  AppBar _buildTabletTopBar(BuildContext context) {
    return AppBar(
      backgroundColor: const Color.fromARGB(255, 1, 5, 8),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            height: 40,
            child: Image.network(
              "data:image/png;base64,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",
            ),
          ),
          SizedBox(width: 20),
          Text(
            'Home',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          SizedBox(width: 540),

          IconButton(
            icon: Icon(Icons.message),
            onPressed: () {},
            color: Colors.white,
          ),

          // Notifications Icon
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {},
            color: Colors.white,
          ),

          // Profile Icon
          IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () {},
            color: Colors.white,
          ),
          // SizedBox(width: 20),
          Builder(
            builder:
                (context) => IconButton(
                  icon: Icon(Icons.menu),
                  onPressed: () {
                    Scaffold.of(context).openEndDrawer();
                  },
                  color: Colors.white,
                ),
          ),
        ],
      ),
    );
  }

  AppBar _buildMobileTopBar() {
    const String base64Image =
        'data:image/png;base64,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';
    final RegExp regex = RegExp(r'data:image/[^;]+;base64,');
    String cleanBase64 = base64Image.replaceFirst(regex, '');
    Uint8List imageBytes = base64Decode(cleanBase64);

    return AppBar(
      backgroundColor: const Color.fromARGB(255, 1, 5, 8),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Image.memory(imageBytes, height: 40),
          SizedBox(width: 90),
          IconButton(
            icon: Icon(Icons.message),
            onPressed: () {},
            color: Colors.white,
          ),

          // Notifications Icon
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {},
            color: Colors.white,
          ),

          // Profile Icon
          IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () {},
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}
