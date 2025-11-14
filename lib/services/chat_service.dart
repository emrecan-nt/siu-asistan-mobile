import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

class ChatService {
  static const String apiUrl = "http://37.148.200.180/api/ask";
  
  // Her cihaz için benzersiz session ID
  late final String sessionId;
  final _uuid = const Uuid();

  ChatService() {
    // Uygulama başladığında bir kere oluştur
    sessionId = _uuid.v4();
    print('🎯 Session ID oluşturuldu: $sessionId');
  }

  Future<String> sendMessage(String message) async {
    print('\n🔵 ===== FLUTTER İSTEK BAŞLIYOR =====');
    print('🔵 URL: $apiUrl');
    print('🔵 Session ID: $sessionId');
    print('🔵 Soru: $message');
    
    try {
      final requestBody = {
        'session_id': sessionId,
        'question': message,
      };
      
      print('🔵 Request Body: ${jsonEncode(requestBody)}');
      
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      ).timeout(
        const Duration(seconds: 30),
      );

      print('🟢 ===== YANIT GELDİ =====');
      print('🟢 Status Code: ${response.statusCode}');
      print('🟢 Response Body: ${response.body}');
      print('🟢 Headers: ${response.headers}');

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        
        print('🟢 Parsed Data: $data');
        
        // Backend'iniz bu formatı kullanıyor
        if (data is Map<String, dynamic>) {
          if (data.containsKey('success') && data['success'] == true) {
            if (data.containsKey('answer')) {
              print('✅ Cevap başarıyla alındı!');
              return data['answer'] as String;
            }
          }
          
          // Diğer formatlar için fallback
          if (data.containsKey('answer')) {
            return data['answer'] as String;
          } else if (data.containsKey('response')) {
            return data['response'] as String;
          } else if (data.containsKey('message')) {
            return data['message'] as String;
          }
        }
        
        // String dönerse
        if (data is String) {
          return data;
        }
        
        print('⚠️ Beklenmeyen format: $data');
        return data.toString();
      } else if (response.statusCode == 400) {
        final error = jsonDecode(utf8.decode(response.bodyBytes));
        print('❌ 400 Hatası: $error');
        throw Exception(error['error'] ?? 'Geçersiz istek');
      } else if (response.statusCode == 405) {
        print('❌ 405 Method Not Allowed!');
        throw Exception('İstek yöntemi kabul edilmedi');
      } else {
        print('❌ Sunucu hatası: ${response.statusCode}');
        throw Exception('Sunucu hatası: ${response.statusCode}');
      }
    } on http.ClientException catch (e) {
      print('❌ HTTP İstek Hatası: $e');
      throw Exception('Sunucuya bağlanılamadı: $e');
    } on FormatException catch (e) {
      print('❌ JSON Parse Hatası: $e');
      throw Exception('Yanıt formatı geçersiz: $e');
    } catch (e) {
      print('❌ Genel Hata: $e');
      throw Exception('Bağlantı hatası: $e');
    }
  }

  // Sohbet geçmişini temizle
  Future<void> clearHistory() async {
    print('🗑️ Geçmiş temizleniyor...');
    try {
      final response = await http.post(
        Uri.parse('http://37.148.200.180/api/clear_history'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'session_id': sessionId,
        }),
      );
      
      print('✅ Geçmiş temizlendi: ${response.statusCode}');
    } catch (e) {
      print('❌ Geçmiş temizlenirken hata: $e');
    }
  }
}