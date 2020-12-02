
import 'dart:html';

import 'package:angular/angular.dart';
import 'package:angular_app/src/dashboard_component/inner_routes.dart';
import 'package:angular_app/src/routes.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_components/utils/browser/window/module.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_router/angular_router.dart';

import 'package:angular_app/src/dashboard_component/create_post_component/create_post_component.dart' deferred as create_post_page;
import 'package:angular_app/src/dashboard_component/view_post_component/view_post_component.dart' deferred as view_post_page;
import 'package:angular_app/src/dashboard_component/manage_post_component/manage_post_component.dart' deferred as manage_post_page;
import 'package:angular_app/src/dashboard_component/dash_home_component/dash_home_component.dart' deferred as dash_home_page;

import 'inner_route_paths.dart';

@Component(
  selector: 'dash-app',
  templateUrl: 'dashboard_component.html',
  styleUrls: [
    'dashboard_component.css',
    'package:angular_components/app_layout/layout.scss.css'
  ],
  directives: [
    MaterialPersistentDrawerDirective,
    MaterialTemporaryDrawerComponent,
    MaterialButtonComponent,
    MaterialIconComponent,
    MaterialListComponent,
    MaterialListItemComponent,
    DeferredContentDirective,
    MaterialToggleComponent,
    formDirectives,
    coreDirectives,
    routerDirectives,
  ],
  exports: [InnerRoutes, InnerRoutePaths, Routes, RoutePaths],
)
class DashboardComponent implements OnInit {

  bool persistentDrawerType = false;
  bool temporaryDrawerType = false;
  bool customWidth = false;
  bool end = false;
  bool overlay = true;
  Router _router;
  Location _location;

  DashboardComponent(this._router, this._location);

  Future<void> gotoDashHome() async {
    _router.navigate(InnerRoutePaths.dash_home.toUrl());
  }
  Future<void> gotoCreatePost() async {
    _router.navigate(InnerRoutePaths.create_post.toUrl());
  }
  Future<void> gotoViewPost() async {
    _router.navigate(InnerRoutePaths.view_post.toUrl());
  }
  Future<void> gotoManagePost() async {
    _router.navigate(InnerRoutePaths.manage_post.toUrl());
  }
  Future<void> gotoPostAccount() async {
    _router.navigate(InnerRoutePaths.post_account.toUrl());
  }
  Future<void> gotoUserAccount() async {
    _router.navigate(InnerRoutePaths.user_account.toUrl());
  }
  Future<void> gotoSetting() async {
    _router.navigate(InnerRoutePaths.setting.toUrl());
  }
  Future<void> goBack() async {
    _location.back();
  }
  Future<void> goForward() async {
    _location.forward();
  }

  void getScreenSize() {

    var a = getDocument();

    int width = a.querySelector('body').clientWidth;

    if(width <= 576) {
      print('Extra small device');
      temporaryDrawerType = true;
      persistentDrawerType = false;
    } else if(width > 576 && width <= 720) {
      print('Small device');
      temporaryDrawerType = true;
      persistentDrawerType = false;
    } else if(width > 720 && width <= 900) {
      print('Medium device');
      temporaryDrawerType = false;
      persistentDrawerType = true;
    } else if(width > 900) {
      print('Large device');
      temporaryDrawerType = false;
      persistentDrawerType = true;
    }
  }

  @override
  Future<void> ngOnInit() async {
    if(
        window.localStorage.containsKey('token') &&
        window.localStorage.containsKey('tenant-namespace') &&
        window.localStorage['token'] != null &&
        window.localStorage['tenant-namespace'] != null &&
        window.localStorage['token'] != '' &&
        window.localStorage['tenant-namespace'] != ''
    ) {
      await create_post_page.loadLibrary();
      await view_post_page.loadLibrary();
      await manage_post_page.loadLibrary();
      await dash_home_page.loadLibrary();
      getScreenSize();
    } else {
      _router.navigate(RoutePaths.login.toUrl());
    }
  }
}