import 'package:http/http.dart' as http;

Future<void> main() async {
  final url = Uri.parse(
      'https://api.quran.com/api/v4/recitations/7/by_chapter/1?per_page=1');
  print("Fetching $url...");
  final response = await http.get(url);
  print("Status: ${response.statusCode}");
  if (response.statusCode == 200) {
    print("Success! Body sample: ${response.body.substring(0, 100)}");
  } else {
    print("Failed. Body: ${response.body}");
  }
}
