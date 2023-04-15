import '../model/dto/dependency.dart';

extension StringExtensions on String {
  bool isGithubUrl() =>
      startsWith('https://github.com/') ||
      startsWith('https://www.github.com/') ||
      startsWith('http://github.com/') ||
      startsWith('http://www.github.com/') ||
      startsWith('git://github.com/') ||
      startsWith('git@github.com:');

  bool isGitLabUrl() =>
      startsWith('https://gitlab.com/') ||
      startsWith('https://www.gitlab.com/') ||
      startsWith('http://gitlab.com/') ||
      startsWith('http://www.gitlab.com/') ||
      startsWith('git://gitlab.com/') ||
      startsWith('git@gitlab.com:');

  bool isGithubRawUrl() =>
      startsWith('https://raw.githubusercontent.com') ||
      startsWith('https://www.raw.githubusercontent.com') ||
      startsWith('http://raw.githubusercontent.com') ||
      startsWith('http://www.raw.githubusercontent.com');

  bool isBitbucketUrl() =>
      startsWith(RegExp(r'https?://(.*?)@(?:www.)?bitbucket.org')) ||
      startsWith('git@bitbucket.org');
}

extension GitInfoExtensions on GitInfo {
  String getGitLabPubSpecUrl() {
    const hostName = 'gitlab';
    var newUrl = _getCleanedUpUrl(hostName);

    newUrl = '$newUrl/-/raw';

    if (ref != null) {
      newUrl = '$newUrl/$ref';
    } else {
      newUrl = '$newUrl/master';
    }
    if (path != null) {
      newUrl = '$newUrl/$path';
    }
    return '$newUrl/pubspec.yaml';
  }

  String getGithubPubSpecUrl() {
    const hostName = 'github';
    const rawGithubUrl = 'https://raw.githubusercontent.com/';
    var newUrl = _getCleanedUpUrl(hostName);
    newUrl = _replaceHostname(newUrl, hostName, rawGithubUrl);
    if (ref != null) {
      newUrl = '$newUrl/$ref';
    } else {
      newUrl = '$newUrl/master';
    }
    if (path != null) {
      newUrl = '$newUrl/$path';
    }
    return '$newUrl/pubspec.yaml';
  }

  String getBitbucketPubSpecUrl() {
    // Bitbucket uses a different url scheme than GitHUb or Gitlab.
    // Instead of adding a bunch of checks to the _getCleanedUpUrl function,
    // we simply build the correct url directly.

    // Extract username and repo name from url
    final regex = RegExp(r'\.org.(.+?)(?:\.git|$)');
    final userAndRepo = regex.firstMatch(url)!.group(1);
    var newUrl = 'https://bitbucket.org/$userAndRepo';

    newUrl = '$newUrl/raw';

    if (ref != null) {
      newUrl = '$newUrl/$ref';
    } else {
      newUrl = '$newUrl/master';
    }
    if (path != null) {
      newUrl = '$newUrl/$path';
    }
    return '$newUrl/pubspec.yaml';
  }

  String _getCleanedUpUrl(String hostName) {
    const wwwHttpsPrefix = 'https://www.';
    const httpPrefix = 'http://';
    const wwwHttpPrefix = 'http://www.';
    final gitPrefix = 'git@$hostName.com:';
    const gitPrefix2 = 'git://';
    const gitSuffix = '.git';
    var newUrl = url;
    if (newUrl.startsWith(wwwHttpsPrefix)) {
      newUrl = newUrl.replaceFirst(wwwHttpsPrefix, 'https://');
    }
    if (newUrl.startsWith(wwwHttpPrefix)) {
      newUrl = newUrl.replaceFirst(wwwHttpPrefix, 'https://');
    }
    if (newUrl.startsWith(httpPrefix)) {
      newUrl = newUrl.replaceFirst(httpPrefix, 'https://');
    }
    if (newUrl.startsWith(gitPrefix)) {
      newUrl = newUrl.replaceFirst(gitPrefix, 'https://$hostName.com/');
    }
    if (newUrl.startsWith(gitPrefix2)) {
      newUrl = newUrl.replaceFirst(gitPrefix2, 'https://');
    }
    if (newUrl.endsWith(gitSuffix)) {
      newUrl =
          newUrl.replaceFirst(gitSuffix, '', url.length - gitSuffix.length);
    }
    return newUrl;
  }

  String _replaceHostname(String url, String hostName, String rawUrl) {
    final hostNamePrefix = 'https://$hostName.com/';
    final wwwHostnamePrefix = 'https://www.$hostName.com/';
    var newUrl = url;
    if (newUrl.startsWith(hostNamePrefix)) {
      newUrl = newUrl.replaceFirst(hostNamePrefix, rawUrl);
    }
    if (newUrl.startsWith(wwwHostnamePrefix)) {
      newUrl = newUrl.replaceFirst(wwwHostnamePrefix, rawUrl);
    }
    return newUrl;
  }
}
