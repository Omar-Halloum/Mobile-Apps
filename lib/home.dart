import 'package:flutter/material.dart';
import 'plant.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String? selectedPlant;
  DateTime? lastWateredDate;
  DateTime? nextWateringDate;

  @override
  void initState() {
    super.initState();
    selectedPlant = plants[0].name;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plant Scheduler'),
        centerTitle: true,
        backgroundColor: Colors.green[400],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/plant_background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Text(
                  'Select Plant Type:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: 250, // Dropdown menu width
                  child: DropdownButton<String>(
                    value: selectedPlant,
                    isExpanded: false,
                    items: plants
                        .map((plant) => DropdownMenuItem(
                      value: plant.name,
                      child: Text(plant.name),
                    ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedPlant = value;
                        _calculateNextWateringDate();
                      });
                    },
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Last Watered Date:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                GestureDetector(
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        lastWateredDate = pickedDate;
                        _calculateNextWateringDate();
                      });
                    }
                  },
                  child: Container(
                    padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      lastWateredDate != null
                          ? _formatDate(lastWateredDate!)
                          : 'Select Date',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Next Watering Date:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Container(
                  padding:
                  const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  child: Text(
                    nextWateringDate != null
                        ? _formatDate(nextWateringDate!)
                        : '---',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _calculateNextWateringDate() {
    if (selectedPlant != null && lastWateredDate != null) {
      int daysToAdd = plants
          .firstWhere((plant) => plant.name == selectedPlant)
          .wateringInterval;
      setState(() {
        nextWateringDate = lastWateredDate!.add(Duration(days: daysToAdd));
      });
    }
  }

  String _formatDate(DateTime date) {
    return '${_addLeadingZero(date.day)}/${_addLeadingZero(date.month)}/${date.year}';
  }

  String _addLeadingZero(int value) {
    return value < 10 ? '0$value' : value.toString();
  }
}