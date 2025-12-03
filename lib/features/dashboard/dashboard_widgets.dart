import 'package:flutter/material.dart';
import '../../widgets/summary_card.dart';

class DashboardWidgets extends StatelessWidget {
  final Map<String, dynamic> summary;

  const DashboardWidgets({Key? key, required this.summary}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Today's Summary",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            children: [
              SummaryCard(
                title: 'Steps',
                value: (summary['steps'] ?? 0).toString(),
                unit: '',
                color: Colors.green,
                icon: Icons.directions_walk,
              ),
              SummaryCard(
                title: 'Calories',
                value: (summary['calories'] ?? 0).toString(),
                unit: 'cal',
                color: Colors.red,
                icon: Icons.local_fire_department,
              ),
              SummaryCard(
                title: 'Water',
                value: ((summary['water'] ?? 0) / 1000).toStringAsFixed(1),
                unit: 'L',
                color: Colors.blue,
                icon: Icons.water_drop,
              ),
              SummaryCard(
                title: 'Records',
                value: (summary['recordCount'] ?? 0).toString(),
                unit: '',
                color: Colors.orange,
                icon: Icons.list_alt,
              ),
            ],
          ),
          const SizedBox(height: 32),
          const Text(
            'Quick Actions',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // First row of buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildActionButton(
                context,
                'Add Record',
                Icons.add,
                Colors.blue,
                    () {
                  Navigator.pushNamed(context, '/add-record');
                },
              ),
              _buildActionButton(
                context,
                'View Records',
                Icons.list,
                Colors.green,
                    () {
                  Navigator.pushNamed(context, '/records');
                },
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Second row of buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildActionButton(
                context,
                'Search',
                Icons.search,
                Colors.purple,
                    () {
                  Navigator.pushNamed(context, '/search');
                },
              ),
              _buildActionButton(
                context,
                'Welcome',
                Icons.home,
                Colors.amber,
                    () {
                  Navigator.pushReplacementNamed(context, '/welcome');
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
      BuildContext context,
      String text,
      IconData icon,
      Color color,
      VoidCallback onPressed,
      ) {
    return Column(
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: IconButton(
            icon: Icon(icon, color: Colors.white, size: 30),
            onPressed: onPressed,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          text,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}