Template.customActivities.lang = -> Session.get 'lang'

Template.customActivities.loading = ->
    return customHandle? and not customHandle.ready()

Template.customActivities.displayName = ->
    (Session.get('lang'))[this.name]

Template.customActivities.events myTinker.utils.okCancelEvents('#new-custom', {
    ok: (text, e) ->
        CustomActivities.insert {
            name: text
            user_id: Meteor.userId()
            activity_id: Session.get('activity_id')
            timestamp: (new Date()).getTime()
            description: ''
        }
        e.target.value = ''
})

Template.customActivities.customActivities = ->
    activity_id = Session.get 'activity_id'
    if activity_id? then CustomActivities.find({activity_id:activity_id}) else {}
