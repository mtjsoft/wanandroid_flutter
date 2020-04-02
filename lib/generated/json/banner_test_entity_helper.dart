import 'package:firstflutterapp/entity/banner_test_entity.dart';

bannerTestEntityFromJson(BannerTestEntity data, Map<String, dynamic> json) {
	if (json['desc'] != null) {
		data.desc = json['desc']?.toString();
	}
	if (json['id'] != null) {
		data.id = json['id']?.toInt();
	}
	if (json['imagePath'] != null) {
		data.imagePath = json['imagePath']?.toString();
	}
	if (json['isVisible'] != null) {
		data.isVisible = json['isVisible']?.toInt();
	}
	if (json['order'] != null) {
		data.order = json['order']?.toInt();
	}
	if (json['title'] != null) {
		data.title = json['title']?.toString();
	}
	if (json['type'] != null) {
		data.type = json['type']?.toInt();
	}
	if (json['url'] != null) {
		data.url = json['url']?.toString();
	}
	return data;
}

Map<String, dynamic> bannerTestEntityToJson(BannerTestEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['desc'] = entity.desc;
	data['id'] = entity.id;
	data['imagePath'] = entity.imagePath;
	data['isVisible'] = entity.isVisible;
	data['order'] = entity.order;
	data['title'] = entity.title;
	data['type'] = entity.type;
	data['url'] = entity.url;
	return data;
}