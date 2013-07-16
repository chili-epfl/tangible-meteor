@myTinker ?= {}
myTinker.customActivities = {}

customHandle = null
Deps.autorun ->
    id = Session.get 'custom_id'
    if id? then customHandle = Meteor.subscribe('customActivities', id)
    else customHandle = null

myTinker.customActivities.loading = ->
    customHandle? and not customHandle.ready()

myTinker.customActivities.getData = ->
    id = Session.get 'custom_id'
    CustomActivities.findOne {_id:id}

myTinker.customActivities.updateField = (fieldName,value) ->
    data = myTinker.customActivities.getData()
    if data?
        field = {}
        field[fieldName] = value
        CustomActivities.update(data._id, {$set: field})

myTinker.customActivities.getOrAddField = (fieldName, defaultValue=null) ->
    data = myTinker.customActivities.getData()
    if data?
        if not data[fieldName]?
            myTinker.customActivities.updateField fieldName, defaultValue
        return data[fieldName]
    return null

myTinker.customActivities.push = (fieldName, value) ->
    data = myTinker.customActivities.getData()
    if data?
        field = {}
        field[fieldName] = value
        CustomActivities.update(data._id, {$push: field})

myTinker.customActivities.pull = (fieldName, value) ->
    data = myTinker.customActivities.getData()
    if data?
        field = {}
        field[fieldName] = value
        CustomActivities.update(data._id, {$pull: field})
