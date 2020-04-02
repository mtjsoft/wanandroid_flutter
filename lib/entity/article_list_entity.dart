import 'package:firstflutterapp/generated/json/base/json_convert_content.dart';

/// 首页文章列表
class ArticleListEntity with JsonConvert<ArticleListEntity> {
	int curPage;
	List<ArticleListData> datas;
	int offset;
	bool over;
	int pageCount;
	int size;
	int total;
}

class ArticleListData with JsonConvert<ArticleListData> {
	String apkLink;
	int audit;
	String author;
	bool canEdit;
	int chapterId;
	String chapterName;
	bool collect;
	int courseId;
	String desc;
	String descMd;
	String envelopePic;
	bool fresh;
	int id;
	String link;
	String niceDate;
	String niceShareDate;
	String origin;
	String prefix;
	String projectLink;
	int publishTime;
	int selfVisible;
	int shareDate;
	String shareUser;
	int superChapterId;
	String superChapterName;
	List<dynamic> tags;
	String title;
	int type;
	int userId;
	int visible;
	int zan;
}
