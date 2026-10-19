import 'package:flutter/material.dart';

void main() {
  runApp(const TaskSwipeDemo());
}

class TaskSwipeDemo extends StatelessWidget {
  const TaskSwipeDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Swipe to Clear',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF176B87),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const TaskInboxPage(),
    );
  }
}

class TaskItem {
  const TaskItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  final int id;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
}

const _starterTasks = [
  TaskItem(
    id: 1,
    title: 'Reply to project feedback',
    subtitle: 'Work inbox • Due today',
    icon: Icons.mark_email_unread_outlined,
    color: Color(0xFFE6F4F1),
  ),
  TaskItem(
    id: 2,
    title: 'Book a dentist appointment',
    subtitle: 'Personal • Due tomorrow',
    icon: Icons.calendar_month_outlined,
    color: Color(0xFFFFF1D6),
  ),
  TaskItem(
    id: 3,
    title: 'Review the sprint notes',
    subtitle: 'Work inbox • Friday',
    icon: Icons.description_outlined,
    color: Color(0xFFEDE7F6),
  ),
  TaskItem(
    id: 4,
    title: 'Pick up groceries',
    subtitle: 'Errands • Saturday',
    icon: Icons.shopping_basket_outlined,
    color: Color(0xFFFFE7E4),
  ),
];

class TaskInboxPage extends StatefulWidget {
  const TaskInboxPage({super.key});

  @override
  State<TaskInboxPage> createState() => _TaskInboxPageState();
}

class _TaskInboxPageState extends State<TaskInboxPage> {
  final List<TaskItem> _tasks = List.of(_starterTasks);
  DismissDirection _direction = DismissDirection.endToStart;
  bool _showBackground = true;
  Duration? _resizeDuration = const Duration(milliseconds: 300);

  void _restoreTasks() {
    setState(
      () => _tasks
        ..clear()
        ..addAll(_starterTasks),
    );
  }

  void _dismissTask(TaskItem task) {
    final taskIndex = _tasks.indexOf(task);
    setState(() => _tasks.remove(task));

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('"${task.title}" marked as complete'),
        action: SnackBarAction(
          label: 'UNDO',
          onPressed: () {
            setState(() => _tasks.insert(taskIndex, task));
          },
        ),
      ),
    );
  }

  Widget _swipeBackground({
    required Color color,
    required IconData icon,
    required Alignment alignment,
  }) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Align(
        alignment: alignment,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Icon(icon, color: Colors.white, size: 28),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FA),
      appBar: AppBar(
        title: const Text('Today'),
        actions: [
          IconButton(
            onPressed: _restoreTasks,
            tooltip: 'Restore sample tasks',
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
          children: [
            Text(
              'Swipe to clear',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Finish a task by swiping it away. The app responds instantly and offers an undo action.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 20),
            _DemoControls(
              direction: _direction,
              showBackground: _showBackground,
              resizeDuration: _resizeDuration,
              onDirectionChanged: (value) {
                setState(() => _direction = value);
              },
              onBackgroundChanged: (value) {
                setState(() => _showBackground = value);
              },
              onResizeDurationChanged: (value) {
                setState(() => _resizeDuration = value);
              },
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Open tasks',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  '${_tasks.length} remaining',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (_tasks.isEmpty)
              _EmptyState(onRestore: _restoreTasks)
            else
              ..._tasks.map(
                (task) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Dismissible(
                    key: ValueKey(task.id),
                    direction: _direction,
                    background: _showBackground
                        ? _swipeBackground(
                            color: const Color(0xFF2E8B75),
                            icon: Icons.check_rounded,
                            alignment: Alignment.centerLeft,
                          )
                        : null,
                    secondaryBackground: _showBackground
                        ? _swipeBackground(
                            color: const Color(0xFF2E8B75),
                            icon: Icons.check_rounded,
                            alignment: Alignment.centerRight,
                          )
                        : null,
                    resizeDuration: _resizeDuration,
                    onDismissed: (_) => _dismissTask(task),
                    child: _TaskCard(task: task),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _TaskCard extends StatelessWidget {
  const _TaskCard({required this.task});

  final TaskItem task;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: task.color,
              child: Icon(task.icon, color: const Color(0xFF176B87)),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    task.subtitle,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.swipe_outlined,
              color: Theme.of(context).colorScheme.outline,
            ),
          ],
        ),
      ),
    );
  }
}

class _DemoControls extends StatelessWidget {
  const _DemoControls({
    required this.direction,
    required this.showBackground,
    required this.resizeDuration,
    required this.onDirectionChanged,
    required this.onBackgroundChanged,
    required this.onResizeDurationChanged,
  });

  final DismissDirection direction;
  final bool showBackground;
  final Duration? resizeDuration;
  final ValueChanged<DismissDirection> onDirectionChanged;
  final ValueChanged<bool> onBackgroundChanged;
  final ValueChanged<Duration?> onResizeDurationChanged;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.primaryContainer.withAlpha(100),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Presentation controls',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              'Change one Dismissible property, then swipe a task to compare.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 14),
            _PropertyChoice<DismissDirection>(
              label: 'direction',
              valueLabel: direction == DismissDirection.horizontal
                  ? 'horizontal'
                  : 'endToStart',
              value: direction,
              options: const [
                DropdownMenuItem(
                  value: DismissDirection.endToStart,
                  child: Text('endToStart (default demo)'),
                ),
                DropdownMenuItem(
                  value: DismissDirection.horizontal,
                  child: Text('horizontal'),
                ),
              ],
              onChanged: (value) {
                if (value != null) onDirectionChanged(value);
              },
            ),
            _PropertyChoice<bool>(
              label: 'background',
              valueLabel: showBackground ? 'shown' : 'null',
              value: showBackground,
              options: const [
                DropdownMenuItem(value: true, child: Text('shown')),
                DropdownMenuItem(value: false, child: Text('null')),
              ],
              onChanged: (value) {
                if (value != null) onBackgroundChanged(value);
              },
            ),
            _PropertyChoice<Duration?>(
              label: 'resizeDuration',
              valueLabel: resizeDuration == null ? 'null' : '300 ms',
              value: resizeDuration,
              options: const [
                DropdownMenuItem(
                  value: Duration(milliseconds: 300),
                  child: Text('300 ms (default)'),
                ),
                DropdownMenuItem(value: null, child: Text('null')),
              ],
              onChanged: onResizeDurationChanged,
            ),
          ],
        ),
      ),
    );
  }
}

class _PropertyChoice<T> extends StatelessWidget {
  const _PropertyChoice({
    required this.label,
    required this.valueLabel,
    required this.value,
    required this.options,
    required this.onChanged,
  });

  final String label;
  final String valueLabel;
  final T value;
  final List<DropdownMenuItem<T>> options;
  final ValueChanged<T?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '$label = $valueLabel',
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ),
          DropdownButton<T>(
            value: value,
            items: options,
            onChanged: onChanged,
            isDense: true,
            underline: const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onRestore});

  final VoidCallback onRestore;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          children: [
            const Icon(Icons.task_alt_rounded, size: 52),
            const SizedBox(height: 12),
            const Text(
              'Inbox clear!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            const Text('All sample tasks have been completed.'),
            const SizedBox(height: 14),
            OutlinedButton(
              onPressed: onRestore,
              child: const Text('Restore tasks'),
            ),
          ],
        ),
      ),
    );
  }
}
