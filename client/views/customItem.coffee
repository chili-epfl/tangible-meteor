Template.customItem.lang = (e) -> Session.get 'lang'
Template.customItem.events {
    'click .destroy': (e) ->
        e.stopPropagation()
        CustomActivities.remove(this._id)
    'click .custom': (e) ->
        e.preventDefault()
        Session.set 'custom_id', this._id
}
