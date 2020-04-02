import 'package:firstflutterapp/generated/json/base/json_convert_content.dart';

class ChaptersEntity with JsonConvert<ChaptersEntity> {
	int courseId;
	int id;
	String name;
	int order;
	int parentChapterId;
	bool userControlSetTop;
	int visible;
}
