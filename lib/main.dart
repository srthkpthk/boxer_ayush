import 'package:boxer/cubit/boxer_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        colorScheme: const ColorScheme.dark(
          primary: Colors.deepPurple,
          secondary: Colors.deepPurpleAccent,
        ),
        cardTheme: CardTheme(
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.deepPurple),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.deepPurple.shade200),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.deepPurple.shade400, width: 2),
          ),
        ),
      ),
      home: BlocProvider(
        create: (context) => BoxerCubit(),
        child: const HomePage(),
      ),
    );
  }
}

class HomePage extends HookWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scrollController = useScrollController();
    final isCalculated = useState(false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Box Calculation'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: NotificationListener<OverscrollIndicatorNotification>(
              onNotification: (overscroll) {
                overscroll.disallowIndicator();
                return true;
              },
              child: ListView(
                controller: scrollController,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                children: [
                  _AnimatedCard(child: _Board()),
                  const SizedBox(height: 16),
                  _AnimatedCard(child: _Lamination()),
                  const SizedBox(height: 16),
                  _AnimatedCard(child: _Printing()),
                  const SizedBox(height: 16),
                  _AnimatedCard(child: _Pasting()),
                  const SizedBox(height: 16),
                  _AnimatedCard(child: _DieCutting()),
                  const SizedBox(height: 16),
                  _AnimatedCard(child: _Stitching()),
                  const SizedBox(height: 16),
                  _AnimatedCard(child: _Conversion()),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  opacity: isCalculated.value ? 1.0 : 0.5,
                  child: ElevatedButton(
                    onPressed: () {
                      context.read<BoxerCubit>().calculate();
                      isCalculated.value = true;
                      scrollController.animateTo(
                        scrollController.position.maxScrollExtent,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 56),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'Calculate Final',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: isCalculated.value
                      ? Container(
                          key: const ValueKey('result'),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.deepPurple.shade800,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Total Cost: ',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                context
                                    .watch<BoxerCubit>()
                                    .state
                                    .finalCalculation
                                    .toStringAsFixed(2),
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        )
                      : const SizedBox.shrink(key: ValueKey('empty')),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AnimatedCard extends HookWidget {
  final Widget child;

  const _AnimatedCard({required this.child});

  @override
  Widget build(BuildContext context) {
    final animationController = useAnimationController(
      duration: const Duration(milliseconds: 500),
    );
    final animation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.easeOutBack,
      ),
    );

    useEffect(() {
      animationController.forward();
      return () => animationController.dispose();
    }, []);

    return ScaleTransition(
      scale: animation,
      child: child,
    );
  }
}

class _Pasting extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final length = useTextEditingController();
    final width = useTextEditingController();
    final rate = useTextEditingController();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pasting',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            _InPutBox(
              controller: length,
              label: 'Length',
            ),
            _InPutBox(
              controller: width,
              label: 'Width',
            ),
            _InPutBox(
              controller: rate,
              label: 'Rate',
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                var calculation = (double.parse(length.text) *
                        double.parse(width.text) *
                        double.parse(rate.text)) /
                    1307;

                context.read<BoxerCubit>().addPastingCalculation(calculation);
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Calculate Pasting'),
            ),
            const SizedBox(height: 16),
            Text(
              'Current Calculation: ${context.watch<BoxerCubit>().state.pastingCalculation.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}

class _DieCutting extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final dieCutting = useTextEditingController();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Die Cutting',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            _InPutBox(
              controller: dieCutting,
              label: 'Die Cutting',
              onChanged: (value) => context
                  .read<BoxerCubit>()
                  .addDieCuttingCalculation(double.parse(value)),
            ),
            const SizedBox(height: 16),
            Text(
              'Current Calculation: ${context.watch<BoxerCubit>().state.dieCuttingCalculation.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}

class _Stitching extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final stitching = useTextEditingController();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Stitching',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            _InPutBox(
              controller: stitching,
              label: 'Stitching',
              onChanged: (value) => context
                  .read<BoxerCubit>()
                  .addStitchingCalculation(double.parse(value)),
            ),
            const SizedBox(height: 16),
            Text(
              'Current Calculation: ${context.watch<BoxerCubit>().state.stitchingCalculation.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}

class _Conversion extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final conversion = useTextEditingController();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Conversion',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            _InPutBox(
              controller: conversion,
              label: 'Conversion',
              onChanged: (value) => context
                  .read<BoxerCubit>()
                  .addConversionCalculation(double.parse(value)),
            ),
            const SizedBox(height: 16),
            Text(
              'Current Calculation: ${context.watch<BoxerCubit>().state.conversionCalculation.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Profit: ${context.watch<BoxerCubit>().state.profitCalculation.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.greenAccent,
                      ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class _InPutBox extends StatelessWidget {
  const _InPutBox({
    required this.controller,
    required this.label,
    this.onChanged,
    this.validator,
  });

  final TextEditingController controller;
  final String label;
  final Function(String value)? onChanged;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        onChanged: onChanged,
        validator: validator ??
            (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a value';
              }
              if (double.tryParse(value) == null) {
                return 'Please enter a valid number';
              }
              return null;
            },
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          hintText: 'Enter $label',
          prefixIcon: Icon(Icons.calculate,
              color: Theme.of(context).colorScheme.secondary),
          errorStyle: const TextStyle(color: Colors.redAccent),
        ),
        autovalidateMode: AutovalidateMode.onUserInteraction,
      ),
    );
  }
}

class _Board extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final length = useTextEditingController();
    final width = useTextEditingController();
    final gram = useTextEditingController();
    final rate = useTextEditingController();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Board',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            _InPutBox(
              controller: length,
              label: 'Length',
            ),
            _InPutBox(
              controller: width,
              label: 'Width',
            ),
            _InPutBox(
              controller: gram,
              label: 'Gram',
            ),
            _InPutBox(
              controller: rate,
              label: 'Rate',
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                var calculation = ((double.parse(length.text) *
                            double.parse(width.text) *
                            double.parse(gram.text)) /
                        1521) *
                    double.parse(rate.text);

                context.read<BoxerCubit>().addBoardCalculation(calculation);
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Calculate Board'),
            ),
            const SizedBox(height: 16),
            Text(
              'Current Calculation: ${context.watch<BoxerCubit>().state.boardCalculation.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}

class _Lamination extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final length = useTextEditingController();
    final width = useTextEditingController();
    final rate = useTextEditingController();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Lamination',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            _InPutBox(
              controller: length,
              label: 'Length',
            ),
            _InPutBox(
              controller: width,
              label: 'Width',
            ),
            _InPutBox(
              controller: rate,
              label: 'Rate',
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                var calculation = (double.parse(length.text) *
                        double.parse(width.text) *
                        double.parse(rate.text)) /
                    1000;

                context
                    .read<BoxerCubit>()
                    .addLaminationCalculation(calculation);
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Calculate Lamination'),
            ),
            const SizedBox(height: 16),
            Text(
              'Current Calculation: ${context.watch<BoxerCubit>().state.laminationCalculation.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}

class _Printing extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final rate = useTextEditingController();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Printing',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            _InPutBox(
              controller: rate,
              label: 'Rate',
              onChanged: (value) => context
                  .read<BoxerCubit>()
                  .addPrintingCalculation(double.parse(value)),
            ),
            const SizedBox(height: 16),
            Text(
              'Current Calculation: ${context.watch<BoxerCubit>().state.printingCalculation.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}
