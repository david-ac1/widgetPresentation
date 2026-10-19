import 'package:flutter/material.dart';

void main() {
  runApp(const MailboxApp());
}

class MailboxApp extends StatelessWidget {
  const MailboxApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mailbox',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF176B87),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const MailboxPage(),
    );
  }
}

class MailItem {
  const MailItem({
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

const _starterMessages = [
  MailItem(
    id: 1,
    title: 'Maya Chen',
    subtitle: 'Your weekly design review is ready',
    icon: Icons.mark_email_unread_outlined,
    color: Color(0xFFE6F4F1),
  ),
  MailItem(
    id: 2,
    title: 'Campus Events',
    subtitle: 'Three events happening this weekend',
    icon: Icons.calendar_month_outlined,
    color: Color(0xFFFFF1D6),
  ),
  MailItem(
    id: 3,
    title: 'Jordan Williams',
    subtitle: 'Can we move our meeting to Friday?',
    icon: Icons.description_outlined,
    color: Color(0xFFEDE7F6),
  ),
  MailItem(
    id: 4,
    title: 'ShopSmart',
    subtitle: 'Your order has shipped',
    icon: Icons.shopping_basket_outlined,
    color: Color(0xFFFFE7E4),
  ),
];

class MailboxPage extends StatefulWidget {
  const MailboxPage({super.key});

  @override
  State<MailboxPage> createState() => _MailboxPageState();
}

class _MailboxPageState extends State<MailboxPage> {
  final List<MailItem> _messages = List.of(_starterMessages);
  DismissDirection _direction = DismissDirection.endToStart;
  bool _showBackground = true;
  Duration? _resizeDuration = const Duration(milliseconds: 300);

  void _restoreMessages() {
    setState(
      () => _messages
        ..clear()
        ..addAll(_starterMessages),
    );
  }

  void _archiveMessage(MailItem message) {
    final messageIndex = _messages.indexOf(message);
    setState(() => _messages.remove(message));

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('"${message.title}" archived'),
        action: SnackBarAction(
          label: 'UNDO',
          onPressed: () {
            setState(() => _messages.insert(messageIndex, message));
          },
        ),
      ),
    );
  }

  void _openSwipePreferences() {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) => _SwipePreferencesSheet(
        direction: _direction,
        showBackground: _showBackground,
        resizeDuration: _resizeDuration,
        onDirectionChanged: (value) => setState(() => _direction = value),
        onBackgroundChanged: (value) => setState(() => _showBackground = value),
        onResizeDurationChanged: (value) =>
            setState(() => _resizeDuration = value),
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
        title: const Text('Mailbox'),
        actions: [
          IconButton(
            onPressed: _openSwipePreferences,
            tooltip: 'Swipe preferences',
            icon: const Icon(Icons.tune_rounded),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
          children: [
            Text(
              'Inbox',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Swipe left on a message to archive it.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'All messages',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  '${_messages.length} unread',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (_messages.isEmpty)
              _EmptyState(onRestore: _restoreMessages)
            else
              ..._messages.map(
                (message) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Dismissible(
                    key: ValueKey(message.id),
                    direction: _direction,
                    background: _showBackground
                        ? _swipeBackground(
                            color: const Color(0xFF2E8B75),
                            icon: Icons.archive_outlined,
                            alignment: Alignment.centerLeft,
                          )
                        : null,
                    secondaryBackground: _showBackground
                        ? _swipeBackground(
                            color: const Color(0xFF2E8B75),
                            icon: Icons.archive_outlined,
                            alignment: Alignment.centerRight,
                          )
                        : null,
                    resizeDuration: _resizeDuration,
                    onDismissed: (_) => _archiveMessage(message),
                    child: _MailCard(message: message),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _MailCard extends StatelessWidget {
  const _MailCard({required this.message});

  final MailItem message;

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
              backgroundColor: message.color,
              child: Icon(message.icon, color: const Color(0xFF176B87)),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    message.subtitle,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_left_rounded,
              color: Theme.of(context).colorScheme.outline,
            ),
          ],
        ),
      ),
    );
  }
}

class _SwipePreferencesSheet extends StatelessWidget {
  const _SwipePreferencesSheet({
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
              'Swipe preferences',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              'Choose how messages behave when you archive them.',
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
                  child: Text('endToStart (recommended)'),
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
            const Icon(Icons.mark_email_read_outlined, size: 52),
            const SizedBox(height: 12),
            const Text(
              'Inbox zero',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            const Text('You have archived every message.'),
            const SizedBox(height: 14),
            OutlinedButton(
              onPressed: onRestore,
              child: const Text('Restore messages'),
            ),
          ],
        ),
      ),
    );
  }
}
