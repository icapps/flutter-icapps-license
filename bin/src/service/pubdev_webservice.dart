import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart';
import 'package:yaml/yaml.dart';

import '../extension/github_extensions.dart';
import '../model/dto/dependency.dart';
import '../model/dto/dependency_lock.dart';
import '../model/webservice/pub_dev_package.dart';
import '../model/webservice/pub_dev_pubspec.dart';
import '../util/logger.dart';

@immutable
class PubDevWebservice {
  static const _pubDevBaseUrl = 'https://pub.dev';
  static String _baseUrl = _pubDevBaseUrl;

  const PubDevWebservice._();

  static void setBaseUrl(String? baseUrlOverride) {
    _baseUrl = baseUrlOverride ?? _pubDevBaseUrl;
  }

  static Future<PubDevPackage?> getPubDevData(Dependency dependency, DependencyLock lockedDependency) async {
    try {
      final version = lockedDependency.version;
      final url = '$_baseUrl/api/packages/${dependency.name}/versions/$version';
      Logger.logVerbose('Downloading: $url');
      final result = await get(Uri.parse(url));
      if (result.statusCode != 200) {
        Logger.logVerbose('Downloading failed: ${result.body}');
        throw Exception('Failed to get $url');
      }
      Logger.logVerbose('Downloading complete: $url');
      final json = jsonDecode(result.body) as Map<String, dynamic>;
      return PubDevPackage.fromJson(json);
    } catch (e) {
      if (dependency.isLocalDependency) {
        return _getLocalPubDevData(dependency);
      } else if (dependency.isGitDependency) {
        return _getGitPubDevData(dependency);
      }
      rethrow;
    }
  }

  static Future<PubDevPackage?> _getLocalPubDevData(Dependency dependency) async {
    final localPath = dependency.localPath;
    if (!dependency.isLocalDependency || localPath == null) return null;
    Logger.logInfo('Fetching pub dev info from local dependency. (Because we were not able to fetch the detail from pub.dev for ${dependency.name})');
    final file = File(join(localPath, 'pubspec.yaml'));
    final content = file.readAsStringSync();
    final yaml = loadYaml(content) as YamlMap;
    return PubDevPackage(
      pubspec: PubDevPubSpec(
        name: yaml['name'] as String,
        version: yaml['version'] as String,
        repository: yaml['repository'] as String?,
        homepage: yaml['homepage'] as String?,
      ),
    );
  }

  static Future<PubDevPackage?> _getGitPubDevData(Dependency dependency) async {
    final gitInfo = dependency.gitPath;
    if (!dependency.isGitDependency || gitInfo == null) return null;
    Logger.logInfo('Fetching pub dev info from git dependency. (Because we were not able to fetch the detail from pub.dev for ${dependency.name})');
    String? url;
    if (gitInfo.isGithubUrl()) {
      url = gitInfo.getGithubPubSpecUrl();
    }
    if (url == null) {
      throw Exception('This git url is not yet supported: $url. Create an issue so we can make this plugin better. (https://github.com/icapps/flutter-icapps-license/issues)');
    }
    final result = await get(Uri.parse(url));
    Logger.logVerbose('Downloading: $url');
    if (result.statusCode != 200) {
      Logger.logVerbose('Downloading failed: ${result.body}');
      throw Exception('Failed to get $url');
    }
    final content = result.body;
    final yaml = loadYaml(content) as YamlMap;
    return PubDevPackage(
      pubspec: PubDevPubSpec(
        name: yaml['name'] as String,
        version: yaml['version'] as String,
        repository: yaml['repository'] as String?,
        homepage: yaml['homepage'] as String?,
      ),
    );
  }
}
