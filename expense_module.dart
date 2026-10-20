import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'expense.dart';
import 'expense_item.dart';

class ExpenseModuleScreen extends StatefulWidget {
  const ExpenseModuleScreen({Key? key}) : super(key: key);

  @override
  State<ExpenseModuleScreen> createState() => _ExpenseModuleScreenState();
}

class _ExpenseModuleScreenState extends State<ExpenseModuleScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();

  final List<Expense> _expenseList = [];

  @override
  void initState() {
    super.initState();
    _loadExpenses();
  }

  double get _totalSpent {
    double total = 0.0;
    for (var expense in _expenseList) {
      total += expense.amount;
    }
    return total;
  }

  void _addExpense() {
    final String title = _titleController.text.trim();
    final String amountText = _amountController.text.trim();
    final String category = _categoryController.text.trim();

    if (title.isEmpty || amountText.isEmpty || category.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    final double? amount = double.tryParse(amountText);
    if (amount == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid amount')),
      );
      return;
    }

    final newExpense = Expense(title: title, amount: amount, category: category);

    setState(() {
      _expenseList.add(newExpense);
    });

    _saveExpenses();

    _titleController.clear();
    _amountController.clear();
    _categoryController.clear();
  }

  Future<void> _saveExpenses() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> jsonStringList = _expenseList.map((e) => e.toJson()).toList();
    await prefs.setStringList('expenses_key', jsonStringList);
  }

  Future<void> _loadExpenses() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? jsonStringList = prefs.getStringList('expenses_key');

    if (jsonStringList != null) {
      setState(() {
        _expenseList.clear();
        _expenseList.addAll(jsonStringList.map((e) => Expense.fromJson(e)).toList());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Manager'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.teal.shade50,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Text(
                'Total Spent: PKR ${_totalSpent.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal.shade900,
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Expense Title (e.g., Lunch)'),
            ),
            TextField(
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: 'Amount in PKR (e.g., 500)'),
            ),
            TextField(
              controller: _categoryController,
              decoration: const InputDecoration(labelText: 'Category (e.g., Food, Travel)'),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                onPressed: _addExpense,
                child: const Text('Add Expense', style: TextStyle(color: Colors.white)),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Recent Transactions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: _expenseList.isEmpty
                  ? const Center(child: Text('No expenses recorded yet.'))
                  : ListView.builder(
                      itemCount: _expenseList.length,
                      itemBuilder: (context, index) {
                        return ExpenseItem(expense: _expenseList[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
