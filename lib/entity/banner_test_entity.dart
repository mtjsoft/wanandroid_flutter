import 'package:firstflutterapp/generated/json/base/json_convert_content.dart';
/// 首页Banner图
class BannerTestEntity with JsonConvert<BannerTestEntity> {
	String desc;
	int id;
	String imagePath;
	int isVisible;
	int order;
	String title;
	int type;
	String url;
}
