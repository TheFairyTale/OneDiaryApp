import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import 'Article.dart';

class ViewArticle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
// TODO 将时间存在临时文件中，以防止程序恢复草稿时搞错时间
    final TimeNow = DateTime.now();
    final YYMDay =
        formatDate(TimeNow, [yyyy, ' ', M, ' ', d]); // DateTime.now();'
    final HourMinuSec = formatDate(TimeNow, [HH, ':', nn, ':', ss]);

    final article = Article();
    var articleAmount = 0;

    String data = '''
👏  欢迎使用 **Gridea** ！  
✍️  **Gridea** 一个静态博客写作客户端。
<!-- more -->

[Github](https://github.com/getgridea/gridea)  
[Gridea 主页](http://hvenotes.fehey.com/)  
[示例网站](http://fehey.com/)

🌁  你可以任意使用应用内默认主题或任意第三方主题，强大的主题自定义能力  

🖥  你可以自定义源文件夹，利用 OneDrive、百度网盘、iCloud、Dropbox 等进行多设备同步  

🌱 当然 **Gridea** 还很年轻，有很多不足，但请相信，它会不停向前🏃

未来，它一定会成为你离不开的伙伴

尽情发挥你的才华吧！

😘 Enjoy~

''';

    // 存储文章时间
    article.articleYYMTime = YYMDay;
    article.articleHourMinuSecTime = HourMinuSec;
    // 获取当前文章总数
    article.getArticleAmount();
    articleAmount = article.articleAmount;

    return new Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.close),
        title: Text(YYMDay.split(" ")[1] +
            " " +
            YYMDay.split(" ")[2] +
            "/" +
            HourMinuSec.split(":")[0] +
            ":" +
            HourMinuSec.split(":")[1]),
        actions: <Widget>[
          IconButton(
              tooltip: "Choose category",
              icon: Icon(Icons.bookmark),
              onPressed: () {}),
          // 导航栏右侧菜单
          Row(
            children: <Widget>[
              PopupMenuButton<String>(
                tooltip: "More options",
                icon: Icon(Icons.more_vert),
                onSelected: (String result) {},
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(
                    value: "1",
                    child: Text('Title'),
                  ),
                  const PopupMenuItem<String>(
                    value: "2",
                    child: Text('Markdown'),
                  ),
                  const PopupMenuItem<String>(
                    value: "3",
                    child: Text('Private diary'),
                  ),
                  const PopupMenuItem<String>(
                    value: "4",
                    child: Text('Diary template'),
                  ),
                  const PopupMenuItem<String>(
                    value: "5",
                    child: Text('Last'),
                  ),
                  const PopupMenuItem<String>(
                    value: "6",
                    child: Text('Give up editing'),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 4.0, right: 4.0, top: 0, bottom: 0),
              child: Markdown(data: data),
            ),
          ),
        ],
      ),
    );
  }
}
