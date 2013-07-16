@Activities = new Meteor.Collection 'activities'
@CustomActivities = new Meteor.Collection 'customActivities'

Session.setDefault 'activity_id', null
Session.setDefault 'custom_id', null

@customHandle = null
Deps.autorun ->
    activity_id = Session.get 'activity_id'
    if activity_id?
        customHandle = Meteor.subscribe('customActivities', activity_id)
    else
        customHandle = null

# create
Template.create.any_activity_selected = ->
    return not Session.equals('activity_id', null)

Template.create.activity_selected = ->
    id = Session.get('activity_id')
    Activities.findOne {_id:id}

Template.create.any_custom_selected = ->
    return not Session.equals('custom_id', null)

Template.create.custom_selected = ->
    id = Session.get 'custom_id'
    CustomActivities.findOne {_id:id}

Template.create.activityDisplayName = ->
    id = Session.get 'activity_id'
    data = Activities.findOne {_id:id}
    if data? then (Session.get 'lang')[data.name]
    else ''

Template.customEditor.editor = ->
    activity_id = Session.get('activity_id')
    custom_id = Session.get('custom_id')
    activity = Activities.findOne {_id:activity_id}
    if activity_id? and custom_id? and activity?
        templateName = 'custom'+activity.name
        if Template[templateName]?
            return Template[templateName]()
