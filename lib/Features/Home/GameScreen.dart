// import 'package:flutter/material.dart';
// import 'dart:math' as math;

// class GameProfilePage extends StatefulWidget {
//   const GameProfilePage({Key? key}) : super(key: key);

//   @override
//   _GameProfilePageState createState() => _GameProfilePageState();
// }

// class _GameProfilePageState extends State<GameProfilePage>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   final stats = {
//     'Health': 85,
//     'Strength': 70,
//     'Perception': 65,
//     'Agility': 75,
//     'Stealth': 60,
//     'Speed': 80,
//   };

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       duration: const Duration(seconds: 2),
//       vsync: this,
//     )..repeat();
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//             colors: [Colors.purple.shade900, Colors.blue.shade900],
//           ),
//         ),
//         child: SafeArea(
//           child: Column(
//             children: [
//               const SizedBox(height: 20),
//               // Avatar Section
//               _buildAvatarSection(),
//               const SizedBox(height: 30),
//               // Stats Section
//               Expanded(
//                 child: Container(
//                   margin: const EdgeInsets.symmetric(horizontal: 20),
//                   decoration: BoxDecoration(
//                     color: Colors.white.withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(30),
//                   ),
//                   child: _buildStatsSection(),
//                 ),
//               ),
//               const SizedBox(height: 20),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildAvatarSection() {
//     return Stack(
//       alignment: Alignment.center,
//       children: [
//         // Rotating outer ring
//         AnimatedBuilder(
//           animation: _controller,
//           builder: (_, child) {
//             return Transform.rotate(
//               angle: _controller.value * 2 * math.pi,
//               child: Container(
//                 width: 160,
//                 height: 160,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   gradient: SweepGradient(
//                     colors: [
//                       Colors.blue.withOpacity(0.5),
//                       Colors.purple.withOpacity(0.5),
//                       Colors.blue.withOpacity(0.5),
//                     ],
//                   ),
//                 ),
//               ),
//             );
//           },
//         ),
//         // Avatar container
//         Container(
//           width: 140,
//           height: 140,
//           decoration: BoxDecoration(
//             shape: BoxShape.circle,
//             color: Colors.white,
//             border: Border.all(color: Colors.white.withOpacity(0.5), width: 4),
//           ),
//           child: ClipOval(
//             child: Icon(Icons.person, size: 80, color: Colors.blue.shade900),
//           ),
//         ),
//         // Level indicator
//         Positioned(
//           bottom: 0,
//           child: Container(
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//             decoration: BoxDecoration(
//               color: Colors.orange.shade800,
//               borderRadius: BorderRadius.circular(20),
//             ),
//             child: const Text(
//               'LEVEL 02',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontWeight: FontWeight.bold,
//                 fontSize: 16,
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildStatsSection() {
//     return ListView.builder(
//       padding: const EdgeInsets.all(20),
//       itemCount: stats.length,
//       itemBuilder: (context, index) {
//         final stat = stats.entries.elementAt(index);
//         return TweenAnimationBuilder(
//           duration: Duration(milliseconds: 1500 + (index * 200)),
//           tween: Tween<double>(begin: 0, end: stat.value.toDouble()),
//           builder: (context, double value, child) {
//             return Column(
//               children: [
//                 Row(
//                   children: [
//                     Text(
//                       stat.key,
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontSize: 16,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                     const SizedBox(width: 10),
//                     Text(
//                       value.toInt().toString(),
//                       style: TextStyle(
//                         color: Colors.orange.shade400,
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 8),
//                 Stack(
//                   children: [
//                     Container(
//                       height: 8,
//                       decoration: BoxDecoration(
//                         color: Colors.white.withOpacity(0.1),
//                         borderRadius: BorderRadius.circular(4),
//                       ),
//                     ),
//                     Container(
//                       height: 8,
//                       width:
//                           (MediaQuery.of(context).size.width - 80) *
//                           (value / 100),
//                       decoration: BoxDecoration(
//                         gradient: LinearGradient(
//                           colors: [
//                             Colors.blue.shade400,
//                             Colors.purple.shade400,
//                           ],
//                         ),
//                         borderRadius: BorderRadius.circular(4),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.blue.withOpacity(0.5),
//                             blurRadius: 6,
//                             offset: const Offset(0, 2),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 20),
//               ],
//             );
//           },
//         );
//       },
//     );
//   }
// }

// Version 2

import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class GameProfilePage extends StatefulWidget {
  const GameProfilePage({Key? key}) : super(key: key);

  @override
  _GameProfilePageState createState() => _GameProfilePageState();
}

class _GameProfilePageState extends State<GameProfilePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  File? _avatarImage;
  final ImagePicker _picker = ImagePicker();

  // Current experience and level info
  final int _currentXP = 1250;
  final int _xpToNextLevel = 2000;
  final int _currentLevel = 02;

  // Enhanced stats with more attributes
  final stats = {
    'Health': 85,
    'Strength': 70,
    'Perception': 65,
    'Agility': 75,
    'Stealth': 60,
    'Speed': 80,
    'Intelligence': 82,
    'Charisma': 68,
    'Luck': 55,
    'Defense': 77,
  };

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
      );
      if (pickedFile != null) {
        setState(() {
          _avatarImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      // Handle error
      print("Error picking image: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF1A2980), // Deep blue
              const Color(0xFF26D0CE), // Teal accent
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 20),
              // Avatar Section
              _buildAvatarSection(),
              const SizedBox(height: 15),
              // XP Bar
              _buildXPBar(),
              const SizedBox(height: 15),
              // Class Banner
              _buildClassBanner(),
              const SizedBox(height: 15),
              // Stats Section
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: _buildStatsSection(),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatarSection() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Rotating outer ring
        AnimatedBuilder(
          animation: _controller,
          builder: (_, child) {
            return Transform.rotate(
              angle: _controller.value * 2 * math.pi,
              child: Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: SweepGradient(
                    colors: [
                      const Color(0xFF26D0CE).withOpacity(0.7),
                      const Color(0xFF1A2980).withOpacity(0.7),
                      const Color(0xFF26D0CE).withOpacity(0.7),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
        // Avatar container
        GestureDetector(
          onTap: _pickImage,
          child: Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(
                color: Colors.white.withOpacity(0.5),
                width: 4,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF26D0CE).withOpacity(0.5),
                  blurRadius: 15,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: ClipOval(
              child:
                  _avatarImage != null
                      ? Image.file(_avatarImage!, fit: BoxFit.cover)
                      : Stack(
                        alignment: Alignment.center,
                        children: [
                          Icon(
                            Icons.person,
                            size: 80,
                            color: const Color(0xFF1A2980),
                          ),
                          Positioned(
                            bottom: 20,
                            child: Text(
                              "Tap to upload",
                              style: TextStyle(
                                color: const Color(0xFF1A2980),
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
            ),
          ),
        ),
        // Level indicator
        Positioned(
          bottom: 0,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFFFF8C00), // Orange
                  const Color(0xFFFF5000), // Deep orange
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Text(
              'LEVEL $_currentLevel',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildXPBar() {
    final double progress = _currentXP / _xpToNextLevel;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'XP: $_currentXP / $_xpToNextLevel',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${(progress * 100).toInt()}%',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Stack(
            children: [
              Container(
                height: 10,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              Container(
                height: 10,
                width: MediaQuery.of(context).size.width * progress - 80,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFFFF8C00), // Orange
                      Color(0xFFFF5000), // Deep orange
                    ],
                  ),
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFF8C00).withOpacity(0.7),
                      blurRadius: 6,
                      offset: const Offset(0, 0),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildClassBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFFFF8C00).withOpacity(0.7),
            const Color(0xFFFF5000).withOpacity(0.7),
          ],
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.bolt, color: Colors.white),
          SizedBox(width: 10),
          Text(
            'ASSASSIN RANGER',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
              letterSpacing: 1.2,
            ),
          ),
          SizedBox(width: 10),
          Icon(Icons.bolt, color: Colors.white),
        ],
      ),
    );
  }

  Widget _buildStatsSection() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.bar_chart, color: Colors.white),
              const SizedBox(width: 8),
              Text(
                'CHARACTER STATS',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 2.5,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: stats.length,
            itemBuilder: (context, index) {
              final stat = stats.entries.elementAt(index);
              return TweenAnimationBuilder(
                duration: Duration(milliseconds: 1000 + (index * 100)),
                tween: Tween<double>(begin: 0, end: stat.value.toDouble()),
                builder: (context, double value, child) {
                  // Determine color based on stat value
                  Color statColor;
                  if (value >= 80) {
                    statColor = const Color(0xFF00FF00); // High stats (green)
                  } else if (value >= 60) {
                    statColor = const Color(
                      0xFFFFFF00,
                    ); // Medium stats (yellow)
                  } else {
                    statColor = const Color(0xFFFF0000); // Low stats (red)
                  }

                  return Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.1),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              stat.key,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              value.toInt().toString(),
                              style: TextStyle(
                                color: statColor,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Stack(
                          children: [
                            Container(
                              height: 6,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                            Container(
                              height: 6,
                              width:
                                  (MediaQuery.of(context).size.width / 2 - 50) *
                                  (value / 100),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    statColor.withOpacity(0.7),
                                    statColor,
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(3),
                                boxShadow: [
                                  BoxShadow(
                                    color: statColor.withOpacity(0.5),
                                    blurRadius: 4,
                                    offset: const Offset(0, 0),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
        _buildEquipmentSection(),
      ],
    );
  }

  Widget _buildEquipmentSection() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.4),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'EQUIPPED ITEMS',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildEquipmentSlot('Weapon', Icons.gps_fixed, 'Shadowblade'),
              _buildEquipmentSlot('Armor', Icons.shield, 'Nightskin'),
              _buildEquipmentSlot('Amulet', Icons.auto_awesome, '+5 Agility'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEquipmentSlot(String type, IconData icon, String itemName) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.6),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: const Color(0xFF26D0CE).withOpacity(0.5),
              width: 1,
            ),
          ),
          child: Icon(icon, color: const Color(0xFF26D0CE), size: 30),
        ),
        const SizedBox(height: 5),
        Text(type, style: const TextStyle(color: Colors.white70, fontSize: 12)),
        Text(
          itemName,
          style: TextStyle(
            color: const Color(0xFF26D0CE),
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
