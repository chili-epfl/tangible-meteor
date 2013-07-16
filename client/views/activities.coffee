activitiesHandle = Meteor.subscribe 'activities', ->
    if !Session.get('activity_id')
        activity = Activities.findOne {}
        if activity then Session.set 'activity_id', activity._id

Template.activities.lang = -> Session.get 'lang'

Template.activities.displayName = ->
    (Session.get('lang'))[this.name]

Template.activities.loading = ->
    return not activitiesHandle.ready()

Template.activities.activities = -> Activities.find({})

Template.activities.events {
    'mousedown .activity': (e) ->
        e.preventDefault()
        Session.set 'custom_id', null
        Session.set 'activity_id', this._id
    'click .activity': (e) -> e.preventDefault()
}

Template.activities.selected = ->
    if Session.equals('activity_id', this._id) then return 'selected' else ''

