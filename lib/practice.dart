import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class Practice extends StatefulWidget {
  const Practice({super.key});

  @override
  State<Practice> createState() => _PracticeState();
}

class _PracticeState extends State<Practice> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                bool isWide = constraints.maxWidth > 400;
                return isWide
                    ? Row(children: _productCard())
                    : Column(children: _productCard());
              },
            ),

            // 2. Stack Overlapping Notification Badge
            // Question: Create a reusable profile avatar with an online status
            // indicator dot stacked on its bottom-right edge using Stack and Positioned.
            Stack(
              children: [
                Container(child: CircleAvatar(child: Icon(Icons.person))),
                Positioned(
                  bottom: 10,
                  right: 1,
                  child: Container(
                    height: 5,
                    width: 5,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red,
                    ),
                  ),
                ),
              ],
            ),

            //3. GridView with Dynamic Aspect Ratios
            // Question: Implement a 2-column GridView.builder that renders cards
            // with a custom aspect ratio (childAspectRatio: 3/2).
            Container(
              height: 400,
              child: GridView.builder(
                itemCount: 6,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,

                  childAspectRatio: 3 / 2,
                ),
                itemBuilder: (context, index) {
                  return Container(
                    child: Column(children: [Text("grid numbers $index")]),
                  );
                },
              ),
            ),



// 4. Custom Slivers for Parallax App Bar
// Question: Create a scrollable view with a sticky header that collapses
//  as you scroll using CustomScrollView and SliverAppBar.

Row(
          children: [
            Container(width: 50, height: 50, color: Colors.red),
            Flexible(
              child: Container(
                height: 50,
                color: Colors.green,
                child: const Text('Flexible (Takes fitting space)', overflow: TextOverflow.ellipsis),
              ),
            ),
            Expanded(
              child: Container(
                height: 50,
                color: Colors.blue,
                child: const Text('Expanded (Fills remaining space)'),
              ),
            ),
          ],
        ),

          ],
        ),
      ),
    );
  }

  List<Widget> _productCard() {
    return [Text("Product name"), Text("Description")];
  }
}
