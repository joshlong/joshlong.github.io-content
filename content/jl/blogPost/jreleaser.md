title=Integrating JReleaser and going to infinity, and beyond!
date=2024-09-25
type=post
tags=blog
status=published
~~~~~~

here's an example of a project that has been setup to use JReleaser: https://github.com/joshlong/lucene-spring-boot-starter/blob/4557e5b70c56e1fc7b6ef3c0d14dd8d2c95ffc0d/jrelease.sh#L4-L3

- i had to setup an account with OSSRH https://s01.oss.sonatype.org (go there and geet an account. i have one called `joshlong`.)
	- setting up a namespace might take some DNS verification and some time so be prepared and start early. 
- i had to generate a gpg key and publush it somewhere. the process looks like this. make sure you have `gpg` installed on ur local machine. generate a new key.
	- `gpg --gen-key`. it'll ask you to specify a passphrase. *do not lose this passphrase*!
	- list the keys to discover the ID of the key you just made: `gpg --list-keys`
	- publish the key to a keyserver like this: `gpg --keyserver keys.openpgp.org  --send-keys <KEY_ID>`
- now you'll need some values to plugin JReleaser.
- **your github personal access token**. get this in the usual place - github profile → developer → personal access token.
- **your gpg passphrase** - get the passphrase from earlier. 
- your **nexus username** and **nexus password**. these are the credentials to access the sonatype nexus repository. confusingly, though, it is _not_ your username and password. instead, login, go to Profile, and choose the _profile_ tab. in the drop down, choose `User Token`. Choose to access your access token. It'll generate one if you don't already have it. Note the two values. The first is your username and the other your passphrase. If you're not using JReleaser, you'd put this value in `~/.m2/settings.xml`, like this:
```
<settings>
    <servers>
        <server>
            <id>ossrh</id>
            <username>AAAAAA</username>
            <password>BBBBBB</password>
        </server>
    </servers>
</settings>

```
- your **public gpg key**. you can get it using `gpg --export --armor __key-id__ ` 
- your **private gpg key**. you can get it using `gpg  --export-secret-keys --armor __key-id__`
- now you're ready to configure JReleaser. 
- add the following to the root of the project you're deploying to Maven Central. if it's a multi module Maven project with ten modules, put this in the root `pom.xml`.
```
<plugin>
 <groupId>org.jreleaser</groupId>
 <artifactId>jreleaser-maven-plugin</artifactId>
 <version>1.14.0</version>
 <configuration>
 <jreleaser>
 <release>
     <github>
     <branch>master</branch>
     </github>
 </release>
 <signing>
     <active>ALWAYS</active>
     <armored>true</armored>
     <mode>FILE</mode>
     <publicKey>${user.home}/.jreleaser/public</publicKey>
     <secretKey>${user.home}/.jreleaser/private</secretKey>
     </signing>
 <deploy>
     <maven>
         <nexus2>
             <maven-central>
                 <active>ALWAYS</active>
                 <url>https://s01.oss.sonatype.org/service/local</url>
                 <snapshotUrl>
                 https://s01.oss.sonatype.org/content/repositories/snapshots/
                 </snapshotUrl>
                 <closeRepository>true</closeRepository>
                 <releaseRepository>true</releaseRepository>
                 <stagingRepositories>target/staging-deploy</stagingRepositories>
             </maven-central>
         </nexus2>
     </maven>
 </deploy>
 </jreleaser>
 </configuration>
</plugin>
```

- Here's my entire `publish` profile in my maven build:
```
 <profiles>
        <profile>
            <id>publish</id>
            <properties>
                <altDeploymentRepository>local::file:./target/staging-deploy</altDeploymentRepository>
            </properties>
            <build>
                <plugins>
                    <plugin>
                        <groupId>org.apache.maven.plugins</groupId>
                        <artifactId>maven-source-plugin</artifactId>
                        <version>3.2.1</version>
                        <executions>
                            <execution>
                                <id>attach-sources</id>
                                <goals>
                                    <goal>jar-no-fork</goal>
                                </goals>
                            </execution>
                        </executions>
                    </plugin>
                    <plugin>
                        <groupId>org.apache.maven.plugins</groupId>
                        <artifactId>maven-javadoc-plugin</artifactId>
                        <version>3.3.1</version>
                        <executions>
                            <execution>
                                <id>attach-javadocs</id>
                                <goals>
                                    <goal>jar</goal>
                                </goals>
                            </execution>
                        </executions>
                    </plugin>
                    <plugin>
                        <groupId>org.jreleaser</groupId>
                        <artifactId>jreleaser-maven-plugin</artifactId>
                        <version>1.14.0</version>
                        <configuration>
                            <jreleaser>
                                <release>
                                    <github>
                                        <branch>master</branch>
                                    </github>
                                </release>
                                <signing>
                                    <active>ALWAYS</active>
                                    <armored>true</armored>
                                    <mode>FILE</mode>
                                    <publicKey>${user.home}/.jreleaser/public</publicKey>
                                    <secretKey>${user.home}/.jreleaser/private</secretKey>
                                </signing>
                                <deploy>
                                    <maven>
                                        <nexus2>
                                            <maven-central>
                                                <active>ALWAYS</active>
                                                <url>https://s01.oss.sonatype.org/service/local</url>
                                                <snapshotUrl>
                                                    https://s01.oss.sonatype.org/content/repositories/snapshots/
                                                </snapshotUrl>
                                                <closeRepository>true</closeRepository>
                                                <releaseRepository>true</releaseRepository>
                                                <stagingRepositories>target/staging-deploy</stagingRepositories>
                                            </maven-central>
                                        </nexus2>
                                    </maven>
                                </deploy>
                            </jreleaser>
                        </configuration>
                    </plugin>
                </plugins>
            </build>
        </profile>
    </profiles>
```

- in addition to that `profile`, i made sure that each `pom.xml` had: 
	- `developers`
	- `scm`
	- `licenses`
	- `inceptionYear`
	- `description`
	- `url`
	- `name`
- now you're ready to deploy your build. you have a few steps. 
- 1.) you're going to need some environment variables. `JRELEASER_GPG_PASSPHRASE`, `JRELEASER_GITHUB_TOKEN`, `JRELEASER_NEXUS2_USERNAME`, and `JRELEASER_NEXUS2_PASSWORD`. you'll also need to put the private key in `$HOME/.jreleaser/private`, and the public key in `$HOME/.jreleaser/public`. 
- 2.) you're going to need to set the release version. Here's some bash to do that:
```
echo "setting release version..."
mvn build-helper:parse-version versions:set \
 -DnewVersion=\${parsedVersion.majorVersion}.\${parsedVersion.minorVersion}.\${parsedVersion.incrementalVersion}
RELEASE_VERSION=$(mvn help:evaluate -Dexpression=project.version -q -DforceStdout)

echo "the release version is $RELEASE_VERSION "
echo "staging..."
mvn versions:commit # accept the release version
mvn -Ppublish clean deploy
git commit -am "releasing ${RELEASE_VERSION}" # release the main version
```
- 3.) do a dry run of the `mvn` release: `mvn -Ppublish jreleaser:deploy -Djreleaser.dry.run=true -N  `
	- if everything goes well, then you're ready to actually do a release.
- 4.) `mvn -Ppublish jreleaser:release -N`
- 5.) make sure you don't leave `$HOME/.jreleaser/{public,private}` laying around. Delete them.
- 6.) increment the version for the codebase to start work on the next release:
```
## INCREMENT VERSION NUMBER FOR THE NEXT SNAPSHOT.
mvn build-helper:parse-version versions:set \
 -DnewVersion=\${parsedVersion.majorVersion}.\${parsedVersion.minorVersion}.\${parsedVersion.nextIncrementalVersion}-SNAPSHOT
echo "the next snapshot version is $(mvn help:evaluate -Dexpression=project.version -q -DforceStdout) "
mvn versions:commit
SNAPSHOT_VERSION=$(mvn help:evaluate -Dexpression=project.version -q -DforceStdout)
git commit -am "moving to $SNAPSHOT_VERSION"
git push
```

Congrats! you now should have a working project deployed to Maven Central. Give it ten or so minutes before you try pulling the dependency specified in another `pom.xml`. Give it a few hours before you expect to see the result in mvnrepository.com or other such indexes.

Oh, by the way: JReleaser also created a Github Package for the release, too! Nice. 

## Changelog
- 2024-09-25 14:51:11 - huge thanks to Andres Almiray, creator of JReleaser, for all the amazing help and the awesome project! 