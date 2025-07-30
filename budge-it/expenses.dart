import 'package:flutter/material.dart';
import 'package:ecom_app/home.dart';
import 'package:ecom_app/draggablebutton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class expenses extends StatefulWidget {
  const expenses({super.key});

  @override
  State<expenses> createState() => _expensesState();
}

class _expensesState extends State<expenses> {
  double? monthlySalary;
  final TextEditingController incomeController = TextEditingController();

  void addexpense() {
    final nameController = TextEditingController();
    final amountController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Expense'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Expense Name'),
              keyboardType: TextInputType.text,
            ),
            TextField(
              controller: amountController,
              decoration: const InputDecoration(labelText: 'Amount Spent'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Cancel', style: TextStyle(fontSize: 19)),
          ),
          TextButton(
            onPressed: () {
              if (nameController.text.isNotEmpty && amountController.text.isNotEmpty) {
                FirebaseFirestore.instance
                    .collection('users')
                    .doc('expenses')
                    .collection('expenses')
                    .add({
                  'name': nameController.text,
                  'amount': amountController.text,
                });
              }
              Navigator.pop(context);
            },
            child: Text('Add', style: TextStyle(fontSize: 19)),
          )
        ],
      ),
    );
  }

  double calculateTotalExpenses(List<QueryDocumentSnapshot> docs) {
    double total = 0;
    for (var doc in docs) {
      total += double.tryParse(doc['amount'] ?? '0') ?? 0;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc('expenses')
                .collection('expenses')
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }

              final expensesList = snapshot.data!.docs;
              final total = calculateTotalExpenses(expensesList);

              return CustomScrollView(
                slivers: [
                  SliverAppBar(
                    expandedHeight: 100,
                    backgroundColor: Colors.blueAccent,
                    leading: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Log Out?', style: TextStyle(fontSize: 32.5)),
                              content: const Text('Are you sure you want to logout?', style: TextStyle(fontSize: 24)),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('No', style: TextStyle(fontSize: 20)),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(builder: (context) => home()),
                                    );
                                  },
                                  child: const Text('Yes', style: TextStyle(fontSize: 20)),
                                ),
                              ],
                            ),
                          );
                        },
                        icon: const Icon(Icons.arrow_back_ios, size: 30, color: Colors.black),
                      ),
                    ),
                    actions: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Menu', style: TextStyle(fontSize: 28)),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ListTile(
                                      leading: const Icon(Icons.attach_money),
                                      title: const Text('Enter Monthly Salary', style: TextStyle(fontSize: 20)),
                                      onTap: () {
                                        Navigator.pop(context);
                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: const Text('Enter monthly income', style: TextStyle(fontSize: 19)),
                                            content: TextField(
                                              controller: incomeController,
                                              keyboardType: TextInputType.number,
                                              decoration: const InputDecoration(
                                                labelText: 'Enter monthly salary (PKR)',
                                              ),
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () => Navigator.pop(context),
                                                child: Text('Cancel', style: TextStyle(fontSize: 19)),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  if (incomeController.text.isNotEmpty) {
                                                    setState(() {
                                                      monthlySalary = double.tryParse(incomeController.text);
                                                    });
                                                    Navigator.pop(context);
                                                  }
                                                },
                                                child: const Text('Save', style: TextStyle(fontSize: 19)),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                    const Divider(),
                                    ListTile(
                                      leading: const Icon(Icons.analytics),
                                      title: const Text('Analysis', style: TextStyle(fontSize: 20)),
                                      onTap: () {
                                        Navigator.pop(context);
                                        String message;
                                        if (monthlySalary == null || monthlySalary == 0) {
                                          message = "Enter salary first";
                                        } else if (total > 0.3 * monthlySalary!) {
                                          message = "You are in a deficit!! Cut down on some expenses";
                                        } else {
                                          message = "You are within the limit. Good Job!";
                                        }

                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: Text("Analysis", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                                            content: Text(
                                              message,
                                              style: TextStyle(fontSize: 22),
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () => Navigator.pop(context),
                                                child: Text('OK', style: TextStyle(fontSize: 19.5)),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          icon: const Icon(Icons.menu_sharp, size: 30, color: Colors.black),
                        ),
                      ),
                    ],
                    bottom: PreferredSize(
                      preferredSize: const Size.fromHeight(90),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: Text('My Expenses', style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(child: const SizedBox(height: 10)),
                  SliverToBoxAdapter(
                    child: Container(
                      margin: const EdgeInsets.all(15),
                      height: 300,
                      width: double.infinity,
                      padding: const EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        color: Colors.white70,
                        borderRadius: BorderRadius.circular(13),
                        boxShadow: const [
                          BoxShadow(blurRadius: 10, color: Colors.blueGrey),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Monthly Overview', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 20),
                          Text(
                            monthlySalary != null
                                ? 'Total Expenses: Rs. ${total.toStringAsFixed(0)} / Rs. ${monthlySalary!.toStringAsFixed(0)}'
                                : 'Monthly salary not set.',
                            style: const TextStyle(fontSize: 24, color: Colors.black),
                          ),
                          const SizedBox(height: 10),
                          if (monthlySalary != null)
                            Text(
                              'Used ${(100 * total / monthlySalary!).toStringAsFixed(1)}% of your income',
                              style: const TextStyle(fontSize: 22, color: Colors.black),
                            ),
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(child: const SizedBox(height: 13)),
                  expensesList.isEmpty
                      ? SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 50),
                        child: Text(
                          'No expenses yet!',
                          style: TextStyle(fontSize: 25, color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  )
                      : SliverList(
                    delegate: SliverChildBuilderDelegate(
                          (context, index) {
                        final item = expensesList[index];
                        return GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text('Delete Expense'),
                                content: Text(
                                  'Do you want to delete "${item['name']}" of Rs. ${item['amount']}?',
                                  style: TextStyle(fontSize: 18),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text('No', style: TextStyle(fontSize: 18)),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      await FirebaseFirestore.instance
                                          .collection('users')
                                          .doc('expenses')
                                          .collection('expenses')
                                          .doc(item.id)
                                          .delete();
                                      Navigator.pop(context);
                                    },
                                    child: Text('Yes', style: TextStyle(fontSize: 18)),
                                  ),
                                ],
                              ),
                            );
                          },
                          child: Container(
                            height: 90,
                            width: double.infinity,
                            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: Colors.white70,
                              borderRadius: BorderRadius.circular(13),
                              boxShadow: [BoxShadow(blurRadius: 10, color: Colors.blueGrey)],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(item['name'] ?? '',
                                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500)),
                                Text('Rs. ${item['amount']}',
                                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        );
                      },
                      childCount: expensesList.length,
                    ),
                  ),
                ],
              );
            },
          ),
          DraggableAddButton(onPressed: addexpense),
        ],
      ),
    );
  }
}
