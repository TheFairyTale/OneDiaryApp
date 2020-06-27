import 'package:shared_preferences/shared_preferences.dart';

class Article {
  var articleYYMTime = "";
  var articleHourMinuSecTime = "";
  // 仅用于读取或保存当前文章id， 不担当文章个数储存
  var articleId = 0;
  var articleAmount = 0;
  // 读取出的文章保存在此
  var article = "";

  /// 传入 文章id，获取文章创建时间（精确到年月日）
  getArticleYYMTime(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    articleYYMTime = prefs.getString(id + 'createYYMTime');
  }

  /// 设置文章id+createYYMTime为key, value 为创建时间（精确到年月日）
  setArticleYYMTime(String id, String YYMTime) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(id + 'createYYMTime', YYMTime);
  }

  /// 传入 文章id，获取文章创建时间(精确到小时)
  getArticleHourMinuSecTime(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    articleHourMinuSecTime = prefs.getString(id + 'createHourMinuSecTime');
  }

  /// 设置文章id+createHourMinuSecTime为key, value 为创建时间(精确到小时)
  setArticleHourMinuSecTime(String id, String hourMinuSecTime) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(id + 'createHourMinuSecTime', hourMinuSecTime);
  }

  /// 传入 文章id，获取文章内容
  getArticle(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      article = prefs.getString(id);
    } on Exception catch (e) {
      article = "No article found.";
    }
  }

  /// 设置文章id为key, value 为文章内容
  setArticle(String id, String article) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(id, article);
  }

  /// 删除指定文章 // 暂不可用
  deleteArticle(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // 将setString() 第二参设为null 则会删除指定key 的值
    await prefs.setString(id, null);
  }

  /// 设置已有文章数量: 新增一篇文章 注意应在getArticleAmount() 之后调用
  addArticleAmount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int articleCount = prefs.getInt('articleAmount');
    articleAmount = ++articleCount;
    prefs.setInt('articleAmount', articleAmount);
  }

  /// 获取文章已有数量, 如无文章数量则先初始化
  getArticleAmount() async {
    int articleCount = null;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      articleCount = prefs.getInt('articleAmount');
    } on Exception catch (e) {
      // 如果没有设置过文章数量则初始化为 0
      await prefs.setInt('articleAmount', 0);
      articleCount = prefs.getInt('articleAmount');
    }
    articleAmount = articleCount;
  }
}
