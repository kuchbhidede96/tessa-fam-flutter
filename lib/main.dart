
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graphview/GraphView.dart';

// Data model for a family member
class FamilyMember {
  final int id;
  final String name;
  final String? spouseName;

  FamilyMember({required this.id, required this.name, this.spouseName});
}

void main() {
  runApp(const FamilyTreeApp());
}

class FamilyTreeApp extends StatelessWidget {
  const FamilyTreeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Family Tree App',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
        textTheme: GoogleFonts.latoTextTheme(),
      ),
      home: const FamilyTreePage(),
    );
  }
}

class FamilyTreePage extends StatefulWidget {
  const FamilyTreePage({super.key});

  @override
  _FamilyTreePageState createState() => _FamilyTreePageState();
}

class _FamilyTreePageState extends State<FamilyTreePage> {
  final Graph graph = Graph();
  final SugiyamaConfiguration builder = SugiyamaConfiguration();

  @override
  void initState() {
    super.initState();
    // Build the family tree graph
    buildFamilyTree();
  }

  void buildFamilyTree() {
    // 1. Create family member instances
    final greatGrandfather = FamilyMember(id: 1, name: 'Great Grandfather');
    final greatGrandmother = FamilyMember(id: 2, name: 'Great Grandmother', spouseName: 'Great Grandfather');
    final grandfather = FamilyMember(id: 3, name: 'Grandfather');
    final grandmother = FamilyMember(id: 4, name: 'Grandmother', spouseName: 'Grandfather');
    final father = FamilyMember(id: 5, name: 'Father');
    final mother = FamilyMember(id: 6, name: 'Mother', spouseName: 'Father');
    final uncle = FamilyMember(id: 7, name: 'Uncle');
    final aunt = FamilyMember(id: 8, name: 'Aunt', spouseName: 'Uncle');
    final me = FamilyMember(id: 9, name: 'Me');
    final brother = FamilyMember(id: 10, name: 'Brother');
    final cousin = FamilyMember(id: 11, name: 'Cousin');

    // 2. Create nodes from family members
    final nodes = {
      greatGrandfather.id: Node.Id(greatGrandfather),
      greatGrandmother.id: Node.Id(greatGrandmother),
      grandfather.id: Node.Id(grandfather),
      grandmother.id: Node.Id(grandmother),
      father.id: Node.Id(father),
      mother.id: Node.Id(mother),
      uncle.id: Node.Id(uncle),
      aunt.id: Node.Id(aunt),
      me.id: Node.Id(me),
      brother.id: Node.Id(brother),
      cousin.id: Node.Id(cousin),
    };

    // 3. Add edges to define relationships
    graph.addEdge(nodes[greatGrandfather.id]!, nodes[grandfather.id]!);
    graph.addEdge(nodes[greatGrandmother.id]!, nodes[grandfather.id]!);
    graph.addEdge(nodes[grandfather.id]!, nodes[father.id]!);
    graph.addEdge(nodes[grandmother.id]!, nodes[father.id]!);
    graph.addEdge(nodes[grandfather.id]!, nodes[uncle.id]!);
    graph.addEdge(nodes[grandmother.id]!, nodes[uncle.id]!);
    graph.addEdge(nodes[father.id]!, nodes[me.id]!);
    graph.addEdge(nodes[mother.id]!, nodes[me.id]!);
    graph.addEdge(nodes[father.id]!, nodes[brother.id]!);
    graph.addEdge(nodes[mother.id]!, nodes[brother.id]!);
    graph.addEdge(nodes[uncle.id]!, nodes[cousin.id]!);
    graph.addEdge(nodes[aunt.id]!, nodes[cousin.id]!);


    // 4. Configure the layout algorithm
    builder
      ..nodeSeparation = 30
      ..levelSeparation = 50
      ..orientation = SugiyamaConfiguration.ORIENTATION_TOP_BOTTOM;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Family Tree'),
        centerTitle: true,
      ),
      body: InteractiveViewer(
        constrained: false,
        boundaryMargin: const EdgeInsets.all(20),
        minScale: 0.1,
        maxScale: 2.0,
        child: GraphView(
          graph: graph,
          algorithm: SugiyamaAlgorithm(builder),
          builder: (Node node) {
            final familyMember = node.key!.value as FamilyMember;
            return FamilyMemberNode(familyMember: familyMember);
          },
        ),
      ),
    );
  }
}

// Custom widget to display a family member in the tree
class FamilyMemberNode extends StatelessWidget {
  final FamilyMember familyMember;

  const FamilyMemberNode({super.key, required this.familyMember});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              familyMember.name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            if (familyMember.spouseName != null) ...[
              const SizedBox(height: 4),
              Text(
                '& ${familyMember.spouseName}',
                style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 14),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
