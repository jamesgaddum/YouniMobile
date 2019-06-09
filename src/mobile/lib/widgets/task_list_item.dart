import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:youni/models/entities/task.dart';

class TaskListItem extends StatefulWidget {
  final Task task;
  final Function selectTask;
  final Function deselectTask;
  final Function updateList;
  final Function updateGraph;
  final bool isSelected;
  final Key key;

  TaskListItem(this.task, this.selectTask, this.deselectTask, this.updateList, this.updateGraph, this.isSelected, {this.key}) : super(key: key);

  @override
  _TaskListItemState createState() => _TaskListItemState();
}

class _TaskListItemState extends State<TaskListItem> {

  double _height;
  double _progress = 0;

  @override
  void initState() {
    super.initState();
    _height = widget.task.isSelected ? 70 : 0;
    _progress = widget.task.progress;
  }

  @override
  void didUpdateWidget(TaskListItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {
      _height = widget.task.isSelected ? 70 : 0;
      _progress = widget.task.progress;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: Key(widget.task.taskId.toString()),
      onTap: () => widget.task.isSelected ? widget.deselectTask(widget.task) : widget.selectTask(widget.task),
      behavior: HitTestBehavior.translucent,
      child: Container(
        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        child: Column(
          children: <Widget>[
            IntrinsicHeight(
              child: Row(
                children: [
                  Expanded(
                    flex: 8,
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(bottom: 5),
                            child: Text(
                              widget.task.title, 
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Container(
                            child: Text(
                              widget.task.dueDateString(), 
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 12
                              ),
                            )
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Container(
                      padding: EdgeInsets.only(top: 5),
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Text(
                                widget.task.weightString(),
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w100
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            AnimatedContainer(
              padding: EdgeInsets.only(top: 10),
              duration: Duration(milliseconds: 300),
              curve: Curves.ease,
              height: _height,
              child: widget.task.isSelected ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 6,
                    child: Slider(
                      activeColor: Color.fromRGBO(10, 36, 99, 1),
                      inactiveColor: Color.fromRGBO(10, 36, 99, 0.3),
                      value: _progress,
                      max: 1,
                      onChanged: (double value) => _updateTaskProgress(value),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Center(
                      child: IconButton(
                        icon: Icon(Icons.check),
                        onPressed: () => _updateTaskProgressAndList(_progress),
                      )
                    )
                  )
                ]
              ) : null,
            ),
          ],
        ),
      ),
    );
  }
  
  _updateTaskProgress(value) {
    setState(() {
      _progress = value;
    });
    widget.task.updateProgress(value);
    widget.updateGraph();
  }

  _updateTaskProgressAndList(value) {
    widget.deselectTask(widget.task);
    _updateTaskProgress(value);
    widget.updateList();
  }
}