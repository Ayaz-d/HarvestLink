import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/app_state.dart';
import '../../data/models.dart';
import '../../openai/openai_config.dart';
import '../../theme.dart';

class AiAssistantScreen extends StatefulWidget {
  final bool isFarmer;

  const AiAssistantScreen({super.key, required this.isFarmer});

  @override
  State<AiAssistantScreen> createState() => _AiAssistantScreenState();
}

class _AiAssistantScreenState extends State<AiAssistantScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  bool _isTyping = false;

  void _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    _controller.clear();

    final role = widget.isFarmer ? UserRole.farmer : UserRole.customer;
    final state = context.read<AppState>();
    
    state.addMessage(text, true, role);
    setState(() => _isTyping = true);
    _scrollToBottom();

    final response = await OpenAIApi.sendMessage(prompt: text, isFarmer: widget.isFarmer);
    
    if (mounted) {
      state.addMessage(response, false, role);
      setState(() => _isTyping = false);
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final messages = widget.isFarmer ? state.farmerChat : state.customerChat;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isKannada = state.isKannada;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.smart_toy_rounded, color: colorScheme.primary),
            const SizedBox(width: AppSpacing.sm),
            Text(isKannada ? 'ಕೃಷಿ AI' : 'AI Assistant'),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: messages.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.chat_bubble_outline_rounded, size: 60, color: colorScheme.outline.withOpacity(0.5)),
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          isKannada ? 'ನಾನು ಹೇಗೆ ಸಹಾಯ ಮಾಡಲಿ?' : 'How can I help you today?',
                          style: context.textStyles.titleLarge?.copyWith(color: colorScheme.onSurfaceVariant),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: AppSpacing.paddingLg,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final msg = messages[index];
                      return _MessageBubble(message: msg);
                    },
                  ),
          ),
          if (_isTyping)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text('AI is typing...', style: context.textStyles.labelMedium),
                  ],
                ),
              ),
            ),
          SafeArea(
            child: Padding(
              padding: AppSpacing.paddingLg,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: isKannada ? 'ಸಂದೇಶ ಟೈಪ್ ಮಾಡಿ...' : 'Type a message...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppRadius.xl),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: colorScheme.surfaceVariant,
                        contentPadding: AppSpacing.paddingLg,
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Container(
                    decoration: BoxDecoration(
                      color: colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.send_rounded),
                      color: colorScheme.onPrimary,
                      onPressed: _sendMessage,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Container(
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.mic_rounded),
                      color: colorScheme.onPrimaryContainer,
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Voice input coming soon.')),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final ChatMessage message;

  const _MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isUser = message.isUser;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUser) ...[
            Container(
              padding: AppSpacing.paddingSm,
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.smart_toy_rounded, size: 20, color: theme.colorScheme.onPrimaryContainer),
            ),
            const SizedBox(width: AppSpacing.sm),
          ],
          Flexible(
            child: Container(
              padding: AppSpacing.paddingLg,
              decoration: BoxDecoration(
                color: isUser ? theme.colorScheme.primary : theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(AppRadius.lg).copyWith(
                  bottomRight: isUser ? Radius.zero : const Radius.circular(AppRadius.lg),
                  bottomLeft: !isUser ? Radius.zero : const Radius.circular(AppRadius.lg),
                ),
                border: isUser ? null : Border.all(color: theme.colorScheme.outline.withOpacity(0.1)),
                boxShadow: [
                  if (!isUser)
                    BoxShadow(
                      color: theme.colorScheme.shadow.withOpacity(0.05),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                ],
              ),
              child: Text(
                message.text,
                style: context.textStyles.bodyMedium?.copyWith(
                  color: isUser ? theme.colorScheme.onPrimary : theme.colorScheme.onSurface,
                ),
              ),
            ),
          ),
          if (isUser) ...[
            const SizedBox(width: AppSpacing.sm),
            Container(
              padding: AppSpacing.paddingSm,
              decoration: BoxDecoration(
                color: theme.colorScheme.secondary,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.person_rounded, size: 20, color: theme.colorScheme.onSecondary),
            ),
          ],
        ],
      ),
    );
  }
}
