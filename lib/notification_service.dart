import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Bildirim türleri
enum NotificationType {
  forumReply, // Forum yorumuna biri yanıt verdiğinde
  forumComment, // Kendi forum gönderine yorum yapıldığında
  newJob, // Yeni iş/staj ilanı eklendiğinde
  newEvent, // Yeni etkinlik eklendiğinde
  newMessage, // Birisi sana mesaj gönderdiğinde
  commentLike,
}

extension NotificationTypeExtension on NotificationType {
  String get icon {
    switch (this) {
      case NotificationType.forumReply:
        return "💬";
      case NotificationType.forumComment:
        return "🗨️";
      case NotificationType.newJob:
        return "💼";
      case NotificationType.newEvent:
        return "🗓";
      case NotificationType.commentLike:
        return "❤️";
      case NotificationType.newMessage:
        return "✉️";
    }
  }

  String get label {
    switch (this) {
      case NotificationType.forumReply:
        return "forum_reply";
      case NotificationType.forumComment:
        return "forum_comment";
      case NotificationType.newJob:
        return "new_job";
      case NotificationType.newEvent:
        return "new_event";
      case NotificationType.commentLike:
        return "comment_like";
      case NotificationType.newMessage:
        return "new_message";
    }
  }
}

class NotificationService {
  static final _db = FirebaseFirestore.instance;

  // ────────────────────────────────────────────────
  // TEMEL YAZMA FONKSİYONU
  // targetUserId: kime gönderilecek
  // ────────────────────────────────────────────────
  static Future<void> _send({
    required String targetUserId,
    required NotificationType type,
    required String title,
    String? relatedId, // ilgili doküman ID'si (forum, iş, etkinlik vs.)
    String? senderName,
  }) async {
    final currentUid = FirebaseAuth.instance.currentUser?.uid;

    // Kişi kendine bildirim göndermesin
    if (currentUid == targetUserId) return;

    await _db
        .collection('notifications')
        .doc(targetUserId)
        .collection('items')
        .add({
          'type': type.label,
          'icon': type.icon,
          'title': title,
          'isRead': false,
          'timestamp': FieldValue.serverTimestamp(),
          'relatedId': relatedId,
          'senderName': senderName,
        });
  }

  // ────────────────────────────────────────────────
  // 1. Forum yorumuna yanıt verildiğinde
  //    Çağrı yeri: _CommentsSheetState._submitComment()
  //    (parentCommentId varsa ve o yorumun sahibi farklıysa)
  // ────────────────────────────────────────────────
  static Future<void> sendForumReply({
    required String commentOwnerUserId,
    required String replierName,
    required String forumDocId,
  }) async {
    await _send(
      targetUserId: commentOwnerUserId,
      type: NotificationType.forumReply,
      title: "$replierName yorumunuza yanıt verdi",
      relatedId: forumDocId,
      senderName: replierName,
    );
  }

  // ────────────────────────────────────────────────
  // 2. Kendi forum gönderisine yorum yapıldığında
  //    Çağrı yeri: _CommentsSheetState._submitComment()
  //    (parentCommentId yoksa, yani ana yorum ise)
  // ────────────────────────────────────────────────
  static Future<void> sendForumComment({
    required String forumOwnerUserId,
    required String commenterName,
    required String forumDocId,
    required String forumTitle,
  }) async {
    await _send(
      targetUserId: forumOwnerUserId,
      type: NotificationType.forumComment,
      title: "$commenterName \"$forumTitle\" gönderinize yorum yaptı",
      relatedId: forumDocId,
      senderName: commenterName,
    );
  }

  // ────────────────────────────────────────────────
  // 3. Yeni iş/staj ilanı eklendi (TÜM kullanıcılara)
  //    Çağrı yeri: İş ilanı ekleme sayfası (kaydet butonu)
  //    Not: Tüm kullanıcı ID'lerini users koleksiyonundan çekiyoruz.
  //    Büyük ölçekte Cloud Functions kullanılmalı.
  // ────────────────────────────────────────────────
  static Future<void> sendNewJobToAll({
    required String jobTitle,
    required String company,
    required String jobDocId,
  }) async {
    final usersSnapshot = await _db.collection('users').get();
    final currentUid = FirebaseAuth.instance.currentUser?.uid;

    final batch = _db.batch();

    for (final userDoc in usersSnapshot.docs) {
      if (userDoc.id == currentUid) continue; // kendini atla

      final ref = _db
          .collection('notifications')
          .doc(userDoc.id)
          .collection('items')
          .doc(); // yeni doc

      batch.set(ref, {
        'type': NotificationType.newJob.label,
        'icon': NotificationType.newJob.icon,
        'title': "$company yeni bir ${jobTitle} ilanı yayınladı",
        'isRead': false,
        'timestamp': FieldValue.serverTimestamp(),
        'relatedId': jobDocId,
      });
    }

    await batch.commit();
  }

  // ────────────────────────────────────────────────
  // 4. Yeni etkinlik eklendi (TÜM kullanıcılara)
  //    Çağrı yeri: Etkinlik ekleme sayfası (kaydet butonu)
  // ────────────────────────────────────────────────
  static Future<void> sendNewEventToAll({
    required String eventTitle,
    required String eventDocId,
  }) async {
    final usersSnapshot = await _db.collection('users').get();
    final currentUid = FirebaseAuth.instance.currentUser?.uid;

    final batch = _db.batch();

    for (final userDoc in usersSnapshot.docs) {
      if (userDoc.id == currentUid) continue;

      final ref = _db
          .collection('notifications')
          .doc(userDoc.id)
          .collection('items')
          .doc();

      batch.set(ref, {
        'type': NotificationType.newEvent.label,
        'icon': NotificationType.newEvent.icon,
        'title': "Yeni etkinlik: $eventTitle",
        'isRead': false,
        'timestamp': FieldValue.serverTimestamp(),
        'relatedId': eventDocId,
      });
    }

    await batch.commit();
  }

  // ────────────────────────────────────────────────
  // 5. Mesaj gönderildiğinde
  //    Çağrı yeri: Mesajlaşma sayfası (gönder butonu)
  // ────────────────────────────────────────────────
  static Future<void> sendNewMessage({
    required String receiverUserId,
    required String senderName,
    required String conversationId,
  }) async {
    await _send(
      targetUserId: receiverUserId,
      type: NotificationType.newMessage,
      title: "$senderName size bir mesaj gönderdi",
      relatedId: conversationId,
      senderName: senderName,
    );
  }

  // ────────────────────────────────────────────────
  // OKUMA YARDIMCILARI
  // ────────────────────────────────────────────────

  /// Mevcut kullanıcının bildirimlerini gerçek zamanlı stream olarak döner
  static Stream<QuerySnapshot> streamForCurrentUser() {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return const Stream.empty();

    return _db
        .collection('notifications')
        .doc(uid)
        .collection('items')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  /// Tek bir bildirimi okundu yap
  static Future<void> markAsRead(String notifId) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    await _db
        .collection('notifications')
        .doc(uid)
        .collection('items')
        .doc(notifId)
        .update({'isRead': true});
  }

  /// Tüm bildirimleri okundu yap
  static Future<void> markAllAsRead() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final snap = await _db
        .collection('notifications')
        .doc(uid)
        .collection('items')
        .where('isRead', isEqualTo: false)
        .get();

    final batch = _db.batch();
    for (final doc in snap.docs) {
      batch.update(doc.reference, {'isRead': true});
    }
    await batch.commit();
  }

  /// Tek bildirimi sil
  static Future<void> delete(String notifId) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    await _db
        .collection('notifications')
        .doc(uid)
        .collection('items')
        .doc(notifId)
        .delete();
  }

  /// Tüm bildirimleri sil
  static Future<void> deleteAll() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final snap = await _db
        .collection('notifications')
        .doc(uid)
        .collection('items')
        .get();

    final batch = _db.batch();
    for (final doc in snap.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }

  /// 24 saatten eski bildirimleri temizle
  static Future<void> deleteOlderThan24h() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final cutoff = Timestamp.fromDate(
      DateTime.now().subtract(const Duration(hours: 24)),
    );

    final snap = await _db
        .collection('notifications')
        .doc(uid)
        .collection('items')
        .where('timestamp', isLessThan: cutoff)
        .get();

    final batch = _db.batch();
    for (final doc in snap.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }

  static Future<void> sendCommentLike({
    required String commentOwnerUserId,
    required String likerName,
    required String forumDocId,
    required String commentId, // Yeni eklendi
  }) async {
    await _send(
      targetUserId: commentOwnerUserId,
      type: NotificationType.commentLike,
      title: "$likerName bir yorumunuzu beğendi",
      relatedId: forumDocId,
      senderName: likerName,
      // Ek bilgi olarak yorum ID'sini title veya farklı bir alanda taşıyabiliriz
      // Ama en temizi relatedId içine "forumId|commentId" şeklinde birleştirmek:
      // relatedId: "$forumDocId|$commentId",
    );
  }
}
