import 'package:firstflutterapp/generated/json/base/json_convert_content.dart';

class UserInfoEntity with JsonConvert<UserInfoEntity> {
	bool admin;
	List<dynamic> chapterTops;
	List<int> collectIds;
	String email;
	String icon;
	int id;
	String nickname;
	String password;
	String publicName;
	String token;
	int type;
	String username;
	int coinCount;
	int rank;
	int userId;
}
