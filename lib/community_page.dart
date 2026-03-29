import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'profile_view_screen.dart';
import 'forum_ekle_page.dart';
import 'widgets/bottom_nav_bar.dart';

class CommunityPage extends ConsumerStatefulWidget {
  const CommunityPage({super.key});

  @override
  ConsumerState<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends ConsumerState<CommunityPage> {
  int _selectedIndex = 2;

  final Color primaryColor = const Color.fromARGB(255, 63, 81, 181);
  final Color backgroundColor = const Color(0xFFF8F9FE);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: const Text(
          "Topluluk Forumu",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w800,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black87,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black87),
            onPressed: () {},
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfileViewScreen()),
              ),
              child: const CircleAvatar(
                radius: 16,
                backgroundColor: Colors.indigo,
                child: Icon(Icons.person, color: Colors.white, size: 18),
              ),
            ),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('forums')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return _buildEmptyState();
          }

          final docs = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              final String docId = docs[index].id;

              return ForumModernKart(data: data, docId: docId);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ForumEklePage()),
        ),
        backgroundColor: primaryColor,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text("Ekle", style: TextStyle(color: Colors.white)),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedIndex,
        onTap: (index) {},
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.forum_outlined, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          const Text(
            "Henüz tartışma yok.",
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
        ],
      ),
    );
  }
}

class ForumModernKart extends StatelessWidget {
  final Map<String, dynamic> data;
  final String docId;

  const ForumModernKart({required this.data, required this.docId, super.key});

  @override
  Widget build(BuildContext context) {
    final String userType = data['userType'] ?? "Öğrenci";
    final Color typeColor = userType == "Mezun"
        ? Colors.orange.shade700
        : Colors.blue.shade700;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildBadge(
                  data['category'] ?? "Genel",
                  Colors.indigo.withOpacity(0.1),
                  Colors.indigo,
                ),
                Text(
                  _formatTimestamp(data['timestamp'] as Timestamp?),
                  style: TextStyle(color: Colors.grey[400], fontSize: 11),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              data['title'] ?? "",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              data['description'] ?? "",
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 13,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                CircleAvatar(
                  radius: 11,
                  backgroundColor: typeColor.withOpacity(0.1),
                  child: Text(
                    userType[0].toUpperCase(),
                    style: TextStyle(
                      color: typeColor,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  data['author'] ?? "Anonim",
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(width: 8),
                _buildBadge(userType, typeColor.withOpacity(0.1), typeColor),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12.0),
              child: Divider(height: 1, thickness: 0.5),
            ),
            Row(
              children: [
                _actionButton(
                  icon: Icons.chat_bubble_outline_rounded,
                  label: "${data['repliesCount'] ?? 0} Yorum",
                  onTap: () => _showComments(context, focus: false),
                ),
                const SizedBox(width: 24),
                _actionButton(
                  icon: Icons.reply_all_rounded,
                  label: "Cevapla",
                  onTap: () => _showComments(context, focus: true),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(String label, Color bg, Color text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: text,
          fontSize: 10,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  Widget _actionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 2.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: Colors.indigo.shade400),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) return "Az önce";
    DateTime date = timestamp.toDate();
    Duration diff = DateTime.now().difference(date);
    if (diff.inMinutes < 60) return "${diff.inMinutes} dk önce";
    if (diff.inHours < 24) return "${diff.inHours} sa önce";
    if (diff.inDays < 7) return "${diff.inDays} gün önce";
    return "${date.day}/${date.month}/${date.year}";
  }

  void _showComments(BuildContext context, {required bool focus}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _CommentsSheet(docId: docId, autoFocus: focus),
    );
  }
}

class _CommentsSheet extends StatefulWidget {
  final String docId;
  final bool autoFocus;

  const _CommentsSheet({required this.docId, required this.autoFocus});

  @override
  State<_CommentsSheet> createState() => _CommentsSheetState();
}

class _CommentsSheetState extends State<_CommentsSheet> {
  final TextEditingController _commentController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  // Hangi yorumlara ait yanıtlar açık, ID bazlı takip
  final Set<String> _expandedCommentIds = {};

  // --- DÜZELTME 1: Yanıt durumu artık string eşleşmesiyle değil,
  //                 gerçek comment ID'siyle takip ediliyor ---
  String? _replyToCommentId; // Yanıt verilen yorumun Firestore doc ID'si
  String? _replyToAuthorName; // Sadece hint text için gösteriliyor

  @override
  void initState() {
    super.initState();
    if (widget.autoFocus) {
      Future.delayed(const Duration(milliseconds: 300), () {
        _focusNode.requestFocus();
      });
    }
  }

  @override
  void dispose() {
    _commentController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  String _formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) return "Az önce";
    DateTime date = timestamp.toDate();
    Duration diff = DateTime.now().difference(date);
    if (diff.inMinutes < 60) return "${diff.inMinutes} dk önce";
    if (diff.inHours < 24) return "${diff.inHours} sa önce";
    if (diff.inDays < 7) return "${diff.inDays} gün önce";
    return "${date.day}/${date.month}/${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "Yorumlar",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          const Divider(height: 1),

          // YORUM LİSTESİ
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('forums')
                  .doc(widget.docId)
                  .collection('comments')
                  .orderBy(
                    'timestamp',
                    descending: false,
                  ) // Düzeltme: yanıt sıralaması için ascending
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text("Henüz yorum yok. İlk sen yaz!"),
                  );
                }

                final allDocs = snapshot.data!.docs;

                // --- DÜZELTME 2: Ana yorum / yanıt ayrımı artık
                //     parentCommentId alanıyla yapılıyor, @-string ile değil ---
                final mainComments = allDocs.where((doc) {
                  final d = doc.data() as Map<String, dynamic>;
                  return d['parentCommentId'] ==
                      null; // parentCommentId yoksa ana yorum
                }).toList();

                return ListView.builder(
                  itemCount: mainComments.length,
                  padding: const EdgeInsets.all(16),
                  itemBuilder: (context, index) {
                    final cDoc = mainComments[index];
                    final cData = cDoc.data() as Map<String, dynamic>;
                    final String cId = cDoc.id;

                    // Bu ana yoruma ait yanıtlar: parentCommentId eşleşmesiyle bulunuyor
                    final replies = allDocs.where((doc) {
                      final d = doc.data() as Map<String, dynamic>;
                      return d['parentCommentId'] == cId;
                    }).toList();

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildCommentItem(cData, cId, isReply: false),

                        // Yanıtlar gizliyse "X yanıtı gör" butonu
                        if (replies.isNotEmpty &&
                            !_expandedCommentIds.contains(cId))
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 58.0,
                              bottom: 12,
                            ),
                            child: GestureDetector(
                              onTap: () =>
                                  setState(() => _expandedCommentIds.add(cId)),
                              child: Row(
                                children: [
                                  Container(
                                    width: 25,
                                    height: 1,
                                    color: Colors.grey[300],
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    "${replies.length} yanıtı gör",
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                        // Yanıtlar açıksa listele
                        if (_expandedCommentIds.contains(cId))
                          ...replies.map(
                            (rDoc) => _buildCommentItem(
                              rDoc.data() as Map<String, dynamic>,
                              rDoc.id,
                              isReply: true,
                            ),
                          ),
                      ],
                    );
                  },
                );
              },
            ),
          ),

          // --- DÜZELTME 3: Yanıt modu göstergesi ---
          if (_replyToCommentId != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: Colors.indigo.withOpacity(0.06),
              child: Row(
                children: [
                  const Icon(Icons.reply, size: 16, color: Colors.indigo),
                  const SizedBox(width: 8),
                  Text(
                    "@$_replyToAuthorName kullanıcısına yanıt veriyorsunuz",
                    style: const TextStyle(fontSize: 12, color: Colors.indigo),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: _cancelReply,
                    child: const Icon(
                      Icons.close,
                      size: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),

          // YORUM YAZMA ALANI
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.grey[100]!)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    focusNode: _focusNode,
                    decoration: InputDecoration(
                      hintText: _replyToAuthorName != null
                          ? "@$_replyToAuthorName'e yanıt yaz..."
                          : "Cevabınızı buraya yazın...",
                      hintStyle: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 14,
                      ),
                      filled: true,
                      fillColor: Colors.grey[50],
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                CircleAvatar(
                  backgroundColor: Colors.indigo,
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white, size: 20),
                    onPressed: _submitComment,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _cancelReply() {
    setState(() {
      _replyToCommentId = null;
      _replyToAuthorName = null;
      _commentController.clear();
    });
    _focusNode.unfocus();
  }

  // --- DÜZELTME 4: Yorum gönderilirken parentCommentId Firestore'a kaydediliyor ---
  Future<void> _submitComment() async {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;

    final user = FirebaseAuth.instance.currentUser;
    final String authorName = user?.displayName ?? "Anonim";

    try {
      await FirebaseFirestore.instance
          .collection('forums')
          .doc(widget.docId)
          .collection('comments')
          .add({
            'content': text,
            'author': authorName,
            'userId': user?.uid,
            'timestamp': FieldValue.serverTimestamp(),
            'likes': [],
            // parentCommentId: yanıtsa set edilir, ana yorumsa null kalır
            'parentCommentId': _replyToCommentId,
          });

      await FirebaseFirestore.instance
          .collection('forums')
          .doc(widget.docId)
          .update({'repliesCount': FieldValue.increment(1)});

      _commentController.clear();
      _focusNode.unfocus();

      // Gönderimden sonra yanıt modunu sıfırla
      setState(() {
        _replyToCommentId = null;
        _replyToAuthorName = null;
      });
    } catch (e) {
      debugPrint("Yorum gönderilirken hata: $e");
    }
  }

  Future<void> _toggleLike(
    String commentId,
    List<dynamic> likes,
    bool isLiked,
  ) async {
    final String uid = FirebaseAuth.instance.currentUser?.uid ?? "";
    if (uid.isEmpty) return;

    final docRef = FirebaseFirestore.instance
        .collection('forums')
        .doc(widget.docId)
        .collection('comments')
        .doc(commentId);

    if (isLiked) {
      await docRef.update({
        'likes': FieldValue.arrayRemove([uid]),
      });
    } else {
      await docRef.update({
        'likes': FieldValue.arrayUnion([uid]),
      });
    }
  }

  Widget _buildCommentItem(
    Map<String, dynamic> data,
    String commentId, {
    required bool isReply,
  }) {
    final currentUser = FirebaseAuth.instance.currentUser;
    final List<dynamic> likes = data['likes'] ?? [];
    final bool isLiked = likes.contains(currentUser?.uid);
    final String content = data['content'] ?? "";
    final String? commentOwnerId = data['userId'];
    final String authorName = data['author'] ?? "Anonim";

    return GestureDetector(
      onLongPress: () {
        if (currentUser != null && currentUser.uid == commentOwnerId) {
          _showDeleteOptions(context, commentId);
        }
      },
      child: Padding(
        padding: EdgeInsets.only(
          bottom: isReply ? 12.0 : 20.0,
          left: isReply ? 58.0 : 0.0,
          right: 0.0,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: isReply ? 12 : 16,
              backgroundColor: Colors.grey[200],
              child: Icon(
                Icons.person,
                size: isReply ? 14 : 18,
                color: Colors.grey[400],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(color: Colors.black, fontSize: 13),
                      children: [
                        TextSpan(
                          text: "$authorName ",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(text: content),
                      ],
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text(
                        _formatTimestamp(data['timestamp'] as Timestamp?),
                        style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                      ),
                      const SizedBox(width: 15),
                      // --- DÜZELTME 5: Yanıtla butonu artık ID'yi state'e kaydediyor ---
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _replyToCommentId = commentId;
                            _replyToAuthorName = authorName;
                          });
                          _commentController.clear();
                          _focusNode.requestFocus();
                        },
                        child: const Text(
                          "Yanıtla",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () => _toggleLike(commentId, likes, isLiked),
              child: Column(
                children: [
                  Icon(
                    isLiked ? Icons.favorite : Icons.favorite_border,
                    size: 14,
                    color: isLiked ? Colors.red : Colors.grey[400],
                  ),
                  if (likes.isNotEmpty)
                    Text(
                      "${likes.length}",
                      style: TextStyle(fontSize: 10, color: Colors.grey[400]),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _deleteComment(String commentId) async {
    try {
      await FirebaseFirestore.instance
          .collection('forums')
          .doc(widget.docId)
          .collection('comments')
          .doc(commentId)
          .delete();

      await FirebaseFirestore.instance
          .collection('forums')
          .doc(widget.docId)
          .update({'repliesCount': FieldValue.increment(-1)});

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Yorum silindi'),
            duration: Duration(seconds: 1),
          ),
        );
      }
    } catch (e) {
      debugPrint("Yorum silme hatası: $e");
    }
  }

  void _showDeleteOptions(BuildContext context, String commentId) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline, color: Colors.red),
              title: const Text(
                "Yorumu Sil",
                style: TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontWeight: FontWeight.w600,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                _deleteComment(commentId);
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
