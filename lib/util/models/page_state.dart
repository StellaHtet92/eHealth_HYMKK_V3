
class PageState{
  static const pageLoadingState = "LOADING";
  static const pageLoadedState = "LOADED";
  static const pageLoadingFailState = 'LOADINGFAIL';

  static const pageLoadMoreState = "LOADMORE";
  static const pageLoadMoreFailState = "LOADMOREFAIL";

  static const successState = "ACTIONSUCCESS";
  static const failState = "ACTIONFAIL";
  static const warningState = "ACTIONWARNING";

  final String state;
  final String message;

  PageState({this.state = pageLoadedState,this.message = ""});
}