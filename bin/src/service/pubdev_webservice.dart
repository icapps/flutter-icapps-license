import 'dart:convert';
import 'dart:io';

import 'package:meta/meta.dart';
import 'package:path/path.dart';
import 'package:yaml/yaml.dart';

import '../extension/git_extensions.dart';
import '../model/dto/dependency.dart';
import '../model/dto/dependency_lock.dart';
import '../model/exception/fatal_exception.dart';
import '../model/webservice/pub_dev_package.dart';
import '../model/webservice/pub_dev_pubspec.dart';
import '../util/logger.dart';
import 'webservice.dart';

@immutable
class PubDevWebservice {
  static const defaultPubDevBaseUrl = 'https://pub.dev';
  final String baseUrl;
  final WebService webservice;

  const PubDevWebservice({
    required this.webservice,
    this.baseUrl = defaultPubDevBaseUrl,
  });

  Future<PubDevPackage?> getPubDevData(Dependency dependency, DependencyLock lockedDependency) async {
    try {
      final version = lockedDependency.version;
      final url = '$baseUrl/api/packages/${dependency.name}/versions/$version';
      final jsonString = await webservice.get(url);
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
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

  Future<PubDevPackage?> _getLocalPubDevData(Dependency dependency) async {
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

  Future<PubDevPackage?> _getGitPubDevData(Dependency dependency) async {
    final gitInfo = dependency.gitPath;
    if (!dependency.isGitDependency || gitInfo == null) return null;
    Logger.logInfo('Fetching pub dev info from git dependency. (Because we were not able to fetch the detail from pub.dev for ${dependency.name})');
    String? url;
    if (gitInfo.url.isGithubUrl()) {
      url = gitInfo.getGithubPubSpecUrl();
    } else if (gitInfo.url.isGitLabUrl()) {
      url = gitInfo.getGitLabPubSpecUrl();
    }
    if (url == null) {
      throw FatalException(
          'This git url is not yet supported: ${gitInfo.url}. Create an issue so we can make this plugin better. (https://github.com/icapps/flutter-icapps-license/issues)');
    }
    final yamlString = await webservice.get(url);
    final yaml = loadYaml(yamlString) as YamlMap;
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
