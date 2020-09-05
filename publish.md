
```sh
# To find out whether the changes result in a patch, minor or major version change.
elm diff

# to update the docs
elm make --docs docs.json
gc -am'updated docs'

# to update the package version in elm.json
elm bump
gc -am'bumped version'

# tag the version
git tag -a 3.1.0

# push everything to github
git push origin master
git push origin 3.1.0

# publish!
elm publish
```

See also: https://korban.net/posts/elm/2018-10-02-basic-steps-publish-package-elm-19/



