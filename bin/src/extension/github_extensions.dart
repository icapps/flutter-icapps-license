import '../model/dto/dependency.dart';

extension GitInfoExtensions on GitInfo {
  bool isGithubUrl() =>
      url.startsWith('https://github.com/') ||
      url.startsWith('https://www.github.com/') ||
      url.startsWith('http://github.com/') ||
      url.startsWith('http://www.github.com/') ||
      url.startsWith('git://github.com/') ||
      url.startsWith('git@github.com:');

  String getGithubPubSpecUrl() {
    const rawGithubUrl = 'https://raw.githubusercontent.com/';
    const githubPrefix = 'https://github.com/';
    const wwwGithubPrefix = 'https://www.github.com/';
    const wwwHttpsPrefix = 'https://www.';
    const httpPrefix = 'http://';
    const wwwHttpPrefix = 'http://www.';
    const gitPrefix = 'git@github.com:';
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
      newUrl = newUrl.replaceFirst(gitPrefix, 'https://github.com/');
    }
    if (newUrl.startsWith(gitPrefix2)) {
      newUrl = newUrl.replaceFirst(gitPrefix2, 'https://');
    }
    if (newUrl.endsWith(gitSuffix)) {
      newUrl = newUrl.replaceFirst(gitSuffix, '', url.length - gitSuffix.length);
    }
    if (newUrl.startsWith(githubPrefix)) {
      newUrl = newUrl.replaceFirst(githubPrefix, rawGithubUrl);
    }
    if (newUrl.startsWith(wwwGithubPrefix)) {
      newUrl = newUrl.replaceFirst(wwwGithubPrefix, rawGithubUrl);
    }
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
