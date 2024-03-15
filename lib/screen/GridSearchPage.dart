import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GridSearchPage extends StatefulWidget {
  const GridSearchPage({super.key});

  @override
  _GridSearchPageState createState() => _GridSearchPageState();
}

class _GridSearchPageState extends State<GridSearchPage> {
  int m = 0;
  int n = 0;
  int rows = 0;
  int column = 0;
  List<List<String>> grid = [];
  String searchText = '';
  List<List<bool>> highlight = [];

  void createGrid() {
    m=rows;
    n=column;
    grid = List.generate(m, (i) => List.filled(n, ''));
    highlight = List.generate(m, (i) => List.filled(n, false));
  }

  void searchInGrid() {
    highlight = List.generate(m, (i) => List.filled(n, false));

    for (int i = 0; i < m; i++) {
      for (int j = 0; j < n; j++) {
        // Search horizontally (left to right)
        if (j + searchText.length <= n) {
          bool found = true;
          for (int k = 0; k < searchText.length; k++) {
            if (grid[i][j + k] != searchText[k]) {
              found = false;
              break;
            }
          }
          if (found) {
            for (int k = 0; k < searchText.length; k++) {
              highlight[i][j + k] = true;
            }
          }
        }
        // Search vertically (top to bottom)
        if (i + searchText.length <= m) {
          bool found = true;
          for (int k = 0; k < searchText.length; k++) {
            if (grid[i + k][j] != searchText[k]) {
              found = false;
              break;
            }
          }
          if (found) {
            for (int k = 0; k < searchText.length; k++) {
              highlight[i + k][j] = true;
            }
          }
        }
        // Search diagonally (top-left to bottom-right)
        if (i + searchText.length <= m && j + searchText.length <= n) {
          bool found = true;
          for (int k = 0; k < searchText.length; k++) {
            if (grid[i + k][j + k] != searchText[k]) {
              found = false;
              break;
            }
          }
          if (found) {
            for (int k = 0; k < searchText.length; k++) {
              highlight[i + k][j + k] = true;
            }
          }
        }
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Grid Search'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text('Enter table no. rows & column'),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(labelText: 'Row'),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        setState(() {
                          rows = int.tryParse(value) ?? 0;
                        });
                      },
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(labelText: 'Column'),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        setState(() {
                          column = int.tryParse(value) ?? 0;
                        });
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  createGrid();
                  setState(() {});
                },
                child: Text('Create Table'),
              ),
              SizedBox(height: 20),
              if (grid.isNotEmpty)
                Column(
                  children: [
                    Text('Search Text:'),
                    TextField(
                      onChanged: (value) {
                        searchText = value;
                      },
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        searchInGrid();
                      },
                      child: Text('Search'),
                    ),
                    SizedBox(height: 20),
                    Text('Enter value in below table:'),
                    GridView.builder(
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: n,
                      ),
                      itemBuilder: (context, index) {
                        int row = index ~/ n;
                        int col = index % n;
                        return Container(
                            decoration: BoxDecoration(
                              border: Border.all(),
                              color: highlight[row][col]
                                  ? Colors.yellow
                                  : Colors.white,
                            ),
                            alignment: Alignment.center,
                            child: TextField(
                              onChanged: (value) {
                                grid[index ~/ n][index % n] = value.isNotEmpty
                                    ? value.substring(0, 1)
                                    : '';
                              },
                            )
                          // Text(grid[row][col]),
                        );
                      },
                      itemCount: m * n,
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}