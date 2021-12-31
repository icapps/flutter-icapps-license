import '../model/dto/dependency.dart';

extension GitInfoExtensions on GitInfo {
  bool isGithubUrl() =>
      url.startsWith('https://github.com/') ||
      url.startsWith('https://www.github.com/') ||
      url.startsWith('http://github.com/') ||
      url.startsWith('http://www.github.com/') ||
      url.startsWith('git://github.com/') ||
      url.startsWith('git@github.com:') ||
      url.startsWith('https://raw.githubusercontent.com/') ||
      url.startsWith('http://raw.githubusercontent.com/');

  String getGithubPubSpecUrl() {
    const wwwHttpsPrefix = 'https://www.';
    const httpPrefix = 'http://';
    const wwwHttpPrefix = 'http://www.';
    const gitPrefix = 'git@github.com:';
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
      newUrl = newUrl.replaceFirst(gitPrefix, 'https://github.com/');
    }
    if (newUrl.endsWith(gitSuffix)) {
      newUrl = newUrl.replaceFirst(gitSuffix, '', url.length - gitSuffix.length);
    }
    newUrl = newUrl.replaceFirst('https://github.com/', 'https://raw.githubusercontent.com/');
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
}
