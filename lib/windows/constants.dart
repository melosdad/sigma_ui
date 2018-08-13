class Constants {

  static final development = true;
  static final base_url = development ? "http://10.1.73.237/sigma/" : "https://sigma.start-x.co.za/";

  static final String registerUrl = base_url+ "register.php";
  static final String loginUrl = base_url+ "login.php";
  static final String updateUserTypeUrl = base_url+  "updateusertype.php";
  static final String getBrandsUrl = base_url+ "getbrands.php";
  static final String followUrl = base_url+ "follows.php";
  static final String unfollowUrl = base_url+ "unfollow.php";
  static final String getfollowingsUrl = base_url+ "getfollowings.php";
  static final String getChatsUrl = base_url+ "getuserchats.php";
  static final String getChatConversationsUrl = base_url+ "getchatsconversations.php";
  static final String sendMessageUrl = base_url+ "sigma/postchat.php";
  static final String updateProfileUrl = base_url+ "updateprofile.php";
  static final String updatePPUrl = base_url+ "uploadpp.php";

}