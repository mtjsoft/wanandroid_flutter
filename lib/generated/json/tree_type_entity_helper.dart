import 'package:firstflutterapp/entity/tree_type_entity.dart';

treeTypeEntityFromJson(TreeTypeEntity data, Map<String, dynamic> json) {
	if (json['children'] != null) {
		data.children = new List<TreeTypechild>();
		(json['children'] as List).forEach((v) {
			data.children.add(new TreeTypechild().fromJson(v));
		});
	}
	if (json['courseId'] != null) {
		data.courseId = json['courseId']?.toInt();
	}
	if (json['id'] != null) {
		data.id = json['id']?.toInt();
	}
	if (json['name'] != null) {
		data.name = json['name']?.toString();
	}
	if (json['order'] != null) {
		data.order = json['order']?.toInt();
	}
	if (json['parentChapterId'] != null) {
		data.parentChapterId = json['parentChapterId']?.toInt();
	}
	if (json['visible'] != null) {
		data.visible = json['visible']?.toInt();
	}
	return data;
}

Map<String, dynamic> treeTypeEntityToJson(TreeTypeEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	if (entity.children != null) {
		data['children'] =  entity.children.map((v) => v.toJson()).toList();
	}
	data['courseId'] = entity.courseId;
	data['id'] = entity.id;
	data['name'] = entity.name;
	data['order'] = entity.order;
	data['parentChapterId'] = entity.parentChapterId;
	data['visible'] = entity.visible;
	return data;
}

treeTypechildFromJson(TreeTypechild data, Map<String, dynamic> json) {
	if (json['courseId'] != null) {
		data.courseId = json['courseId']?.toInt();
	}
	if (json['id'] != null) {
		data.id = json['id']?.toInt();
	}
	if (json['name'] != null) {
		data.name = json['name']?.toString();
	}
	if (json['order'] != null) {
		data.order = json['order']?.toInt();
	}
	if (json['parentChapterId'] != null) {
		data.parentChapterId = json['parentChapterId']?.toInt();
	}
	if (json['visible'] != null) {
		data.visible = json['visible']?.toInt();
	}
	return data;
}

Map<String, dynamic> treeTypechildToJson(TreeTypechild entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['courseId'] = entity.courseId;
	data['id'] = entity.id;
	data['name'] = entity.name;
	data['order'] = entity.order;
	data['parentChapterId'] = entity.parentChapterId;
	data['visible'] = entity.visible;
	return data;
}