import 'service.dart';
import 'package:client/models/models.dart';
import 'package:bson_objectid/bson_objectid.dart';

final programs = <Program>[
  new Program(name: 'Medis', width: 300, height: 150)
    ..newPage(
      name: "Page 1",
      color: 'blue',
      items: [
        new ImageItem(
            width: 300,
            height: 150,
            left: 0,
            top: 0,
            url:
                'https://www.ebuyer.com/blog/wp-content/uploads/2017/01/shutterstock_280630649-4-300x150.jpg'),
        new TextItem(
            width: 70, height: 18, left: 125, top: 128, text: 'Evolution'),
      ],
    ),
  new Program(name: 'Lijeholmen', width: 100, height: 150)
    ..newPage(
        name: "Page 2",
        color: 'green',
        image:
            'https://hips.hearstapps.com/pop.h-cdn.co/assets/cm/15/05/54cb00c759e04_-_mars-2020-1212-k24s8k-mdn.jpg?crop=1xw:0.6666666666666666xh;center,top&resize=640:*')
    ..newPage(name: "Page 3", color: 'yellow')
    ..newPage(name: "Page 4", color: 'orange'),
  new Program(name: 'Globen', width: 100, height: 400)
    ..newPage(
        name: "Page 2",
        color: 'red',
        image:
            'https://hips.hearstapps.com/pop.h-cdn.co/assets/cm/15/05/54cb00c759e04_-_mars-2020-1212-k24s8k-mdn.jpg?crop=1xw:0.6666666666666666xh;center,top&resize=640:*')
    ..newPage(name: "Page 3", color: 'yellow')
    ..newPage(name: "Page 4", color: 'orange'),
];

class MockService implements Service {
  @override
  List<Program> getPrograms() => programs;

  @override
  Program getProgramById(String id) =>
      programs.firstWhere((prog) => prog.id == id, orElse: () => null);

  List<Program> createPrograms(ProgramCreator temp) {
    Program program = new Program(
        id: new ObjectId().toHexString(),
        name: temp.name,
        width: temp.width,
        height: temp.height);
    programs.add(program);
    return programs;
  }

  List<Program> updateProgram(String id, ProgramCreator program) {
    Program p = programs.firstWhere((p) => p.id == id, orElse: () => null);
    if (p != null) {
      p.name = program.name;
      p.width = program.width;
      p.height = program.height;
    }
    return programs;
  }

  List<Program> deleteProgram(String id) {
    programs.removeWhere((p) => p.id == id);
    return programs;
  }
}

MockService service = new MockService();
