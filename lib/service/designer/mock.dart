import 'package:client/models/models.dart';
import 'data.dart';

final prog = new Program(name: 'Medis', width: 300, height: 150)
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
  )
  ..newPage(
      name: "Page 2",
      color: 'green',
      image:
          'https://hips.hearstapps.com/pop.h-cdn.co/assets/cm/15/05/54cb00c759e04_-_mars-2020-1212-k24s8k-mdn.jpg?crop=1xw:0.6666666666666666xh;center,top&resize=640:*')
  ..newPage(name: "Page 3", color: 'yellow')
  ..newPage(name: "Page 4", color: 'orange');

class MockService implements DataService {
  Program getProgramById(String id) {
    return prog;
  }

  Program saveProgram(String id, Program program) {
    prog.fromMap(program.toMap);
    return prog;
  }

  Program publish(String id) => prog;
}

DataService service = new MockService();
