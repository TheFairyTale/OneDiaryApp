import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import 'Article.dart';

class AddArticle extends StatefulWidget {
  AddArticle({Key key}) : super(key: key);

  @override
  _AddArticleState createState() => _AddArticleState();
}

class _AddArticleState extends State<AddArticle> {
  TextEditingController _controller;

  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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

## 特性👇
📝  你可以使用最酷的 **Markdown** 语法，进行快速创作  

🌉  你可以给文章配上精美的封面图和在文章任意位置插入图片  

🏷️  你可以对文章进行标签分组  

📋  你可以自定义菜单，甚至可以创建外部链接菜单  

💻  你可以在 **𝖶𝗂𝗇𝖽𝗈𝗐𝗌** 或 **𝖬𝖺𝖼𝖮𝖲** 设备上使用此客户端  

🌎  你可以使用 **𝖦𝗂𝗍𝗁𝗎𝖻 𝖯𝖺𝗀𝖾𝗌** 或 **Coding Pages** 向世界展示，未来将支持更多平台  

💬  你可以进行简单的配置，接入 [Gitalk](https://github.com/gitalk/gitalk) 或 [DisqusJS](https://github.com/SukkaW/DisqusJS) 评论系统  

🇬🇧  你可以使用**中文简体**或**英语**  

🌁  你可以任意使用应用内默认主题或任意第三方主题，强大的主题自定义能力  

🖥  你可以自定义源文件夹，利用 OneDrive、百度网盘、iCloud、Dropbox 等进行多设备同步  

🌱 当然 **Gridea** 还很年轻，有很多不足，但请相信，它会不停向前🏃

未来，它一定会成为你离不开的伙伴

尽情发挥你的才华吧！

😘 Enjoy~

''';

/* 
    try {
      // id暂时为 1

    } on Exception catch (e) {

    } */

    // 存储文章时间
    article.articleYYMTime = YYMDay;
    article.articleHourMinuSecTime = HourMinuSec;
    // 获取当前文章总数
    article.getArticleAmount();
    articleAmount = article.articleAmount;

/*
    Future<File> _getLocalFile() async {
      // get the path to the document directory.
      String dir = (await getApplicationDocumentsDirectory()).path;
      return new File('$dir/data/diary/' + TimeNow.toString() + '.txt');
    }
*/
/*
    String texts;

    Future<void> processallfile() async {
      ProcessResult results = await Process.run('ls', ['-l']);
      texts = results.stdout.toString();
      print(results.stdout);
    }
*/
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
          // Used on editor mode
          /*
          SizedBox(
            child: Container(
              height: 18,
              color: Color.fromRGBO(255, 255, 255, 0.2),
              child: Text("data"),
            ),
          ),
          */
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 4.0, right: 4.0, top: 0, bottom: 0),
              child: Markdown(data: data + data),
            ),
          ),
        ],
      ),
      /*
          Center(
            child: TextField(
              controller: _controller,
              scrollPadding: const EdgeInsets.all(12),
              decoration: InputDecoration(
                hintText: "type something here",
              ),
              textInputAction: TextInputAction.done,
              onSubmitted: (String value) {
                // 新增文章
                article.addArticleAmount();
                // 设置当前文章id
                article.articleId = articleAmount;
                // 保存文章
                article.setArticle(article.articleId.toString(), value);
              },
            ),
          ),
          */
      /*
          Center(
            child: Text("Your most recent written article: " +
                article.getArticle(articleAmount.toString()).toString()),
          ),
          Center(
            child: Text("articleId is : " + article.articleId.toString()),
          ),
          Center(
            child:
                Text("articleAmount is : " + article.articleAmount.toString()),
          ),
          */
    );
  }
}
