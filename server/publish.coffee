# Users
Meteor.publish 'userData', ->
    Meteor.users.find {_id:this.userId},
        {fields: {admin:1}}

# Lang
@Lang = new Meteor.Collection('lang')
Meteor.publish 'lang', -> Lang.find {}

Lang.allow {
    insert: (userId, doc) ->
        userId and Meteor.user().admin
    update: (userId, doc) ->
        userId and Meteor.user().admin
    remove: (userId, doc) ->
        userId and Meteor.user().admin
}

# Activities
@Activities = new Meteor.Collection('activities')

Meteor.publish 'activities', -> Activities.find()

# Custom activities
@CustomActivities = new Meteor.Collection('customActivities')

Meteor.publish 'customActivities', (activity_id) ->
    check activity_id, String
    return CustomActivities.find {
            user_id: this.userId
            activity_id: activity_id
        }

CustomActivities.allow {
    insert: (userId, doc) ->
        userId and (doc.user_id is userId)
    update: (userId, doc, fieldNames, modifier) ->
        userId and (doc.user_id is userId)
    remove: (userId, doc) ->
        userId and (doc.user_id is userId)
}
