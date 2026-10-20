import 'package:flutter/material.dart';

class SavingsGoal {
  final String title;
  final double targetAmount;
  double savedAmount;

  SavingsGoal({
    required this.title,
    required this.targetAmount,
    required this.savedAmount,
  });
}

class SavingsModuleScreen extends StatefulWidget {
  const SavingsModuleScreen({Key? key}) : super(key: key);

  @override
  State<SavingsModuleScreen> createState() => _SavingsModuleScreenState();
}

class _SavingsModuleScreenState extends State<SavingsModuleScreen> {
  final List<SavingsGoal> _goals = [
    SavingsGoal(title: 'Emergency Fund', targetAmount: 50000.0, savedAmount: 20000.0),
    SavingsGoal(title: 'New Phone', targetAmount: 80000.0, savedAmount: 45000.0),
  ];

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _targetController = TextEditingController();

  void _addGoal() {
    final title = _titleController.text.trim();
    final target = double.tryParse(_targetController.text.trim());

    if (title.isNotEmpty && target != null && target > 0) {
      setState(() {
        _goals.add(SavingsGoal(title: title, targetAmount: target, savedAmount: 0.0));
      });
      _titleController.clear();
      _targetController.clear();
      Navigator.pop(context);
    }
  }

  void _showAddGoalDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New Savings Goal'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Goal Title'),
            ),
            TextField(
              controller: _targetController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Target Amount (PKR)'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
            onPressed: _addGoal,
            child: const Text('Add Goal', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Savings Goals'),
        backgroundColor: Colors.teal,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        onPressed: _showAddGoalDialog,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: _goals.length,
          itemBuilder: (context, index) {
            final goal = _goals[index];
            double progress = (goal.savedAmount / goal.targetAmount).clamp(0.0, 1.0);

            return Card(
              margin: const EdgeInsets.only(bottom: 12.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          goal.title,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'PKR ${goal.savedAmount.toStringAsFixed(0)} / PKR ${goal.targetAmount.toStringAsFixed(0)}',
                          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.teal),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: progress,
                      minHeight: 8,
                      backgroundColor: Colors.teal.shade50,
                      color: Colors.teal,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
