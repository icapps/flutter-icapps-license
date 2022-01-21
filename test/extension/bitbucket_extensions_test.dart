import 'package:test/test.dart';

import '../../bin/src/extension/git_extensions.dart';
import '../../bin/src/model/dto/dependency.dart';

void main() {
  group('Test isBitbucketUrl', () {
    group('normal', () {
      test('Test isBitbucketUrl with normal https', () {
        const url = 'https://vanlooverenkoen@bitbucket.org/vanlooverenkoen/test-repo';
        const gitInfo = GitInfo(url: url);
        expect(gitInfo.url.isBitbucketUrl(), true);
      });
      test('Test isBitbucketUrl with normal http', () {
        const url = 'http://vanlooverenkoen@bitbucket.org/vanlooverenkoen/test-repo';
        const gitInfo = GitInfo(url: url);
        expect(gitInfo.url.isBitbucketUrl(), true);
      });
      test('Test isBitbucketUrl with normal git', () {
        const url = 'git@bitbucket.org:vanlooverenkoen/test-repo';
        const gitInfo = GitInfo(url: url);
        expect(gitInfo.url.isBitbucketUrl(), true);
      });
    });
    group('www', () {
      test('Test isBitbucketUrl with normal https www', () {
        const url = 'https://www.vanlooverenkoen@bitbucket.org/vanlooverenkoen/test-repo';
        const gitInfo = GitInfo(url: url);
        expect(gitInfo.url.isBitbucketUrl(), true);
      });
      test('Test isBitbucketUrl with normal http www', () {
        const url = 'http://www.vanlooverenkoen@bitbucket.org/vanlooverenkoen/test-repo';
        const gitInfo = GitInfo(url: url);
        expect(gitInfo.url.isBitbucketUrl(), true);
      });
    });
  });

  group('Test getBitbucketPubSpecUrl', () {
    group('normal', () {
      test('Test getBitbucketPubSpecUrl with normal git repo', () {
        const gitInfo = GitInfo(
          url: 'git@bitbucket.org:vanlooverenkoen/test-repo.git',
          ref: "ref",
        );
        expect(gitInfo.getBitbucketPubSpecUrl(),
            'https://bitbucket.org/vanlooverenkoen/test-repo/raw/ref/pubspec.yaml');
      });
      test('Test getBitbucketPubSpecUrl without .git', () {
        const gitInfo = GitInfo(
          url: 'git@bitbucket.org:vanlooverenkoen/test-repo',
          ref: "ref",
        );
        expect(gitInfo.getBitbucketPubSpecUrl(),
            'https://bitbucket.org/vanlooverenkoen/test-repo/raw/ref/pubspec.yaml');
      });
      test('Test getBitbucketPubSpecUrl with http', () {
        const gitInfo = GitInfo(
          url: 'http://git@bitbucket.org/vanlooverenkoen/test-repo.git',
          ref: "ref",
        );
        expect(gitInfo.getBitbucketPubSpecUrl(),
            'https://bitbucket.org/vanlooverenkoen/test-repo/raw/ref/pubspec.yaml');
      });
      test('Test getBitbucketPubSpecUrl with https', () {
        const gitInfo = GitInfo(
          url: 'https://git@bitbucket.org/vanlooverenkoen/test-repo.git',
          ref: "ref",
        );
        expect(gitInfo.getBitbucketPubSpecUrl(),
            'https://bitbucket.org/vanlooverenkoen/test-repo/raw/ref/pubspec.yaml');
      });
    });
    group('www', () {
      test('Test getBitbucketPubSpecUrl with https', () {
        const gitInfo = GitInfo(
          url: 'https://www.git@bitbucket.org/vanlooverenkoen/test-repo.git',
          ref: "ref",
        );
        expect(gitInfo.getBitbucketPubSpecUrl(),
            'https://bitbucket.org/vanlooverenkoen/test-repo/raw/ref/pubspec.yaml');
      });
      test('Test getBitbucketPubSpecUrl with http', () {
        const gitInfo = GitInfo(
          url: 'http://www.git@bitbucket.org/vanlooverenkoen/test-repo.git',
          ref: "ref",
        );
        expect(gitInfo.getBitbucketPubSpecUrl(),
            'https://bitbucket.org/vanlooverenkoen/test-repo/raw/ref/pubspec.yaml');
      });
    });
    group('path', () {
      test('Test getBitbucketPubSpecUrl with https', () {
        const gitInfo = GitInfo(
          url: 'https://git@bitbucket.org/vanlooverenkoen/test-repo.git',
          ref: "ref",
          path: "extra-path"
        );
        expect(gitInfo.getBitbucketPubSpecUrl(),
            'https://bitbucket.org/vanlooverenkoen/test-repo/raw/ref/extra-path/pubspec.yaml');
      });
    });
  });
}