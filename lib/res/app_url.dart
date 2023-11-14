class AppUrl {
  static var baseUrl = 'https://iamconnect.com/api/';
  static var url = 'https://iamconnect.com/';

  /*static var baseUrl = 'https://friendly-cohen.3-16-11-30.plesk.page/api/';
  static var url = 'https://friendly-cohen.3-16-11-30.plesk.page/';

  */
  static var loginUrl = baseUrl + 'login';
  static var registeUrl = baseUrl + 'register';
  static var verifyEmail = baseUrl + 'verify-email';
  static var deactivateAccount = baseUrl + 'user/deactivate';

  static var afterRejectionUrl = baseUrl + 'user/update';
  static var fetchUser = baseUrl + 'user/fetch';
  static var fetchUserDetail = baseUrl + 'user/detail';
  static var updateSocialInfo = baseUrl + 'user/update-profile';
  static var fetchSearchUsers = baseUrl + 'user/search';
  static var storeDeviceId = baseUrl + 'user/store_device';
  static var removeDeviceId = baseUrl + 'user/remove_device';
  static var changeCoverPicture = baseUrl + 'user/update-cover-photo';
  static var fetchNotifications = baseUrl + 'notifications';
  static var changePassword = baseUrl + 'user/update/password';
  static var fetchBlocklist = baseUrl + 'user/block-list';
  static var unblockUser = baseUrl + 'user/unblock';
  static var blockUser = baseUrl + 'user/block';

  static var fetchWalletTransactions = baseUrl + 'wallet/transactions';
  static var fetchWalletMyBalance = baseUrl + 'wallet/my-balance';

  static var changeProfilePicture = baseUrl + 'user/update-profile-photo';
  static var forgetPassword = baseUrl + 'forgot-password';

  static var fetchFriends = baseUrl + 'network/fetch';
  static var networkStatus = baseUrl + 'network/status';
  static var networkRequests = baseUrl + 'network/all-requests';

  static var fetchPrivacy = baseUrl + 'privacy/fetch';
  static var updatePrivacy = baseUrl + 'privacy/update';
  static var checkPrivacy = baseUrl + 'privacy/check';

  static var sendConnectionRequest = baseUrl + 'connections/send-request';
  static var acceptOrRejectConnectionRequest =
      baseUrl + 'connections/accept-reject';
  static var unConnection = baseUrl + 'connections/remove';

  static var sendFriendRequest = baseUrl + 'friend/send-request';
  static var unfriend = baseUrl + 'friend/remove';
  static var acceptOrRejectFriendRequest = baseUrl + 'friend/accept-reject';

  static var fetchAllMessages = baseUrl + 'chat';
  static var storeMessages = baseUrl + 'chat/store';
  static var markAllMessagesAsRead = baseUrl + 'chat/read-all-messages';

  static var createPost = baseUrl + 'post/create';
  static var fetchAllTwoPosts = baseUrl + 'post/fetch/all/show-more';
  static var fetchMyPosts = baseUrl + 'post/fetch/my/show-more';
  static var fetchSinglePost = baseUrl + 'post/fetch/post';
  static var deleteMyPosts = baseUrl + 'post/delete';
  static var fetchAllComments = baseUrl + 'post/fetch/comment';

  static var storeComments = baseUrl + 'comment/store';
  static var storeLikes = baseUrl + 'like/store';
  static var fetchLikes = baseUrl + 'like/fetch';
  static var fetchGalleryImages = baseUrl + 'gallery/fetch';
  static var markAllNotificationAsRead =
      baseUrl + 'notifications/all/mark-as-read';

  static var createNewPassword = baseUrl + 'create-new-password';

  //report post
  static var reportPosts = baseUrl + 'post/report/store';
}
