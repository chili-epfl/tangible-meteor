db = myTinker.customActivities

Template.customActivityDescription.lang = (e) -> Session.get 'lang'
Template.customActivityDescription.description = -> db.getOrAddField 'description',''
Template.customActivityDescription.events {
    'blur #descriptionInput': (e) ->
        e.preventDefault()
        val = e.currentTarget.value
        db.updateField 'description', val
}
