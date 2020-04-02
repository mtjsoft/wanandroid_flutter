import 'package:firstflutterapp/generated/json/base/json_convert_content.dart';

class TreeTypeEntity with JsonConvert<TreeTypeEntity> {
	List<TreeTypechild> children;
	int courseId;
	int id;
	String name;
	int order;
	int parentChapterId;
	int visible;
}

class TreeTypechild with JsonConvert<TreeTypechild> {
	int courseId;
	int id;
	String name;
	int order;
	int parentChapterId;
	int visible;
}
