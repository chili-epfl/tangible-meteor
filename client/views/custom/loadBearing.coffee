log = (txt) -> console.log 'load-bearing: '+txt

utils = myTinker.utils
db = myTinker.customActivities

# default session values
Session.setDefault('editing_width', null)
Session.setDefault('editing_length', null)
Session.setDefault('editing_maxLoad', null)
Session.setDefault('editing_palletMass', null)

Template.customLoadBearing.lang = (e) -> Session.get 'lang'
Template.customLoadBearing.loading = -> db.loading()

# loadBearingStorage
Template.loadBearingStorage.lang = (e) -> Session.get 'lang'

Template.loadBearingStorage.storageWidth = -> db.getOrAddField('storageWidth', 1000)
Template.loadBearingStorage.storageLength = -> db.getOrAddField('storageLength', 1000)
Template.loadBearingStorage.maxLoad = -> db.getOrAddField('maxLoad', 10000)

Template.loadBearingStorage.editingWidth = -> Session.get 'editing_width'
Template.loadBearingStorage.editingLength = -> Session.get 'editing_length'
Template.loadBearingStorage.editingMaxLoad = -> Session.get 'editing_maxLoad'

Template.loadBearingStorage.events utils.okCancelEvents('#width-input', {
    ok: (value) ->
        db.updateField 'storageWidth', value
        Session.set 'editing_width', null
    cancel: ->
        Session.set 'editing_width', null
})

Template.loadBearingStorage.events utils.okCancelEvents('#length-input', {
    ok: (value) ->
        db.updateField 'storageLength', value
        Session.set 'editing_length', null
    cancel: ->
        Session.set 'editing_length', null
})

Template.loadBearingStorage.events utils.okCancelEvents('#maxLoad-input', {
    ok: (value) ->
        db.updateField 'maxLoad', value
        Session.set 'editing_maxLoad', null
    cancel: ->
        Session.set 'editing_maxLoad', null
})

Template.loadBearingStorage.events {
    'click .editableWidth': (e,tmpl) ->
        e.preventDefault()
        Session.set 'editing_width', true
        Deps.flush()
        utils.activateInput(tmpl.find("#width-input"))
    'click .editableLength': (e,tmpl) ->
        e.preventDefault()
        Session.set 'editing_length', true
        Deps.flush()
        utils.activateInput(tmpl.find("#length-input"))
    'click .editableMaxLoad': (e,tmpl) ->
        e.preventDefault()
        Session.set 'editing_maxLoad', true
        Deps.flush()
        utils.activateInput(tmpl.find("#maxLoad-input"))
}

# loadBearing pallets
Template.loadBearingPallets.pallets = ->
    data = db.getData()
    if data?
        if not data.pallets?
            pallets = []
            for i in [0...15] then pallets.push {number:i,mass:100}
            CustomActivities.update(data._id, {$set: {pallets:pallets}})
        return data.pallets
    else return {}

# loadBearing pallet
Template.loadBearingPallet.editingPalletMass = -> Session.equals('editing_palletMass', this.number)

Template.loadBearingPallet.mass = ->
    this.mass

Template.loadBearingPallet.events utils.okCancelEvents('#palletMass-input', {
    ok: (value) ->
        data = db.getData()
        if data?
            field = {}
            field['pallets.'+this.number+'.mass'] = value
            CustomActivities.update(data._id, {$set: field})
        Session.set 'editing_palletMass', null
    cancel: ->
        Session.set 'editing_palletMass', null
})

Template.loadBearingPallet.events {
    'click .editable_palletMass': (e,tmpl) ->
        e.preventDefault()
        Session.set 'editing_palletMass', this.number
        Deps.flush()
        utils.activateInput(tmpl.find('#palletMass-input'))
}

# loadBearing done
Template.loadBearingDone.lang = (e) -> Session.get 'lang'

Template.loadBearingDone.events {
    'click .generatePDF': (e) ->
        e.preventDefault()
        generatePDF()
}

generatePDF = ->
    data = db.getData()
    return if not data?

    txt = 'act="loadBearing";'
    txt += 'area=['+data.storageWidth+','+data.storageLength+','+data.maxLoad+'];'
    txt += 'p=['
    for p,i in data.pallets
        if i isnt 0 then txt += ','
        txt += p.mass
    txt += '];'

    lang = Session.get 'lang'
    pdf = myTinker.pdfCreator()
    pdf.generate {
        dmText:txt
        title:lang['LoadBearing']
        description:data.description
        username: Meteor.user()?.username
        filename:lang['LoadBearing']
    }
