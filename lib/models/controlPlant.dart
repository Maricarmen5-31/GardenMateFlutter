class ControlPlant {
  final int plantId;
  final String plantName;
  final String species;
  final String size;
  final String category;
  final double humidity;
  final double temperature;
  final double lightning;
  final String imageURL;
  final String fecha;
  final String hora;
  final String decription;

  ControlPlant(
      {required this.plantId,
      required this.plantName,
      required this.species,
      required this.size,
      required this.category,
      required this.humidity,
      required this.temperature,
      required this.lightning,
      required this.imageURL,
      required this.fecha,
      required this.hora,
      required this.decription});

  //List of Plants data
  static List<ControlPlant> plantList = [
    ControlPlant(
        plantId: 0,
        plantName: 'Sanseviera',
        species: 'especie',
        size: 'Small',
        category: 'Indoor',
        humidity: 34,
        temperature: 20.5,
        lightning: 5,
        imageURL: 'assets/images/plant-one.png',
        fecha: '08/01/2024',
        hora: '',
        decription:
            'This plant is one of the best plant. It grows in most of the regions in the world and can survive'
            'even the harshest weather condition.'),
    ControlPlant(
        plantId: 1,
        category: 'Outdoor',
        plantName: 'Philodendron',
        species: 'especie',
        size: 'Medium',
        humidity: 56,
        temperature: 22,
        lightning: 5,
        imageURL: 'assets/images/plant-two.png',
        fecha: '08/01/2024',
        hora: '',
        decription:
            'This plant is one of the best plant. It grows in most of the regions in the world and can survive'
            'even the harshest weather condition.'),
    ControlPlant(
        plantId: 2,
        category: 'Indoor',
        plantName: 'Beach Daisy',
        species: 'especie',
        size: 'Large',
        humidity: 34,
        temperature: 25,
        lightning: 5,
        imageURL: 'assets/images/plant-three.png',
        fecha: '08/01/2024',
        hora: '',
        decription:
            'This plant is one of the best plant. It grows in most of the regions in the world and can survive'
            'even the harshest weather condition.'),
    ControlPlant(
        plantId: 3,
        category: 'Outdoor',
        plantName: 'Big Bluestem',
        species: 'especie',
        size: 'Small',
        humidity: 35,
        temperature: 28,
        lightning: 5,
        imageURL: 'assets/images/plant-one.png',
        fecha: '08/01/2024',
        hora: '',
        decription:
            'This plant is one of the best plant. It grows in most of the regions in the world and can survive'
            'even the harshest weather condition.'),
    ControlPlant(
        plantId: 4,
        category: 'Recommended',
        plantName: 'Big Bluestem',
        species: 'especie',
        size: 'Large',
        humidity: 66,
        temperature: 16,
        lightning: 5,
        imageURL: 'assets/images/plant-four.png',
        fecha: '08/01/2024',
        hora: '',
        decription:
            'This plant is one of the best plant. It grows in most of the regions in the world and can survive'
            'even the harshest weather condition.'),
    ControlPlant(
        plantId: 5,
        category: 'Outdoor',
        plantName: 'Meadow Sage',
        species: 'especie',
        size: 'Medium',
        humidity: 36,
        temperature: 18,
        lightning: 5,
        imageURL: 'assets/images/plant-five.png',
        fecha: '08/01/2024',
        hora: '',
        decription:
            'This plant is one of the best plant. It grows in most of the regions in the world and can survive'
            'even the harshest weather condition.'),
    ControlPlant(
        plantId: 6,
        category: 'Garden',
        plantName: 'Plumbago',
        species: 'especie',
        size: 'Small',
        humidity: 46,
        temperature: 26,
        lightning: 5,
        imageURL: 'assets/images/plant-six.png',
        fecha: '08/01/2024',
        hora: '',
        decription:
            'This plant is one of the best plant. It grows in most of the regions in the world and can survive'
            'even the harshest weather condition.'),
    ControlPlant(
        plantId: 7,
        category: 'Garden',
        plantName: 'Tritonia',
        species: '',
        size: 'Medium',
        humidity: 34,
        temperature: 24,
        lightning: 5,
        imageURL: 'assets/images/plant-seven.png',
        fecha: '08/01/2024',
        hora: '',
        decription:
            'This plant is one of the best plant. It grows in most of the regions in the world and can survive'
            'even the harshest weather condition.'),
    ControlPlant(
        plantId: 8,
        category: 'Recommended',
        plantName: 'Tritonia',
        species: '',
        size: 'Medium',
        humidity: 46,
        temperature: 25,
        lightning: 5,
        imageURL: 'assets/images/plant-eight.png',
        fecha: '08/01/2024',
        hora: '',
        decription:
            'This plant is one of the best plant. It grows in most of the regions in the world and can survive'
            'even the harshest weather condition.'),
  ];
}
