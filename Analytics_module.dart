import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'expense.dart';

class AnalyticsModuleScreen extends StatefulWidget {
  const AnalyticsModuleScreen({Key? key}) : super(key: key);

  @override
  State<AnalyticsModuleScreen> createState() => _AnalyticsModuleScreenState();
}

class _AnalyticsModuleScreenState extends State<AnalyticsModuleScreen> {
  Map<String, double> categoryTotals = {};

  @override
  void initState() {
    super.initState();
    _calculateCategoryTotals();
  }

  Future<void> _calculateCategoryTotals() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? jsonStringList = prefs.getStringList('expenses_key');

    Map<String, double> totals = {};

    if (jsonStringList != null) {
      for (var str in jsonStringList) {
        Expense expense = Expense.fromJson(str);
        String category = expense.category.trim();
        if (category.isEmpty) category = 'Uncategorized';
        totals[category] = (totals[category] ?? 0.0) + expense.amount;
      }
    }

    setState(() {
      categoryTotals = totals;
    });
  }

  @override
  Widget build(BuildContext context) {
    double grandTotal = categoryTotals.values.fold(0.0, (sum, item) => sum + item);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Spending Analytics'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: categoryTotals.isEmpty
            ? const Center(child: Text('No expenses recorded yet to analyze.'))
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Category Breakdown',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView(
                      children: categoryTotals.entries.map((entry) {
                        double percentage = grandTotal > 0 ? (entry.value / grandTotal) : 0.0;
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    entry.key,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    'PKR ${entry.value.toStringAsFixed(2)} (${(percentage * 100).toStringAsFixed(1)}%)',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.teal,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              LinearProgressIndicator(
                                value: percentage,
                                minHeight: 10,
                                backgroundColor: Colors.teal.shade50,
                                color: Colors.teal,
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
