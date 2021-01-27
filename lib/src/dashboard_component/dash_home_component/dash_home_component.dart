import 'package:angular/angular.dart';
import 'package:angular_app/src/dashboard_component/dashboard_services/create_post_service.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_modern_charts/angular_modern_charts.dart';
import 'package:angular_app/variables.dart';
import 'dart:html';

@Component(
  selector: 'dash-home',
  templateUrl: 'dash_home_component.html',
  styleUrls: ['dash_home_component.css'],
  directives: [
    GaugeChartComponent,
    MaterialProgressComponent,
  ],
  pipes: [commonPipes],
  providers: [ClassProvider(GetPostService)],
)
class DashHomeComponent implements OnInit{
  DateTime date = DateTime.now();
  String postCreated = 'Post';
  String postScheduled = 'Post';
  int activeProgress = 10;

  int postCount = 0;
  int scheduleCount = 0;
  List<SchedulePost> socketArray = <SchedulePost>[];


  final GetPostService _getPostService;
  DashHomeComponent(this._getPostService);

  @override
  Future<void> ngOnInit() async {
    postCount = await _getPostService.getPostCount();
    scheduleCount = await _getPostService.getScheduleCount();

    var webSocket = WebSocket('${env['SCHEDULE_STATUS_WEBSOCKET']}');
    webSocket.onOpen.first.then((value) => {
      print('Connected to web socket successfully')
    });
    webSocket.onMessage.listen((event) {
      print(event.data);
    });
  }

}
class SchedulePost {
  String scheduleId;
  String scheduleTitle;
  String from;
  String to;
  List<String> postIds;
  List<Post> posts;
  int postCount;

  SchedulePost(
      this.scheduleId,
      this.scheduleTitle,
      this.from,
      this.to,
      this.postIds,
      this.posts,
      this.postCount
      );
}