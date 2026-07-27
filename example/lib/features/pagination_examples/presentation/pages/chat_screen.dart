import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart'
    show HapticFeedback, Clipboard, ClipboardData;
import 'package:intl/intl.dart' show DateFormat;
import 'package:super_core/super_core.dart';
import 'package:super_pagination/super_pagination.dart';
import 'package:tooltip_card/tooltip_card.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:super_pagination_example/shared/domain/entities/message.dart';

/// A GeniusLink-styled chat example demonstrating reverse pagination and
/// programmatic navigation without bypassing the shared design system.
class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) => const _ChatControllerScope();
}

class _ChatControllerScope extends StatefulWidget {
  const _ChatControllerScope();

  @override
  State<_ChatControllerScope> createState() => _ChatControllerScopeState();
}

class _ChatControllerScopeState extends State<_ChatControllerScope> {
  late final _ChatScreenController _controller;

  @override
  void initState() {
    super.initState();
    _controller = _ChatScreenController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _ChatScreenView(controller: _controller);
  }
}

const Object _notSet = Object();

class _ChatUiState {
  const _ChatUiState({
    this.highlightedIndex,
    this.isSearching = false,
    this.showScrollToBottom = false,
    this.isTyping = false,
    this.unreadCount = 0,
  });

  final int? highlightedIndex;
  final bool isSearching;
  final bool showScrollToBottom;
  final bool isTyping;
  final int unreadCount;

  _ChatUiState copyWith({
    Object? highlightedIndex = _notSet,
    bool? isSearching,
    bool? showScrollToBottom,
    bool? isTyping,
    int? unreadCount,
  }) {
    return _ChatUiState(
      highlightedIndex: identical(highlightedIndex, _notSet)
          ? this.highlightedIndex
          : highlightedIndex as int?,
      isSearching: isSearching ?? this.isSearching,
      showScrollToBottom: showScrollToBottom ?? this.showScrollToBottom,
      isTyping: isTyping ?? this.isTyping,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }
}

class _ChatScreenController {
  _ChatScreenController() {
    scrollController.addListener(_onScroll);

    // Observer is now built-in! No need to create ListObserverController manually.
    // SuperPagination will automatically attach it to the cubit.
    cubit = SuperPaginationCubit<Message, SuperPaginationRequest>(
      request: const SuperPaginationRequest(page: 1, pageSize: 30),
      provider: SuperPaginationProvider.future(_fetchMessages),
    );

    // Simulate typing indicator
    _simulateTyping();
  }

  late final SuperPaginationCubit<Message, SuperPaginationRequest> cubit;
  final ScrollController scrollController = ScrollController();

  final TextEditingController messageController = TextEditingController();
  final TextEditingController searchController = TextEditingController();
  final FocusNode messageFocusNode = FocusNode();
  final ValueNotifier<_ChatUiState> uiState =
      ValueNotifier<_ChatUiState>(const _ChatUiState());

  static const String _currentUser = 'أنت';
  static const String _otherUser = 'أحمد محمد';

  final Map<String, _MessageAttachment> messageAttachments =
      <String, _MessageAttachment>{};

  bool _disposed = false;
  final Set<Timer> _timers = <Timer>{};

  void _schedule(Duration delay, VoidCallback callback) {
    late final Timer timer;
    timer = Timer(delay, () {
      _timers.remove(timer);
      if (!_disposed) callback();
    });
    _timers.add(timer);
  }

  void _updateUiState(_ChatUiState Function(_ChatUiState current) update) {
    if (_disposed) return;
    uiState.value = update(uiState.value);
  }

  void _onScroll() {
    final showButton =
        scrollController.hasClients && scrollController.offset > 200;

    if (showButton != uiState.value.showScrollToBottom) {
      _updateUiState(
        (current) => current.copyWith(showScrollToBottom: showButton),
      );
    }
  }

  void _simulateTyping() {
    _schedule(const Duration(seconds: 5), () {
      _updateUiState((current) => current.copyWith(isTyping: true));
      _schedule(const Duration(seconds: 2), () {
        _updateUiState((current) => current.copyWith(isTyping: false));
      });
    });
  }

  Future<List<Message>> _fetchMessages(SuperPaginationRequest request) async {
    await Future.delayed(const Duration(milliseconds: 800));
    if (_disposed) return <Message>[];

    final messages = <Message>[];
    final now = DateTime.now();

    // Create realistic chat messages
    final sampleConversation = _getSampleConversation();

    for (int i = 0; i < (request.pageSize ?? 20); i++) {
      final index = ((request.page - 1) * (request.pageSize ?? 20)) + i;
      if (index >= sampleConversation.length * 3) break;

      final messageData = sampleConversation[index % sampleConversation.length];
      final isCurrentUser = messageData.isMe;
      final messageId = 'msg_${request.page}_$index';

      if (messageData.attachment != null) {
        messageAttachments[messageId] = messageData.attachment!;
      } else {
        messageAttachments.remove(messageId);
      }

      // Create timestamps going backwards in time
      final timestamp = now.subtract(Duration(
        minutes: index * 3 + (index ~/ 5) * 30, // Add gaps for realism
      ));

      messages.add(Message(
        id: messageId,
        content: messageData.text,
        author: isCurrentUser ? _currentUser : _otherUser,
        timestamp: timestamp,
        isRead: index > 5, // Recent messages are unread
      ));
    }

    // Update unread count
    _updateUiState(
      (current) => current.copyWith(
        unreadCount: messages.where((m) => !m.isRead).length,
      ),
    );

    return messages;
  }

  List<_SampleConversationMessage> _getSampleConversation() {
    return const [
      _SampleConversationMessage(
        text: 'مرحباً! كيف حالك اليوم؟ 👋',
        isMe: false,
      ),
      _SampleConversationMessage(
        text: 'أهلاً أحمد! الحمد لله بخير، وأنت؟',
        isMe: true,
      ),
      _SampleConversationMessage(
        text: 'media image: أرسلت لك صورة حقيقية للمعاينة',
        isMe: false,
        attachment: _MessageAttachment(
          type: _MessageAttachmentType.image,
          title: 'صورة حقيقية',
          subtitle: 'JPEG • 18 KB',
          caption: 'هذه رسالة media تحتوي صورة حقيقية.',
          mediaUrl:
              'https://interactive-examples.mdn.mozilla.net/media/cc0-images/grapefruit-slice-332-332.jpg',
          icon: Icons.image,
          color: Color(0xFF0B8F8A),
        ),
      ),
      _SampleConversationMessage(
        text: 'media video: هذا فيديو حقيقي قابل للتشغيل',
        isMe: true,
        attachment: _MessageAttachment(
          type: _MessageAttachmentType.video,
          title: 'فيديو الزهرة',
          subtitle: 'MP4 • 1.1 MB',
          caption: 'هذه رسالة media تحتوي ملف فيديو حقيقي.',
          mediaUrl:
              'https://interactive-examples.mdn.mozilla.net/media/cc0-videos/flower.mp4',
          icon: Icons.play_arrow_rounded,
          color: Color(0xFF3A86FF),
          actionLabel: 'تشغيل الفيديو',
          duration: '0:05',
        ),
      ),
      _SampleConversationMessage(
        text: 'media audio: هذا مقطع صوتي حقيقي',
        isMe: false,
        attachment: _MessageAttachment(
          type: _MessageAttachmentType.audio,
          title: 'مقطع صوتي',
          subtitle: 'MP3 • 39 KB',
          caption: 'هذه رسالة media تحتوي ملف صوت حقيقي.',
          mediaUrl:
              'https://interactive-examples.mdn.mozilla.net/media/cc0-audio/t-rex-roar.mp3',
          icon: Icons.graphic_eq,
          color: Color(0xFF118AB2),
          actionLabel: 'تشغيل الصوت',
          duration: '0:01',
        ),
      ),
      _SampleConversationMessage(
        text: 'الحمد لله، هل انتهيت من المشروع؟',
        isMe: false,
      ),
      _SampleConversationMessage(
        text: 'نعم، أنهيته البارحة وأرسلته للمراجعة ✅',
        isMe: true,
      ),
      _SampleConversationMessage(
        text: 'location: هذا موقع الاجتماع الرئيسي',
        isMe: true,
        attachment: _MessageAttachment(
          type: _MessageAttachmentType.location,
          title: 'موقع الاجتماع',
          subtitle: 'الرياض - حي الملقا',
          caption: '24.7743, 46.7386',
          icon: Icons.location_on,
          color: Color(0xFFE76F51),
          actionLabel: 'عرض الموقع',
        ),
      ),
      _SampleConversationMessage(
        text: 'ممتاز! عمل رائع 👏',
        isMe: false,
      ),
      _SampleConversationMessage(
        text: 'contact: أرسل لك جهة اتصال خالد من فريق الدعم',
        isMe: false,
        attachment: _MessageAttachment(
          type: _MessageAttachmentType.contact,
          title: 'خالد الدعم الفني',
          subtitle: '+966 55 123 4567',
          caption: 'فريق تجربة العملاء',
          icon: Icons.person,
          color: Color(0xFF2A9D8F),
        ),
      ),
      _SampleConversationMessage(
        text: 'شكراً لك! هل لديك أي ملاحظات؟',
        isMe: true,
      ),
      _SampleConversationMessage(
        text: 'سأراجعه اليوم وأخبرك',
        isMe: false,
      ),
      _SampleConversationMessage(
        text: 'تمام، في انتظارك',
        isMe: true,
      ),
      _SampleConversationMessage(
        text: 'poll: ما الوقت الأنسب للاجتماع القادم؟',
        isMe: false,
        attachment: _MessageAttachment(
          type: _MessageAttachmentType.poll,
          title: 'ما الوقت الأنسب للاجتماع القادم؟',
          subtitle: '12 صوتاً',
          caption: 'استطلاع تجريبي لرسائل poll.',
          icon: Icons.poll,
          color: Color(0xFF6A4C93),
          pollOptions: [
            _PollOption(label: '10:00 صباحاً', votes: 5),
            _PollOption(label: '1:00 ظهراً', votes: 3),
            _PollOption(label: '3:00 مساءً', votes: 4),
          ],
        ),
      ),
      _SampleConversationMessage(
        text: 'بالمناسبة، الاجتماع تأجل للساعة 3 مساءً',
        isMe: false,
      ),
      _SampleConversationMessage(
        text: 'حسناً، سأكون جاهزاً 📅',
        isMe: true,
      ),
      _SampleConversationMessage(
        text: 'هل تحتاج مساعدة في التحضير؟',
        isMe: false,
      ),
      _SampleConversationMessage(
        text: 'نعم، أرسل لي العرض التقديمي من فضلك',
        isMe: true,
      ),
      _SampleConversationMessage(
        text: 'تم الإرسال على البريد 📧',
        isMe: false,
      ),
      _SampleConversationMessage(
        text: 'وصل، شكراً جزيلاً!',
        isMe: true,
      ),
      _SampleConversationMessage(
        text: 'عفواً! نتواصل لاحقاً',
        isMe: false,
      ),
      _SampleConversationMessage(
        text: 'إن شاء الله، أراك في الاجتماع',
        isMe: true,
      ),
      _SampleConversationMessage(
        text: 'هل رأيت التحديثات الجديدة في النظام؟',
        isMe: false,
      ),
      _SampleConversationMessage(
        text: 'لا بعد، ما الجديد؟',
        isMe: true,
      ),
      _SampleConversationMessage(
        text: 'أضافوا ميزة البحث المتقدم 🔍',
        isMe: false,
      ),
      _SampleConversationMessage(
        text: 'رائع! سأجربها الآن',
        isMe: true,
      ),
    ];
  }

  void dispose() {
    _disposed = true;
    for (final timer in _timers) {
      timer.cancel();
    }
    _timers.clear();
    scrollController.removeListener(_onScroll);
    // No need to detach observer - it's handled automatically by SuperPagination
    cubit.close();
    scrollController.dispose();
    messageController.dispose();
    searchController.dispose();
    messageFocusNode.dispose();
    uiState.dispose();
  }

  void sendMessage() {
    final text = messageController.text.trim();
    if (text.isEmpty) {
      messageFocusNode.requestFocus();
      return;
    }

    final newMessage = Message(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
      content: text,
      author: _currentUser,
      timestamp: DateTime.now(),
      isRead: true,
    );

    cubit.insertEmit(newMessage, index: 0);
    messageController.clear();
    messageFocusNode.requestFocus();

    // Haptic feedback
    HapticFeedback.lightImpact();

    // Scroll to bottom (index 0 in reverse list)
    _schedule(const Duration(milliseconds: 100), () {
      scrollToNewest();
      messageFocusNode.requestFocus();
    });

    // Simulate reply
    _simulateReply();
  }

  void _simulateReply() {
    _schedule(const Duration(seconds: 2), () {
      _updateUiState((current) => current.copyWith(isTyping: true));

      _schedule(const Duration(seconds: 2), () {
        _updateUiState((current) => current.copyWith(isTyping: false));

        final replies = [
          'تمام 👍',
          'حسناً، فهمت',
          'شكراً للتوضيح',
          'سأتحقق من ذلك',
          'ممتاز!',
        ];

        final reply = Message(
          id: 'msg_reply_${DateTime.now().millisecondsSinceEpoch}',
          content: replies[DateTime.now().second % replies.length],
          author: _otherUser,
          timestamp: DateTime.now(),
          isRead: false,
        );

        cubit.insertEmit(reply, index: 0);
        _updateUiState(
          (current) => current.copyWith(unreadCount: current.unreadCount + 1),
        );
      });
    });
  }

  void scrollToNewest() {
    final success = cubit.jumpToIndex(0);

    if (success) {
      _updateUiState((current) => current.copyWith(unreadCount: 0));
    }
  }

  void scrollToOldest() {
    final items = cubit.currentItems;
    if (items.isEmpty) return;

    cubit.jumpToIndex(items.length - 1);
  }

  void jumpToUnread(BuildContext context) {
    final success = cubit.jumpFirstWhere(
      (message) => !message.isRead,
      alignment: 0.3,
    );

    if (!_disposed) {
      showSnackBar(
        context,
        success
            ? 'تم العثور على أول رسالة غير مقروءة'
            : 'لا توجد رسائل غير مقروءة',
        success ? SuperThemeData.of(context).tokens.success : SuperThemeData.of(context).tokens.warning,
      );
    }
  }

  void searchAndScroll(BuildContext context, String query) {
    if (query.isEmpty) return;

    final success = cubit.jumpFirstWhere(
      (message) => message.content.toLowerCase().contains(query.toLowerCase()),
      alignment: 0.3,
    );

    final items = cubit.currentItems;
    final index = items.indexWhere(
      (m) => m.content.toLowerCase().contains(query.toLowerCase()),
    );

    _updateUiState(
      (current) => current.copyWith(highlightedIndex: success ? index : null),
    );

    if (!_disposed) {
      showSnackBar(
        context,
        success
            ? 'تم العثور على الرسالة رقم ${index + 1}'
            : 'لم يتم العثور على "$query"',
        success ? SuperThemeData.of(context).tokens.success : SuperThemeData.of(context).tokens.warning,
      );
    }

    if (success) {
      Future.delayed(const Duration(seconds: 3), () {
        if (_disposed) return;
        _updateUiState(
          (current) => current.copyWith(highlightedIndex: null),
        );
      });
    }
  }

  void jumpToIndex(BuildContext context, int index) {
    final success = cubit.jumpToIndex(index, alignment: 0.3);

    if (!_disposed) {
      showSnackBar(
        context,
        success
            ? 'تم الانتقال للرسالة #${index + 1}'
            : 'لا يمكن الانتقال للرسالة #${index + 1}',
        success ? SuperThemeData.of(context).tokens.accent : SuperThemeData.of(context).tokens.danger,
      );
    }
  }

  void setSearching(bool isSearching) {
    if (!isSearching) {
      searchController.clear();
    }

    _updateUiState(
      (current) => current.copyWith(
        isSearching: isSearching,
        highlightedIndex: isSearching ? current.highlightedIndex : null,
      ),
    );
  }

  void toggleSearch() {
    setSearching(!uiState.value.isSearching);
  }

  void handleMenuAction(BuildContext context, String value) {
    switch (value) {
      case 'top':
        scrollToOldest();
        break;
      case 'bottom':
        scrollToNewest();
        break;
      case 'unread':
        jumpToUnread(context);
        break;
      case 'middle':
        final items = cubit.currentItems;
        if (items.isNotEmpty) {
          jumpToIndex(context, items.length ~/ 2);
        }
        break;
    }
  }

  void showSnackBar(BuildContext context, String message, Color color) {
    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger == null) return;

    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        content: Text(message, textAlign: TextAlign.center),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(SuperThemeData.of(context).spacing.radiusMd),
        ),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

class _ChatScreenView extends StatelessWidget {
  const _ChatScreenView({required this.controller});

  final _ChatScreenController controller;

  @override
  Widget build(BuildContext context) {
    final t = SuperThemeData.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ValueListenableBuilder<_ChatUiState>(
      valueListenable: controller.uiState,
      builder: (context, uiState, _) {
        return Scaffold(
          backgroundColor: t.bg,
          appBar: _buildAppBar(context, uiState),
          body: ColoredBox(
            color: t.bg,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1180),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: t.surface,
                    border: BorderDirectional(
                      start: BorderSide(color: t.border),
                      end: BorderSide(color: t.border),
                    ),
                  ),
                  child: Column(
                    children: [
                      _buildNavigationToolbar(context),
                      Expanded(
                        child: Stack(
                          children: [
                            Positioned.fill(child: _ConversationBackdrop(theme: t)),
                            SuperPagination<Message,
                                SuperPaginationRequest>.listViewWithCubit(
                              cubit: controller.cubit,
                              scrollController: controller.scrollController,
                              physics: const BouncingScrollPhysics(),
                              reverse: true,
                              padding: EdgeInsets.fromLTRB(
                                t.spacing.md,
                                t.spacing.lg,
                                t.spacing.md,
                                t.spacing.xl,
                              ),
                              itemBuilder: (context, items, index) {
                                final message = items[index];
                                final isHighlighted =
                                    uiState.highlightedIndex == index;
                                final showDateSeparator =
                                    _shouldShowDateSeparator(items, index);

                                return Column(
                                  children: [
                                    if (showDateSeparator)
                                      _DateSeparator(date: message.timestamp),
                                    _MessageBubble(
                                      message: message,
                                      attachment: controller
                                          .messageAttachments[message.id],
                                      isCurrentUser: message.author ==
                                          _ChatScreenController._currentUser,
                                      isHighlighted: isHighlighted,
                                      index: index,
                                      isDark: isDark,
                                      onLongPress: () => _showMessageOptions(
                                        context,
                                        message,
                                        index,
                                      ),
                                    ),
                                  ],
                                );
                              },
                              firstPageLoadingBuilder: (context) =>
                                  _buildStateCard(
                                context,
                                icon: Icons.forum_outlined,
                                title: 'جاري تحميل المحادثة',
                                description:
                                    'يتم الآن جلب الرسائل مع الحفاظ على موضع التمرير.',
                                loading: true,
                              ),
                              firstPageErrorBuilder: (context, error, retry) =>
                                  _buildStateCard(
                                context,
                                icon: Icons.cloud_off_outlined,
                                title: 'تعذر تحميل الرسائل',
                                description:
                                    'تحقق من الاتصال ثم أعد محاولة تحميل المحادثة.',
                                tone: SuperThemeData.of(context).tokens.danger,
                                action: FilledButton.icon(
                                  onPressed: retry,
                                  icon: const Icon(Icons.refresh_rounded),
                                  label: const Text('إعادة المحاولة'),
                                ),
                              ),
                              firstPageEmptyBuilder: (context) =>
                                  _buildStateCard(
                                context,
                                icon: Icons.chat_bubble_outline_rounded,
                                title: 'لا توجد رسائل بعد',
                                description:
                                    'ابدأ المحادثة من حقل الكتابة في الأسفل.',
                              ),
                              loadMoreLoadingBuilder: (context) => Padding(
                                padding: EdgeInsets.all(t.spacing.lg),
                                child: const Center(
                                  child: SizedBox(
                                    width: 22,
                                    height: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            if (uiState.isTyping)
                              PositionedDirectional(
                                bottom: t.spacing.sm,
                                start: t.spacing.md,
                                child: const _TypingIndicator(),
                              ),
                          ],
                        ),
                      ),
                      _buildMessageInput(context),
                    ],
                  ),
                ),
              ),
            ),
          ),
          floatingActionButton: _buildScrollToBottomFab(context, uiState),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    _ChatUiState uiState,
  ) {
    final t = SuperThemeData.of(context);
    final primary = Theme.of(context).colorScheme.primary;

    return AppBar(
      toolbarHeight: 72,
      backgroundColor: t.surface,
      foregroundColor: t.fg1,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      titleSpacing: t.spacing.sm,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Divider(height: 1, thickness: 1, color: t.border),
      ),
      title: uiState.isSearching
          ? Container(
              height: 42,
              decoration: BoxDecoration(
                color: t.inputBg,
                borderRadius: BorderRadius.circular(SuperThemeData.of(context).spacing.radiusMd),
                border: Border.all(color: t.border),
              ),
              child: TextField(
                controller: controller.searchController,
                autofocus: true,
                style: t.textTheme.body.copyWith(color: t.fg1),
                decoration: InputDecoration(
                  hintText: 'ابحث في الرسائل…',
                  hintStyle: t.textTheme.body.copyWith(color: t.fg4),
                  prefixIcon: Icon(Icons.search_rounded, color: t.fg3),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                ),
                onSubmitted: (query) {
                  controller.searchAndScroll(context, query);
                  controller.setSearching(false);
                },
              ),
            )
          : TooltipCard.builder(
              beakEnabled: true,
              placementSide: TooltipCardPlacementSide.bottom,
              whenContentVisible: WhenContentVisible.pressButton,
              builder: (tooltipContext, close) =>
                  _buildUserProfileTooltip(tooltipContext, close),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: t.tintFill(primary, 0.14),
                          borderRadius:
                              BorderRadius.circular(SuperThemeData.of(context).spacing.radiusMd),
                          border: Border.all(color: t.border),
                        ),
                        child: Icon(
                          Icons.person_outline_rounded,
                          color: primary,
                        ),
                      ),
                      PositionedDirectional(
                        end: -2,
                        bottom: -2,
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: t.tokens.success,
                            shape: BoxShape.circle,
                            border: Border.all(color: t.surface, width: 2),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: t.spacing.md),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _ChatScreenController._otherUser,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: t.textTheme.heading.copyWith(color: t.fg1),
                        ),
                        SizedBox(height: t.spacing.xs),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              uiState.isTyping
                                  ? Icons.more_horiz_rounded
                                  : Icons.circle,
                              size: uiState.isTyping ? 16 : 7,
                              color: t.tokens.success,
                            ),
                            SizedBox(width: t.spacing.xs),
                            Flexible(
                              child: Text(
                                uiState.isTyping ? 'يكتب الآن…' : 'متصل الآن',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: t.textTheme.caption.copyWith(color: t.fg3),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
      actions: [
        _HeaderIconButton(
          tooltip: uiState.isSearching ? 'إغلاق البحث' : 'بحث في المحادثة',
          icon: uiState.isSearching ? Icons.close_rounded : Icons.search_rounded,
          onPressed: controller.toggleSearch,
        ),
        PopupMenuButton<String>(
          tooltip: 'خيارات التنقل',
          color: t.surface,
          surfaceTintColor: Colors.transparent,
          icon: Icon(Icons.more_horiz_rounded, color: t.fg2),
          onSelected: (value) => controller.handleMenuAction(context, value),
          itemBuilder: (context) => const [
            PopupMenuItem(
              value: 'top',
              child: _MenuItem(
                icon: Icons.keyboard_double_arrow_up_rounded,
                label: 'أقدم الرسائل',
              ),
            ),
            PopupMenuItem(
              value: 'bottom',
              child: _MenuItem(
                icon: Icons.keyboard_double_arrow_down_rounded,
                label: 'أحدث الرسائل',
              ),
            ),
            PopupMenuItem(
              value: 'unread',
              child: _MenuItem(
                icon: Icons.mark_email_unread_outlined,
                label: 'غير المقروءة',
              ),
            ),
            PopupMenuItem(
              value: 'middle',
              child: _MenuItem(
                icon: Icons.vertical_align_center_rounded,
                label: 'منتصف المحادثة',
              ),
            ),
          ],
        ),
        SizedBox(width: t.spacing.sm),
      ],
    );
  }

  Widget _buildUserProfileTooltip(
    BuildContext context,
    VoidCallback close,
  ) {
    final t = SuperThemeData.of(context);
    final primary = Theme.of(context).colorScheme.primary;

    return Container(
      padding: EdgeInsets.all(t.spacing.lg),
      constraints: const BoxConstraints(maxWidth: 300),
      decoration: BoxDecoration(
        color: t.surface,
        borderRadius: BorderRadius.circular(SuperThemeData.of(context).spacing.radiusCard),
        border: Border.all(color: t.border),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: t.tintFill(primary, 0.14),
              borderRadius: BorderRadius.circular(SuperThemeData.of(context).spacing.radiusCard),
              border: Border.all(color: t.border),
            ),
            child: Icon(Icons.person_outline_rounded, size: 36, color: primary),
          ),
          SizedBox(height: t.spacing.md),
          Text(
            _ChatScreenController._otherUser,
            style: t.textTheme.heading.copyWith(color: t.fg1, fontSize: 20),
          ),
          SizedBox(height: t.spacing.xs),
          Text(
            '+966 50 XXX XXXX',
            style: t.textTheme.mono.copyWith(color: t.fg3),
          ),
          SizedBox(height: t.spacing.lg),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildProfileAction(context, Icons.call_outlined, 'اتصال'),
              _buildProfileAction(context, Icons.videocam_outlined, 'فيديو'),
              _buildProfileAction(context, Icons.info_outline_rounded, 'معلومات'),
            ],
          ),
          SizedBox(height: t.spacing.md),
          TextButton(onPressed: close, child: const Text('إغلاق')),
        ],
      ),
    );
  }

  Widget _buildProfileAction(
    BuildContext context,
    IconData icon,
    String label,
  ) {
    final t = SuperThemeData.of(context);
    final primary = Theme.of(context).colorScheme.primary;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: t.tintFill(primary, 0.1),
            borderRadius: BorderRadius.circular(SuperThemeData.of(context).spacing.radiusMd),
          ),
          child: IconButton(
            onPressed: () {},
            icon: Icon(icon, color: primary, size: 19),
          ),
        ),
        SizedBox(height: t.spacing.xs),
        Text(label, style: t.textTheme.caption.copyWith(color: t.fg3)),
      ],
    );
  }

  Widget _buildNavigationToolbar(BuildContext context) {
    final t = SuperThemeData.of(context);
    final primary = Theme.of(context).colorScheme.primary;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: t.spacing.md,
        vertical: t.spacing.sm,
      ),
      decoration: BoxDecoration(
        color: t.surface,
        border: Border(bottom: BorderSide(color: t.border)),
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: t.tintFill(primary, 0.1),
              borderRadius: BorderRadius.circular(SuperThemeData.of(context).spacing.radiusMd),
            ),
            child: Icon(Icons.near_me_outlined, color: primary, size: 18),
          ),
          SizedBox(width: t.spacing.sm),
          Text(
            'تنقل سريع',
            style: t.textTheme.label.copyWith(color: t.fg2),
          ),
          SizedBox(width: t.spacing.md),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _NavigationChip(
                    label: 'الأولى',
                    icon: Icons.looks_one_outlined,
                    onTap: () => controller.jumpToIndex(context, 0),
                    color: primary,
                  ),
                  _NavigationChip(
                    label: 'رقم 10',
                    icon: Icons.filter_1_outlined,
                    onTap: () => controller.jumpToIndex(context, 9),
                    color: t.tokens.success,
                  ),
                  _NavigationChip(
                    label: 'رقم 20',
                    icon: Icons.filter_2_outlined,
                    onTap: () => controller.jumpToIndex(context, 19),
                    color: t.tokens.warning,
                  ),
                  _NavigationChip(
                    label: 'المشروع',
                    icon: Icons.search_rounded,
                    onTap: () => controller.searchAndScroll(context, 'المشروع'),
                    color: primary,
                  ),
                  _NavigationChip(
                    label: 'الاجتماع',
                    icon: Icons.event_outlined,
                    onTap: () => controller.searchAndScroll(context, 'الاجتماع'),
                    color: t.tokens.warning,
                  ),
                  _NavigationChip(
                    label: 'وسائط',
                    icon: Icons.perm_media_outlined,
                    onTap: () => controller.searchAndScroll(context, 'media'),
                    color: t.tokens.accent,
                  ),
                  _NavigationChip(
                    label: 'موقع',
                    icon: Icons.location_on_outlined,
                    onTap: () => controller.searchAndScroll(context, 'location'),
                    color: t.tokens.danger,
                  ),
                  _NavigationChip(
                    label: 'جهة اتصال',
                    icon: Icons.person_add_alt_outlined,
                    onTap: () => controller.searchAndScroll(context, 'contact'),
                    color: t.tokens.success,
                  ),
                  _NavigationChip(
                    label: 'استطلاع',
                    icon: Icons.poll_outlined,
                    onTap: () => controller.searchAndScroll(context, 'poll'),
                    color: primary,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageInput(BuildContext context) {
    final t = SuperThemeData.of(context);
    final primary = Theme.of(context).colorScheme.primary;

    return Container(
      padding: EdgeInsets.fromLTRB(
        t.spacing.md,
        t.spacing.sm,
        t.spacing.md,
        t.spacing.md,
      ),
      decoration: BoxDecoration(
        color: t.surface,
        border: Border(top: BorderSide(color: t.border)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            _ComposerIconButton(
              tooltip: 'رموز تعبيرية',
              icon: Icons.emoji_emotions_outlined,
              onPressed: () {},
            ),
            SizedBox(width: t.spacing.sm),
            Expanded(
              child: Container(
                constraints: const BoxConstraints(minHeight: 46),
                decoration: BoxDecoration(
                  color: t.inputBg,
                  borderRadius: BorderRadius.circular(SuperThemeData.of(context).spacing.radiusCard),
                  border: Border.all(color: t.border),
                ),
                child: TextField(
                  controller: controller.messageController,
                  focusNode: controller.messageFocusNode,
                  textInputAction: TextInputAction.send,
                  textDirection: TextDirection.rtl,
                  minLines: 1,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: 'اكتب رسالة…',
                    hintStyle: t.textTheme.body.copyWith(color: t.fg4),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: t.spacing.md,
                      vertical: 12,
                    ),
                  ),
                  style: t.textTheme.body.copyWith(color: t.fg1),
                  onSubmitted: (_) => controller.sendMessage(),
                ),
              ),
            ),
            SizedBox(width: t.spacing.sm),
            _ComposerIconButton(
              tooltip: 'إرفاق ملف',
              icon: Icons.attach_file_rounded,
              onPressed: () {},
            ),
            SizedBox(width: t.spacing.sm),
            TooltipCard.builder(
              beakEnabled: true,
              placementSide: TooltipCardPlacementSide.top,
              whenContentVisible: WhenContentVisible.longPressButton,
              builder: (context, close) => Padding(
                padding: EdgeInsets.all(t.spacing.md),
                child: const Text(
                  'اضغط للإرسال\nاضغط مطولاً للتسجيل الصوتي',
                ),
              ),
              child: Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: primary,
                  borderRadius: BorderRadius.circular(SuperThemeData.of(context).spacing.radiusMd),
                ),
                child: IconButton(
                  tooltip: 'إرسال',
                  onPressed: controller.sendMessage,
                  icon: ValueListenableBuilder<TextEditingValue>(
                    valueListenable: controller.messageController,
                    builder: (context, value, _) => Icon(
                      value.text.trim().isEmpty
                          ? Icons.mic_none_rounded
                          : Icons.send_rounded,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget? _buildScrollToBottomFab(
    BuildContext context,
    _ChatUiState uiState,
  ) {
    if (!uiState.showScrollToBottom) return null;

    final t = SuperThemeData.of(context);
    final primary = Theme.of(context).colorScheme.primary;

    return Padding(
      padding: const EdgeInsets.only(bottom: 78),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          FloatingActionButton.small(
            heroTag: 'chat-scroll-newest',
            onPressed: controller.scrollToNewest,
            elevation: 0,
            backgroundColor: t.surface,
            foregroundColor: t.fg2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(SuperThemeData.of(context).spacing.radiusMd),
              side: BorderSide(color: t.border),
            ),
            child: const Icon(Icons.keyboard_double_arrow_down_rounded),
          ),
          if (uiState.unreadCount > 0)
            PositionedDirectional(
              end: -5,
              top: -5,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                decoration: BoxDecoration(
                  color: primary,
                  borderRadius: BorderRadius.circular(SuperThemeData.of(context).spacing.radiusPill),
                  border: Border.all(color: t.surface, width: 2),
                ),
                constraints: const BoxConstraints(minWidth: 20, minHeight: 20),
                child: Text(
                  '${uiState.unreadCount}',
                  style: t.textTheme.mono.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStateCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    Color? tone,
    bool loading = false,
    Widget? action,
  }) {
    final t = SuperThemeData.of(context);
    final color = tone ?? Theme.of(context).colorScheme.primary;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(t.spacing.xl),
        child: SuperSectionCard(
          child: Padding(
            padding: EdgeInsets.all(t.spacing.xl),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: t.tintFill(color, 0.12),
                    borderRadius: BorderRadius.circular(SuperThemeData.of(context).spacing.radiusCard),
                  ),
                  child: loading
                      ? Padding(
                          padding: const EdgeInsets.all(16),
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: color,
                          ),
                        )
                      : Icon(icon, color: color, size: 26),
                ),
                SizedBox(height: t.spacing.lg),
                Text(title, style: t.textTheme.heading.copyWith(color: t.fg1)),
                SizedBox(height: t.spacing.sm),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 360),
                  child: Text(
                    description,
                    textAlign: TextAlign.center,
                    style: t.textTheme.body.copyWith(color: t.fg3),
                  ),
                ),
                if (action != null) ...[
                  SizedBox(height: t.spacing.lg),
                  action,
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool _shouldShowDateSeparator(List<Message> items, int index) {
    if (index == items.length - 1) return true;
    final currentDate = DateUtils.dateOnly(items[index].timestamp);
    final nextDate = DateUtils.dateOnly(items[index + 1].timestamp);
    return currentDate != nextDate;
  }

  void _showMessageOptions(BuildContext context, Message message, int index) {
    HapticFeedback.mediumImpact();
    final t = SuperThemeData.of(context);
    final hostContext = context;

    showModalBottomSheet(
      context: hostContext,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (sheetContext) => SafeArea(
        child: Container(
          decoration: BoxDecoration(
            color: t.surface,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(t.spacing.radiusCard),
            ),
            border: Border(top: BorderSide(color: t.border)),
          ),
          padding: EdgeInsets.all(t.spacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 42,
                height: 4,
                decoration: BoxDecoration(
                  color: t.borderStrong,
                  borderRadius: BorderRadius.circular(SuperThemeData.of(context).spacing.radiusPill),
                ),
              ),
              SizedBox(height: t.spacing.lg),
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  'إجراءات الرسالة',
                  style: t.textTheme.heading.copyWith(color: t.fg1),
                ),
              ),
              SizedBox(height: t.spacing.md),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(t.spacing.md),
                decoration: BoxDecoration(
                  color: t.inputBg,
                  borderRadius: BorderRadius.circular(SuperThemeData.of(context).spacing.radiusMd),
                  border: Border.all(color: t.border),
                ),
                child: Text(
                  message.content,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  textDirection: TextDirection.rtl,
                  style: t.textTheme.body.copyWith(color: t.fg2),
                ),
              ),
              SizedBox(height: t.spacing.lg),
              Wrap(
                spacing: t.spacing.sm,
                runSpacing: t.spacing.sm,
                children: [
                  _MessageActionChip(
                    icon: Icons.content_copy_rounded,
                    label: 'نسخ',
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: message.content));
                      Navigator.pop(sheetContext);
                      controller.showSnackBar(
                        hostContext,
                        'تم النسخ',
                        t.tokens.success,
                      );
                    },
                  ),
                  _MessageActionChip(
                    icon: Icons.reply_rounded,
                    label: 'رد',
                    onTap: () => Navigator.pop(sheetContext),
                  ),
                  _MessageActionChip(
                    icon: Icons.forward_rounded,
                    label: 'تحويل',
                    onTap: () => Navigator.pop(sheetContext),
                  ),
                  _MessageActionChip(
                    icon: Icons.star_border_rounded,
                    label: 'تمييز',
                    onTap: () => Navigator.pop(sheetContext),
                  ),
                  _MessageActionChip(
                    icon: Icons.center_focus_strong_rounded,
                    label: 'انتقال',
                    onTap: () {
                      Navigator.pop(sheetContext);
                      controller.cubit.jumpToIndex(index, alignment: 0.3);
                    },
                  ),
                  _MessageActionChip(
                    icon: Icons.delete_outline_rounded,
                    label: 'حذف',
                    color: t.tokens.danger,
                    onTap: () => Navigator.pop(sheetContext),
                  ),
                ],
              ),
              SizedBox(height: t.spacing.sm),
            ],
          ),
        ),
      ),
    );
  }
}


class _ConversationBackdrop extends StatelessWidget {
  const _ConversationBackdrop({required this.theme});

  final SuperThemeData theme;

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.bg,
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            theme.tintFill(primary, 0.035),
            theme.bg,
            theme.bg,
          ],
          stops: const [0, 0.28, 1],
        ),
      ),
    );
  }
}

class _HeaderIconButton extends StatelessWidget {
  const _HeaderIconButton({
    required this.tooltip,
    required this.icon,
    required this.onPressed,
  });

  final String tooltip;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final t = SuperThemeData.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: IconButton(
        tooltip: tooltip,
        onPressed: onPressed,
        icon: Icon(icon, color: t.fg2),
        style: IconButton.styleFrom(
          backgroundColor: t.inputBg,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(SuperThemeData.of(context).spacing.radiusMd),
            side: BorderSide(color: t.border),
          ),
        ),
      ),
    );
  }
}

class _ComposerIconButton extends StatelessWidget {
  const _ComposerIconButton({
    required this.tooltip,
    required this.icon,
    required this.onPressed,
  });

  final String tooltip;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final t = SuperThemeData.of(context);
    return SizedBox(
      width: 42,
      height: 42,
      child: IconButton(
        tooltip: tooltip,
        onPressed: onPressed,
        icon: Icon(icon, color: t.fg3, size: 20),
        style: IconButton.styleFrom(
          backgroundColor: t.inputBg,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(SuperThemeData.of(context).spacing.radiusMd),
            side: BorderSide(color: t.border),
          ),
        ),
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  const _MenuItem({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final t = SuperThemeData.of(context);
    return Row(
      children: [
        Icon(icon, size: 19, color: t.fg3),
        SizedBox(width: t.spacing.sm),
        Text(label, style: t.textTheme.body.copyWith(color: t.fg2)),
      ],
    );
  }
}

// ============= Helper Widgets =============

class _DateSeparator extends StatelessWidget {
  const _DateSeparator({required this.date});

  final DateTime date;

  @override
  Widget build(BuildContext context) {
    final t = SuperThemeData.of(context);
    final now = DateTime.now();
    final today = DateUtils.dateOnly(now);
    final yesterday = today.subtract(const Duration(days: 1));
    final messageDate = DateUtils.dateOnly(date);

    final dateText = messageDate == today
        ? 'اليوم'
        : messageDate == yesterday
            ? 'أمس'
            : DateFormat('d MMMM yyyy', 'ar').format(date);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: t.spacing.lg),
      child: Row(
        children: [
          Expanded(child: Divider(color: t.border)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: t.spacing.md),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: t.spacing.md,
                vertical: t.spacing.xs,
              ),
              decoration: BoxDecoration(
                color: t.surface,
                borderRadius: BorderRadius.circular(SuperThemeData.of(context).spacing.radiusPill),
                border: Border.all(color: t.border),
              ),
              child: Text(
                dateText,
                style: t.textTheme.caption.copyWith(color: t.fg3),
              ),
            ),
          ),
          Expanded(child: Divider(color: t.border)),
        ],
      ),
    );
  }
}

class _TypingIndicator extends StatelessWidget {
  const _TypingIndicator();

  @override
  Widget build(BuildContext context) {
    final t = SuperThemeData.of(context);
    final primary = Theme.of(context).colorScheme.primary;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: t.spacing.md,
        vertical: t.spacing.sm,
      ),
      decoration: BoxDecoration(
        color: t.surface,
        borderRadius: BorderRadius.circular(SuperThemeData.of(context).spacing.radiusCard),
        border: Border.all(color: t.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var index = 0; index < 3; index++)
            Container(
              width: 7,
              height: 7,
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                color: primary.withValues(alpha: 0.55 + index * 0.18),
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
    );
  }
}

class _NavigationChip extends StatelessWidget {
  const _NavigationChip({
    required this.label,
    required this.icon,
    required this.onTap,
    required this.color,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final t = SuperThemeData.of(context);
    return Padding(
      padding: EdgeInsetsDirectional.only(end: t.spacing.sm),
      child: TooltipCard.builder(
        beakEnabled: true,
        placementSide: TooltipCardPlacementSide.bottom,
        whenContentVisible: WhenContentVisible.hoverButton,
        builder: (context, close) => Padding(
          padding: EdgeInsets.all(t.spacing.sm),
          child: Text('انتقل إلى: $label'),
        ),
        child: ActionChip(
          avatar: Icon(icon, size: 16, color: color),
          label: Text(label, style: t.textTheme.caption.copyWith(color: color)),
          onPressed: onTap,
          backgroundColor: t.tintFill(color, 0.1),
          side: BorderSide(color: t.tintFill(color, 0.28)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(SuperThemeData.of(context).spacing.radiusPill),
          ),
          padding: EdgeInsets.symmetric(horizontal: t.spacing.xs),
        ),
      ),
    );
  }
}

class _MessageActionChip extends StatelessWidget {
  const _MessageActionChip({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final t = SuperThemeData.of(context);
    final chipColor = color ?? t.fg2;

    return ActionChip(
      avatar: Icon(icon, size: 17, color: chipColor),
      label: Text(label, style: t.textTheme.caption.copyWith(color: chipColor)),
      onPressed: onTap,
      backgroundColor: t.tintFill(chipColor, 0.08),
      side: BorderSide(color: t.border),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(SuperThemeData.of(context).spacing.radiusMd),
      ),
    );
  }
}

Future<void> _launchAttachmentUrl(BuildContext context, String? url) async {
  final uri = url == null ? null : Uri.tryParse(url);
  final messenger = ScaffoldMessenger.maybeOf(context);

  if (uri == null) {
    messenger?.showSnackBar(
      const SnackBar(content: Text('رابط الوسائط غير صالح')),
    );
    return;
  }

  final didLaunch = await launchUrl(uri, mode: LaunchMode.externalApplication);
  if (!didLaunch) {
    messenger?.showSnackBar(
      const SnackBar(content: Text('تعذر فتح ملف الوسائط')),
    );
  }
}

class _SampleConversationMessage {
  const _SampleConversationMessage({
    required this.text,
    required this.isMe,
    this.attachment,
  });

  final String text;
  final bool isMe;
  final _MessageAttachment? attachment;
}

enum _MessageAttachmentType { image, video, audio, location, contact, poll }

class _MessageAttachment {
  const _MessageAttachment({
    required this.type,
    required this.title,
    this.subtitle,
    this.caption,
    this.mediaUrl,
    this.icon = Icons.insert_drive_file,
    this.color = const Color(0xFF4A7CFF),
    this.actionLabel,
    this.duration,
    this.pollOptions = const [],
  });

  final _MessageAttachmentType type;
  final String title;
  final String? subtitle;
  final String? caption;
  final String? mediaUrl;
  final IconData icon;
  final Color color;
  final String? actionLabel;
  final String? duration;
  final List<_PollOption> pollOptions;
}

class _PollOption {
  const _PollOption({
    required this.label,
    required this.votes,
  });

  final String label;
  final int votes;
}

class _MessageAttachmentView extends StatelessWidget {
  const _MessageAttachmentView({
    required this.attachment,
    required this.textColor,
    required this.isDark,
  });

  final _MessageAttachment attachment;
  final Color textColor;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : MediaQuery.sizeOf(context).width * 0.75;
        final width = maxWidth < 180
            ? maxWidth
            : maxWidth > 260
                ? 260.0
                : maxWidth;

        return SizedBox(
          width: width,
          child: switch (attachment.type) {
            _MessageAttachmentType.image => _buildImageContent(context),
            _MessageAttachmentType.video => _buildVideoContent(context),
            _MessageAttachmentType.audio => _buildAudioContent(context),
            _MessageAttachmentType.location => _buildLocationContent(context),
            _MessageAttachmentType.contact => _buildContactContent(context),
            _MessageAttachmentType.poll => _buildPollContent(context),
          },
        );
      },
    );
  }

  Widget _buildImageContent(BuildContext context) {
    final t = SuperThemeData.of(context);
    final mutedColor = t.fg3;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(SuperThemeData.of(context).spacing.radiusMd),
          child: Stack(
            children: [
              Image.network(
                attachment.mediaUrl!,
                height: 170,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _buildMediaFallback(
                    context,
                    height: 170,
                    icon: Icons.broken_image_outlined,
                    label: 'تعذر تحميل الصورة',
                  );
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;

                  return _buildMediaFallback(
                    context,
                    height: 170,
                    icon: Icons.image_outlined,
                    label: 'جاري تحميل الصورة',
                    showProgress: true,
                  );
                },
              ),
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0),
                        Colors.black.withValues(alpha: 0.48),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: _AttachmentBadge(
                  icon: Icons.image_outlined,
                  label: attachment.subtitle ?? 'image',
                  isDark: isDark,
                ),
              ),
              Positioned(
                left: 12,
                right: 12,
                bottom: 12,
                child: Text(
                  attachment.title,
                  style: t.textTheme.label.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                  textDirection: TextDirection.rtl,
                ),
              ),
            ],
          ),
        ),
        if (attachment.caption != null) ...[
          const SizedBox(height: 8),
          Text(
            attachment.caption!,
            style: t.textTheme.caption.copyWith(color: mutedColor),
            textDirection: TextDirection.rtl,
          ),
        ],
      ],
    );
  }

  Widget _buildVideoContent(BuildContext context) {
    final t = SuperThemeData.of(context);
    final mutedColor = t.fg3;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => _launchAttachmentUrl(context, attachment.mediaUrl),
          child: Container(
            height: 150,
            decoration: BoxDecoration(
              color: attachment.color.withValues(alpha: isDark ? 0.24 : 0.12),
              borderRadius: BorderRadius.circular(SuperThemeData.of(context).spacing.radiusMd),
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(
                        4,
                        (index) => Row(
                          children: List.generate(
                            5,
                            (dotIndex) => Expanded(
                              child: Container(
                                height: 18,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 2),
                                decoration: BoxDecoration(
                                  color: attachment.color.withValues(
                                    alpha: index.isEven ? 0.18 : 0.11,
                                  ),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Center(
                  child: CircleAvatar(
                    radius: 30,
                    backgroundColor: attachment.color,
                    child: const Icon(
                      Icons.play_arrow_rounded,
                      color: Colors.white,
                      size: 38,
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: _AttachmentBadge(
                    icon: Icons.videocam_outlined,
                    label: attachment.duration ?? 'video',
                    isDark: isDark,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          attachment.title,
          style: t.textTheme.label.copyWith(
            color: textColor,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
          textDirection: TextDirection.rtl,
        ),
        if (attachment.subtitle != null) ...[
          const SizedBox(height: 2),
          Text(
            attachment.subtitle!,
            style: t.textTheme.caption.copyWith(color: mutedColor),
            textDirection: TextDirection.rtl,
          ),
        ],
        if (attachment.caption != null) ...[
          const SizedBox(height: 6),
          Text(
            attachment.caption!,
            style: t.textTheme.caption.copyWith(color: mutedColor),
            textDirection: TextDirection.rtl,
          ),
        ],
        if (attachment.actionLabel != null) ...[
          const SizedBox(height: 8),
          _InlineAction(
            icon: Icons.open_in_new,
            label: attachment.actionLabel!,
            color: attachment.color,
            onTap: () => _launchAttachmentUrl(context, attachment.mediaUrl),
          ),
        ],
      ],
    );
  }

  Widget _buildAudioContent(BuildContext context) {
    final t = SuperThemeData.of(context);
    final mutedColor = t.fg3;

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: SuperThemeData.of(context).inputBg,
        border: Border.all(color: SuperThemeData.of(context).border),
        borderRadius: BorderRadius.circular(SuperThemeData.of(context).spacing.radiusMd),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => _launchAttachmentUrl(context, attachment.mediaUrl),
                child: CircleAvatar(
                  radius: 22,
                  backgroundColor: attachment.color,
                  child: const Icon(Icons.play_arrow, color: Colors.white),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      attachment.title,
                      style: t.textTheme.label.copyWith(
                        color: textColor,
                        fontWeight: FontWeight.w700,
                      ),
                      textDirection: TextDirection.rtl,
                    ),
                    const SizedBox(height: 6),
                    _AudioWaveform(color: attachment.color, isDark: isDark),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                attachment.duration ?? '0:00',
                style: t.textTheme.caption.copyWith(
                  color: mutedColor,
                  fontSize: 11,
                ),
              ),
            ],
          ),
          if (attachment.subtitle != null) ...[
            const SizedBox(height: 8),
            Text(
              attachment.subtitle!,
              style: t.textTheme.caption.copyWith(color: mutedColor),
              textDirection: TextDirection.rtl,
            ),
          ],
          if (attachment.caption != null) ...[
            const SizedBox(height: 4),
            Text(
              attachment.caption!,
              style: t.textTheme.caption.copyWith(color: mutedColor),
              textDirection: TextDirection.rtl,
            ),
          ],
          if (attachment.actionLabel != null) ...[
            const SizedBox(height: 8),
            _InlineAction(
              icon: Icons.open_in_new,
              label: attachment.actionLabel!,
              color: attachment.color,
              onTap: () => _launchAttachmentUrl(context, attachment.mediaUrl),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMediaFallback(
    BuildContext context, {
    required double height,
    required IconData icon,
    required String label,
    bool showProgress = false,
  }) {
    final t = SuperThemeData.of(context);
    return Container(
      height: height,
      width: double.infinity,
      color: attachment.color.withValues(alpha: isDark ? 0.28 : 0.16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: attachment.color, size: 42),
          const SizedBox(height: 8),
          Text(
            label,
            style: t.textTheme.caption.copyWith(color: textColor),
            textDirection: TextDirection.rtl,
          ),
          if (showProgress) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: 80,
              child: LinearProgressIndicator(
                minHeight: 3,
                color: attachment.color,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLocationContent(BuildContext context) {
    final t = SuperThemeData.of(context);
    final mutedColor = t.fg3;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 120,
          decoration: BoxDecoration(
            color: attachment.color.withValues(alpha: isDark ? 0.24 : 0.12),
            borderRadius: BorderRadius.circular(SuperThemeData.of(context).spacing.radiusMd),
            border: Border.all(
              color: attachment.color.withValues(alpha: 0.28),
            ),
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(
                      4,
                      (index) => Container(
                        height: 2,
                        decoration: BoxDecoration(
                          color: attachment.color.withValues(alpha: 0.24),
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Center(
                child: CircleAvatar(
                  radius: 26,
                  backgroundColor: attachment.color,
                  child: const Icon(Icons.location_on, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          attachment.title,
          style: t.textTheme.label.copyWith(
            color: textColor,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
          textDirection: TextDirection.rtl,
        ),
        if (attachment.subtitle != null) ...[
          const SizedBox(height: 2),
          Text(
            attachment.subtitle!,
            style: t.textTheme.caption.copyWith(color: mutedColor),
            textDirection: TextDirection.rtl,
          ),
        ],
        if (attachment.caption != null) ...[
          const SizedBox(height: 6),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.my_location, size: 14, color: mutedColor),
              const SizedBox(width: 4),
              Text(
                attachment.caption!,
                style: t.textTheme.caption.copyWith(
                  color: mutedColor,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ],
        if (attachment.actionLabel != null) ...[
          const SizedBox(height: 8),
          _InlineAction(
            icon: Icons.map_outlined,
            label: attachment.actionLabel!,
            color: attachment.color,
            onTap: attachment.mediaUrl == null
                ? null
                : () => _launchAttachmentUrl(context, attachment.mediaUrl),
          ),
        ],
      ],
    );
  }

  Widget _buildContactContent(BuildContext context) {
    final t = SuperThemeData.of(context);
    final mutedColor = t.fg3;

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: SuperThemeData.of(context).inputBg,
        border: Border.all(color: SuperThemeData.of(context).border),
        borderRadius: BorderRadius.circular(SuperThemeData.of(context).spacing.radiusMd),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: attachment.color,
                child: Icon(attachment.icon, color: Colors.white),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      attachment.title,
                      style: t.textTheme.label.copyWith(
                        color: textColor,
                        fontWeight: FontWeight.w700,
                      ),
                      textDirection: TextDirection.rtl,
                    ),
                    if (attachment.subtitle != null)
                      Text(
                        attachment.subtitle!,
                        style: t.textTheme.caption.copyWith(color: mutedColor),
                      ),
                    if (attachment.caption != null)
                      Text(
                        attachment.caption!,
                        style: t.textTheme.caption.copyWith(
                          color: mutedColor,
                          fontSize: 11,
                        ),
                        textDirection: TextDirection.rtl,
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _InlineAction(
                  icon: Icons.chat_bubble_outline,
                  label: 'رسالة',
                  color: attachment.color,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _InlineAction(
                  icon: Icons.call,
                  label: 'اتصال',
                  color: attachment.color,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPollContent(BuildContext context) {
    final t = SuperThemeData.of(context);
    final totalVotes = attachment.pollOptions.fold<int>(
      0,
      (total, option) => total + option.votes,
    );
    final mutedColor = t.fg3;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(attachment.icon, color: attachment.color, size: 20),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                attachment.title,
                style: t.textTheme.label.copyWith(
                  color: textColor,
                  fontWeight: FontWeight.w700,
                ),
                textDirection: TextDirection.rtl,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ...attachment.pollOptions.map(
          (option) => _PollOptionTile(
            option: option,
            totalVotes: totalVotes,
            color: attachment.color,
            textColor: textColor,
            mutedColor: mutedColor,
            isDark: isDark,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          attachment.subtitle ?? '$totalVotes صوتاً',
          style: t.textTheme.caption.copyWith(
            color: mutedColor,
            fontSize: 11,
          ),
          textDirection: TextDirection.rtl,
        ),
        if (attachment.caption != null) ...[
          const SizedBox(height: 2),
          Text(
            attachment.caption!,
            style: t.textTheme.caption.copyWith(
              color: mutedColor,
              fontSize: 11,
            ),
            textDirection: TextDirection.rtl,
          ),
        ],
      ],
    );
  }
}

class _AttachmentBadge extends StatelessWidget {
  const _AttachmentBadge({
    required this.icon,
    required this.label,
    required this.isDark,
  });

  final IconData icon;
  final String label;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final t = SuperThemeData.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.52),
        borderRadius: BorderRadius.circular(t.spacing.radiusPill),
        border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox.shrink(),
          Icon(icon, size: 13, color: Colors.white),
          const SizedBox(width: 4),
          Text(
            label,
            style: t.textTheme.caption.copyWith(
              color: Colors.white,
              fontSize: 10.5,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _InlineAction extends StatelessWidget {
  const _InlineAction({
    required this.icon,
    required this.label,
    required this.color,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final t = SuperThemeData.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(SuperThemeData.of(context).spacing.radiusMd),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: t.spacing.sm,
          vertical: t.spacing.sm,
        ),
        decoration: BoxDecoration(
          color: t.tintFill(color, 0.1),
          borderRadius: BorderRadius.circular(SuperThemeData.of(context).spacing.radiusMd),
          border: Border.all(color: t.tintFill(color, 0.25)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 15, color: color),
            SizedBox(width: t.spacing.xs),
            Flexible(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: t.textTheme.caption.copyWith(
                  color: color,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AudioWaveform extends StatelessWidget {
  const _AudioWaveform({required this.color, required this.isDark});

  final Color color;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    const heights = <double>[10, 18, 14, 24, 16, 28, 12, 22, 15, 20, 11, 17];
    return Row(
      children: [
        for (final height in heights)
          Expanded(
            child: Align(
              alignment: Alignment.center,
              child: Container(
                height: height,
                margin: const EdgeInsets.symmetric(horizontal: 1.5),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: isDark ? 0.72 : 0.82),
                  borderRadius: BorderRadius.circular(SuperThemeData.of(context).spacing.radiusPill),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _PollOptionTile extends StatelessWidget {
  const _PollOptionTile({
    required this.option,
    required this.totalVotes,
    required this.color,
    required this.textColor,
    required this.mutedColor,
    required this.isDark,
  });

  final _PollOption option;
  final int totalVotes;
  final Color color;
  final Color textColor;
  final Color mutedColor;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final t = SuperThemeData.of(context);
    final percentage = totalVotes == 0 ? 0.0 : option.votes / totalVotes;

    return Padding(
      padding: EdgeInsets.only(bottom: t.spacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  option.label,
                  style: t.textTheme.caption.copyWith(color: textColor),
                  textDirection: TextDirection.rtl,
                ),
              ),
              Text(
                '${(percentage * 100).round()}%',
                style: t.textTheme.mono.copyWith(
                  color: mutedColor,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          SizedBox(height: t.spacing.xs),
          ClipRRect(
            borderRadius: BorderRadius.circular(SuperThemeData.of(context).spacing.radiusPill),
            child: LinearProgressIndicator(
              value: percentage,
              minHeight: 7,
              backgroundColor: t.border,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({
    required this.message,
    required this.attachment,
    required this.isCurrentUser,
    required this.isHighlighted,
    required this.index,
    required this.isDark,
    required this.onLongPress,
  });

  final Message message;
  final _MessageAttachment? attachment;
  final bool isCurrentUser;
  final bool isHighlighted;
  final int index;
  final bool isDark;
  final VoidCallback onLongPress;

  @override
  Widget build(BuildContext context) {
    final t = SuperThemeData.of(context);
    final primary = Theme.of(context).colorScheme.primary;
    final bubbleColor = isCurrentUser
        ? t.tintFill(primary, isDark ? 0.2 : 0.13)
        : t.surface;
    final bubbleBorder = isCurrentUser
        ? t.tintFill(primary, isDark ? 0.42 : 0.3)
        : t.border;

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxBubbleWidth = constraints.maxWidth < 620
            ? constraints.maxWidth * 0.84
            : constraints.maxWidth * 0.66;

        return Container(
          margin: EdgeInsetsDirectional.only(
            start: isCurrentUser ? 56 : 0,
            end: isCurrentUser ? 0 : 56,
            top: t.spacing.xs,
            bottom: t.spacing.xs,
          ),
          padding: isHighlighted ? const EdgeInsets.all(3) : EdgeInsets.zero,
          decoration: BoxDecoration(
            color: isHighlighted
                ? t.tintFill(t.tokens.warning, 0.28)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(SuperThemeData.of(context).spacing.radiusCard),
          ),
          child: GestureDetector(
            onLongPress: onLongPress,
            child: Align(
              alignment: isCurrentUser
                  ? AlignmentDirectional.centerEnd
                  : AlignmentDirectional.centerStart,
              child: Container(
                constraints: BoxConstraints(maxWidth: maxBubbleWidth),
                padding: EdgeInsets.all(t.spacing.md),
                decoration: BoxDecoration(
                  color: bubbleColor,
                  borderRadius: BorderRadiusDirectional.only(
                    topStart: Radius.circular(t.spacing.radiusCard),
                    topEnd: Radius.circular(t.spacing.radiusCard),
                    bottomStart: Radius.circular(
                      isCurrentUser
                          ? t.spacing.radiusCard
                          : t.spacing.radiusMd,
                    ),
                    bottomEnd: Radius.circular(
                      isCurrentUser
                          ? t.spacing.radiusMd
                          : t.spacing.radiusCard,
                    ),
                  ),
                  border: Border.all(color: bubbleBorder),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (attachment == null)
                      Text(
                        message.content,
                        style: t.textTheme.body.copyWith(color: t.fg1),
                        textDirection: TextDirection.rtl,
                      )
                    else
                      _MessageAttachmentView(
                        attachment: attachment!,
                        textColor: t.fg1,
                        isDark: isDark,
                      ),
                    SizedBox(height: t.spacing.xs),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          DateFormat('HH:mm').format(message.timestamp),
                          style: t.textTheme.mono.copyWith(
                            color: t.fg4,
                            fontSize: 10.5,
                          ),
                        ),
                        if (isCurrentUser) ...[
                          SizedBox(width: t.spacing.xs),
                          Icon(
                            message.isRead ? Icons.done_all_rounded : Icons.done,
                            size: 15,
                            color: message.isRead ? primary : t.fg4,
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
