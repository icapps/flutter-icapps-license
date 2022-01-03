import '../model/dto/dependency.dart';

extension StringExtensions on String {
  bool isGithubUrl() =>
      startsWith('https://github.com/') ||
      startsWith('https://www.github.com/') ||
      startsWith('http://github.com/') ||
      startsWith('http://www.github.com/') ||
      startsWith('git://github.com/') ||
      startsWith('git@github.com:');

  bool isGithubRawUrl() =>
      startsWith('https://raw.githubusercontent.com') ||
      startsWith('https://www.raw.githubusercontent.com') ||
      startsWith('http://raw.githubusercontent.com') ||
      startsWith('http://www.raw.githubusercontent.com');
}

extension GitInfoExtensions on GitInfo {
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
