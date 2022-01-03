import 'package:test/test.dart';
import '../../bin/src/extension/github_extensions.dart';
import '../../bin/src/model/dto/dependency.dart';

void main() {
  group('Test isGithubUrl', () {
    group('normal', () {
      test('Test isGithubUrl with normal https', () {
        const url = 'https://github.com/vanlooverenkoen/test-repo';
        const gitInfo = GitInfo(url: url);
        expect(gitInfo.isGithubUrl(), true);
      });
      test('Test isGithubUrl with normal http', () {
        const url = 'http://github.com/vanlooverenkoen/test-repo';
        const gitInfo = GitInfo(url: url);
        expect(gitInfo.isGithubUrl(), true);
      });
      test('Test isGithubUrl with normal git', () {
        const url = 'git://github.com/vanlooverenkoen/test-repo';
        const gitInfo = GitInfo(url: url);
        expect(gitInfo.isGithubUrl(), true);
      });
      test('Test isGithubUrl with normal git', () {
        const url = 'git@github.com:vanlooverenkoen/test-repo';
        const gitInfo = GitInfo(url: url);
        expect(gitInfo.isGithubUrl(), true);
      });
    });
    group('www', () {
      test('Test isGithubUrl with normal https www', () {
        const url = 'https://www.github.com/vanlooverenkoen/test-repo';
        const gitInfo = GitInfo(url: url);
        expect(gitInfo.isGithubUrl(), true);
      });
      test('Test isGithubUrl with normal http www', () {
        const url = 'http://www.github.com/vanlooverenkoen/test-repo';
        const gitInfo = GitInfo(url: url);
        expect(gitInfo.isGithubUrl(), true);
      });
    });
  });

  group('Test getGithubPubSpecUrl', () {
    group('normal', () {
      test('Test getGithubPubSpecUrl with normal git repo', () {
        const gitInfo = GitInfo(
          url: 'git@github.com:vanlooverenkoen/test-repo.git',
        );
        expect(gitInfo.getGithubPubSpecUrl(), 'https://raw.githubusercontent.com/vanlooverenkoen/test-repo/master/pubspec.yaml');
      });
      test('Test getGithubPubSpecUrl with normal git repo with git://', () {
        const gitInfo = GitInfo(
          url: 'git://github.com/vanlooverenkoen/test-repo.git',
        );
        expect(gitInfo.getGithubPubSpecUrl(), 'https://raw.githubusercontent.com/vanlooverenkoen/test-repo/master/pubspec.yaml');
      });
      test('Test getGithubPubSpecUrl with normal git repo with git://', () {
        const gitInfo = GitInfo(
          url: 'git://www.github.com/vanlooverenkoen/test-repo.git',
        );
        expect(gitInfo.getGithubPubSpecUrl(), 'https://raw.githubusercontent.com/vanlooverenkoen/test-repo/master/pubspec.yaml');
      });
      test('Test getGithubPubSpecUrl without .git', () {
        const gitInfo = GitInfo(
          url: 'git@github.com:vanlooverenkoen/test-repo',
        );
        expect(gitInfo.getGithubPubSpecUrl(), 'https://raw.githubusercontent.com/vanlooverenkoen/test-repo/master/pubspec.yaml');
      });
      test('Test getGithubPubSpecUrl with https', () {
        const gitInfo = GitInfo(
          url: 'https://github.com/vanlooverenkoen/test-repo',
        );
        expect(gitInfo.getGithubPubSpecUrl(), 'https://raw.githubusercontent.com/vanlooverenkoen/test-repo/master/pubspec.yaml');
      });
      test('Test getGithubPubSpecUrl with http', () {
        const gitInfo = GitInfo(
          url: 'http://github.com/vanlooverenkoen/test-repo',
        );
        expect(gitInfo.getGithubPubSpecUrl(), 'https://raw.githubusercontent.com/vanlooverenkoen/test-repo/master/pubspec.yaml');
      });
    });
    group('www', () {
      test('Test getGithubPubSpecUrl with https', () {
        const gitInfo = GitInfo(
          url: 'https://www.github.com/vanlooverenkoen/test-repo',
        );
        expect(gitInfo.getGithubPubSpecUrl(), 'https://raw.githubusercontent.com/vanlooverenkoen/test-repo/master/pubspec.yaml');
      });
      test('Test getGithubPubSpecUrl with http', () {
        const gitInfo = GitInfo(
          url: 'http://www.github.com/vanlooverenkoen/test-repo',
        );
        expect(gitInfo.getGithubPubSpecUrl(), 'https://raw.githubusercontent.com/vanlooverenkoen/test-repo/master/pubspec.yaml');
      });
    });
    group('ref', () {
      test('Test getGithubPubSpecUrl with https', () {
        const gitInfo = GitInfo(
          url: 'https://github.com/vanlooverenkoen/test-repo',
          ref: '654dsf564dsf4ds5f6',
        );
        expect(gitInfo.getGithubPubSpecUrl(), 'https://raw.githubusercontent.com/vanlooverenkoen/test-repo/654dsf564dsf4ds5f6/pubspec.yaml');
      });
      test('Test getGithubPubSpecUrl with git', () {
        const gitInfo = GitInfo(
          url: 'git@github.com:vanlooverenkoen/test-repo.git',
          ref: '654dsf564dsf4ds5f6',
        );
        expect(gitInfo.getGithubPubSpecUrl(), 'https://raw.githubusercontent.com/vanlooverenkoen/test-repo/654dsf564dsf4ds5f6/pubspec.yaml');
      });
      test('Test getGithubPubSpecUrl without .git', () {
        const gitInfo = GitInfo(
          url: 'git@github.com:vanlooverenkoen/test-repo',
          ref: '654dsf564dsf4ds5f6',
        );
        expect(gitInfo.getGithubPubSpecUrl(), 'https://raw.githubusercontent.com/vanlooverenkoen/test-repo/654dsf564dsf4ds5f6/pubspec.yaml');
      });
    });
    group('path', () {
      test('Test getGithubPubSpecUrl with https', () {
        const gitInfo = GitInfo(
          url: 'https://github.com/vanlooverenkoen/test-repo',
          path: 'extra-path',
        );
        expect(gitInfo.getGithubPubSpecUrl(), 'https://raw.githubusercontent.com/vanlooverenkoen/test-repo/master/extra-path/pubspec.yaml');
      });
      test('Test getGithubPubSpecUrl with git', () {
        const gitInfo = GitInfo(
          url: 'git@github.com:vanlooverenkoen/test-repo.git',
          path: 'extra-path',
        );
        expect(gitInfo.getGithubPubSpecUrl(), 'https://raw.githubusercontent.com/vanlooverenkoen/test-repo/master/extra-path/pubspec.yaml');
      });
      test('Test getGithubPubSpecUrl without .git', () {
        const gitInfo = GitInfo(
          url: 'git@github.com:vanlooverenkoen/test-repo',
          path: 'extra-path',
        );
        expect(gitInfo.getGithubPubSpecUrl(), 'https://raw.githubusercontent.com/vanlooverenkoen/test-repo/master/extra-path/pubspec.yaml');
      });
    });
    group('ref and path', () {
      test('Test getGithubPubSpecUrl with https', () {
        const gitInfo = GitInfo(
          url: 'https://github.com/vanlooverenkoen/test-repo',
          path: 'extra-path',
          ref: '654dsf564dsf4ds5f6',
        );
        expect(gitInfo.getGithubPubSpecUrl(), 'https://raw.githubusercontent.com/vanlooverenkoen/test-repo/654dsf564dsf4ds5f6/extra-path/pubspec.yaml');
      });
      test('Test getGithubPubSpecUrl with git', () {
        const gitInfo = GitInfo(
          url: 'git@github.com:vanlooverenkoen/test-repo.git',
          path: 'extra-path',
          ref: '654dsf564dsf4ds5f6',
        );
        expect(gitInfo.getGithubPubSpecUrl(), 'https://raw.githubusercontent.com/vanlooverenkoen/test-repo/654dsf564dsf4ds5f6/extra-path/pubspec.yaml');
      });
      test('Test getGithubPubSpecUrl without .git', () {
        const gitInfo = GitInfo(
          url: 'git@github.com:vanlooverenkoen/test-repo',
          path: 'extra-path',
          ref: '654dsf564dsf4ds5f6',
        );
        expect(gitInfo.getGithubPubSpecUrl(), 'https://raw.githubusercontent.com/vanlooverenkoen/test-repo/654dsf564dsf4ds5f6/extra-path/pubspec.yaml');
      });
    });
  });
}
