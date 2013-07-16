Meteor.methods {
    generateDm: (options) ->
        return DmCreator.generateDm(options)
}

Meteor.startup ->
    fs = Npm.require('fs')
    fs.symlinkSync('../../../../tags', '.meteor/local/build/static/tags')
