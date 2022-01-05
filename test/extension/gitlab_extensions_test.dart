import 'package:test/test.dart';
import '../../bin/src/extension/git_extensions.dart';
import '../../bin/src/model/dto/dependency.dart';

void main() {
  group('Test isGitLabUrl', () {
    group('normal', () {
      test('Test isGitLabUrl with normal https', () {
        const url = 'https://gitlab.com/vanlooverenkoen/company/frontend/flutter-app';
        const gitInfo = GitInfo(url: url);
        expect(gitInfo.url.isGitLabUrl(), true);
      });
      test('Test isGitLabUrl with normal http', () {
        const url = 'http://gitlab.com/vanlooverenkoen/company/frontend/flutter-app';
        const gitInfo = GitInfo(url: url);
        expect(gitInfo.url.isGitLabUrl(), true);
      });
      test('Test isGitLabUrl with normal git', () {
        const url = 'git://gitlab.com/vanlooverenkoen/company/frontend/flutter-app';
        const gitInfo = GitInfo(url: url);
        expect(gitInfo.url.isGitLabUrl(), true);
      });
      test('Test isGitLabUrl with normal git', () {
        const url = 'git@gitlab.com:vanlooverenkoen/company/frontend/flutter-app';
        const gitInfo = GitInfo(url: url);
        expect(gitInfo.url.isGitLabUrl(), true);
      });
    });
    group('www', () {
      test('Test isGitLabUrl with normal https www', () {
        const url = 'https://www.gitlab.com/vanlooverenkoen/company/frontend/flutter-app';
        const gitInfo = GitInfo(url: url);
        expect(gitInfo.url.isGitLabUrl(), true);
      });
      test('Test isGitLabUrl with normal http www', () {
        const url = 'http://www.gitlab.com/vanlooverenkoen/company/frontend/flutter-app';
        const gitInfo = GitInfo(url: url);
        expect(gitInfo.url.isGitLabUrl(), true);
      });
    });
  });

  group('Test getGitLabPubSpecUrl', () {
    group('normal', () {
      test('Test getGitLabPubSpecUrl with normal git repo', () {
        const gitInfo = GitInfo(
          url: 'git@gitlab.com:vanlooverenkoen/company/frontend/flutter-app.git',
        );
        expect(gitInfo.getGitLabPubSpecUrl(), 'https://gitlab.com/vanlooverenkoen/company/frontend/flutter-app/-/raw/master/pubspec.yaml');
      });
      test('Test getGitLabPubSpecUrl with normal git repo with git://', () {
        const gitInfo = GitInfo(
          url: 'git://gitlab.com/vanlooverenkoen/company/frontend/flutter-app.git',
        );
        expect(gitInfo.getGitLabPubSpecUrl(), 'https://gitlab.com/vanlooverenkoen/company/frontend/flutter-app/-/raw/master/pubspec.yaml');
      });
      test('Test getGitLabPubSpecUrl with normal git repo with git://', () {
        const gitInfo = GitInfo(
          url: 'git://www.gitlab.com/vanlooverenkoen/company/frontend/flutter-app.git',
        );
        expect(gitInfo.getGitLabPubSpecUrl(), 'https://www.gitlab.com/vanlooverenkoen/company/frontend/flutter-app/-/raw/master/pubspec.yaml');
      });
      test('Test getGitLabPubSpecUrl without .git', () {
        const gitInfo = GitInfo(
          url: 'git@gitlab.com:vanlooverenkoen/company/frontend/flutter-app',
        );
        expect(gitInfo.getGitLabPubSpecUrl(), 'https://gitlab.com/vanlooverenkoen/company/frontend/flutter-app/-/raw/master/pubspec.yaml');
      });
      test('Test getGitLabPubSpecUrl with https', () {
        const gitInfo = GitInfo(
          url: 'https://gitlab.com/vanlooverenkoen/company/frontend/flutter-app',
        );
        expect(gitInfo.getGitLabPubSpecUrl(), 'https://gitlab.com/vanlooverenkoen/company/frontend/flutter-app/-/raw/master/pubspec.yaml');
      });
      test('Test getGitLabPubSpecUrl with http', () {
        const gitInfo = GitInfo(
          url: 'http://gitlab.com/vanlooverenkoen/company/frontend/flutter-app',
        );
        expect(gitInfo.getGitLabPubSpecUrl(), 'https://gitlab.com/vanlooverenkoen/company/frontend/flutter-app/-/raw/master/pubspec.yaml');
      });
    });
    group('www', () {
      test('Test getGitLabPubSpecUrl with https', () {
        const gitInfo = GitInfo(
          url: 'https://www.gitlab.com/vanlooverenkoen/company/frontend/flutter-app',
        );
        expect(gitInfo.getGitLabPubSpecUrl(), 'https://gitlab.com/vanlooverenkoen/company/frontend/flutter-app/-/raw/master/pubspec.yaml');
      });
      test('Test getGitLabPubSpecUrl with http', () {
        const gitInfo = GitInfo(
          url: 'http://www.gitlab.com/vanlooverenkoen/company/frontend/flutter-app',
        );
        expect(gitInfo.getGitLabPubSpecUrl(), 'https://gitlab.com/vanlooverenkoen/company/frontend/flutter-app/-/raw/master/pubspec.yaml');
      });
    });
    group('ref', () {
      test('Test getGitLabPubSpecUrl with https', () {
        const gitInfo = GitInfo(
          url: 'https://gitlab.com/vanlooverenkoen/company/frontend/flutter-app',
          ref: '654dsf564dsf4ds5f6',
        );
        expect(gitInfo.getGitLabPubSpecUrl(), 'https://gitlab.com/vanlooverenkoen/company/frontend/flutter-app/-/raw/654dsf564dsf4ds5f6/pubspec.yaml');
      });
      test('Test getGitLabPubSpecUrl with git', () {
        const gitInfo = GitInfo(
          url: 'git@gitlab.com:vanlooverenkoen/company/frontend/flutter-app.git',
          ref: '654dsf564dsf4ds5f6',
        );
        expect(gitInfo.getGitLabPubSpecUrl(), 'https://gitlab.com/vanlooverenkoen/company/frontend/flutter-app/-/raw/654dsf564dsf4ds5f6/pubspec.yaml');
      });
      test('Test getGitLabPubSpecUrl without .git', () {
        const gitInfo = GitInfo(
          url: 'git@gitlab.com:vanlooverenkoen/company/frontend/flutter-app',
          ref: '654dsf564dsf4ds5f6',
        );
        expect(gitInfo.getGitLabPubSpecUrl(), 'https://gitlab.com/vanlooverenkoen/company/frontend/flutter-app/-/raw/654dsf564dsf4ds5f6/pubspec.yaml');
      });
    });
    group('path', () {
      test('Test getGitLabPubSpecUrl with https', () {
        const gitInfo = GitInfo(
          url: 'https://gitlab.com/vanlooverenkoen/company/frontend/flutter-app',
          path: 'extra-path',
        );
        expect(gitInfo.getGitLabPubSpecUrl(), 'https://gitlab.com/vanlooverenkoen/company/frontend/flutter-app/-/raw/master/extra-path/pubspec.yaml');
      });
      test('Test getGitLabPubSpecUrl with git', () {
        const gitInfo = GitInfo(
          url: 'git@gitlab.com:vanlooverenkoen/company/frontend/flutter-app.git',
          path: 'extra-path',
        );
        expect(gitInfo.getGitLabPubSpecUrl(), 'https://gitlab.com/vanlooverenkoen/company/frontend/flutter-app/-/raw/master/extra-path/pubspec.yaml');
      });
      test('Test getGitLabPubSpecUrl without .git', () {
        const gitInfo = GitInfo(
          url: 'git@gitlab.com:vanlooverenkoen/company/frontend/flutter-app',
          path: 'extra-path',
        );
        expect(gitInfo.getGitLabPubSpecUrl(), 'https://gitlab.com/vanlooverenkoen/company/frontend/flutter-app/-/raw/master/extra-path/pubspec.yaml');
      });
    });
    group('ref and path', () {
      test('Test getGitLabPubSpecUrl with https', () {
        const gitInfo = GitInfo(
          url: 'https://gitlab.com/vanlooverenkoen/company/frontend/flutter-app',
          path: 'extra-path',
          ref: '654dsf564dsf4ds5f6',
        );
        expect(gitInfo.getGitLabPubSpecUrl(), 'https://gitlab.com/vanlooverenkoen/company/frontend/flutter-app/-/raw/654dsf564dsf4ds5f6/extra-path/pubspec.yaml');
      });
      test('Test getGitLabPubSpecUrl with git', () {
        const gitInfo = GitInfo(
          url: 'git@gitlab.com:vanlooverenkoen/company/frontend/flutter-app.git',
          path: 'extra-path',
          ref: '654dsf564dsf4ds5f6',
        );
        expect(gitInfo.getGitLabPubSpecUrl(), 'https://gitlab.com/vanlooverenkoen/company/frontend/flutter-app/-/raw/654dsf564dsf4ds5f6/extra-path/pubspec.yaml');
      });
      test('Test getGitLabPubSpecUrl without .git', () {
        const gitInfo = GitInfo(
          url: 'git@gitlab.com:vanlooverenkoen/company/frontend/flutter-app',
          path: 'extra-path',
          ref: '654dsf564dsf4ds5f6',
        );
        expect(gitInfo.getGitLabPubSpecUrl(), 'https://gitlab.com/vanlooverenkoen/company/frontend/flutter-app/-/raw/654dsf564dsf4ds5f6/extra-path/pubspec.yaml');
      });
    });
  });
}
