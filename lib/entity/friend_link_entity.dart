import 'package:firstflutterapp/generated/json/base/json_convert_content.dart';

class FriendLinkEntity with JsonConvert<FriendLinkEntity> {
	String icon;
	int id;
	String link;
	String name;
	int order;
	int visible;
}
