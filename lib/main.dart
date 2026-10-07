void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => TransactionProvider(),
      child: const MyApp(),
    ),
  );
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: TestScreen());
  }
}
class TestScreen extends StatelessWidget {
  const TestScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Test Insert')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            print('Inserting test data...');
            context.read<TransactionProvider>().addTransaction(
                  'เงินเดือน',
                  20000.0,
                  DateTime.now(),
                  TransactionType.income,
                );
          },
          child: const Text('Add Test Income'),
        ),
      ),
    );
  }
}
