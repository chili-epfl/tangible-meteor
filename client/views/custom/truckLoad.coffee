log = (txt) -> console.log 'truckLoad: '+txt

utils = myTinker.utils
db = myTinker.customActivities

Session.setDefault('truckLoad_editing_mass', null)
Session.setDefault('truckLoad_editing_delivery', null)
Session.setDefault 'truckLoad_editing_length', true

# Custom TruckLoad
Template.customTruckLoad.lang = (e) -> Session.get 'lang'

Template.customTruckLoad.loading = -> db.loading()

Template.customTruckLoad.isTypeTruck = ->
    db.getOrAddField('loadType', 'truck') is 'truck'

defaultPalletsValue = (->
    pallets = []
    for i in [0...15] then pallets.push {number:i,mass:100,delivery:1}
    pallets
)()

Template.customTruckLoad.pallets = ->
    db.getOrAddField 'pallets', defaultPalletsValue

Template.customTruckLoad.amountPallets = ->
    data = db.getData()
    if data? and data.pallets? then data.pallets.length else 0

Template.customTruckLoad.events {
    'click .generatePDF': (e,tmpl) ->
        e.preventDefault()
        generatePDF(tmpl)
    'click #typeRadioTruck': (e,tmpl) ->
        e.preventDefault()
        db.updateField 'loadType', 'truck'
    'click #typeRadioWagon': (e,tmpl) ->
        e.preventDefault()
        db.updateField 'loadType', 'wagon'
}

generatePDF = (tmpl) ->
    data = db.getData()
    if data?
        txt = 'act="truckLoad";'
        # activity type
        txt += 'type="'+data.loadType+'";'
        # mass
        txt += 'mass=['
        if data?
            total = data.pallets.length
            for p,i in data.pallets
                txt += p.mass
                if i isnt total-1 then txt += ','
        txt += '];'
        # delivery
        txt += 'delivery=['
        if data?
            total = data.pallets.length
            for p,i in data.pallets
                txt += p.delivery
                if i isnt total-1 then txt += ','
        txt += '];'
        # length
        txt += 'length='+data.vehicleLength+';'

        pdf = myTinker.pdfCreator()
        pdf.generate {
            dmText: txt
            title: 'TruckLoad - '+data.name
            description: data.description
            username: Meteor.user()?.username
            filename: 'truckload'
        }

Template.customTruckLoad.vehicleLength = ->
    db.getOrAddField('vehicleLength', 2000) ? 0

Template.customTruckLoad.editingLength = ->
    Session.get 'truckLoad_editing_length'

Template.customTruckLoad.events {
    'click .editable_length': (e,tmpl) ->
        e.preventDefault()
        Session.set 'truckLoad_editing_length', true
        Deps.flush()
        utils.activateInput(tmpl.find('#length-input'))
}

Template.customTruckLoad.events utils.okCancelEvents('#length-input', {
    ok: (value) ->
        checkedVal = Math.min(Math.max(2000,value),7000)
        db.updateField 'vehicleLength', checkedVal
        Session.set 'truckLoad_editing_length', false
    cancel: ->
        Session.set 'truckLoad_editing_length', false
})

# truckLoadPallet
Template.truckLoadPallet.editingMass = ->
    Session.equals('truckLoad_editing_mass', this.number)

Template.truckLoadPallet.editingDelivery = ->
    Session.equals('truckLoad_editing_delivery', this.number)

Template.truckLoadPallet.events {
    'click .editable_mass': (e, tmpl) ->
        e.preventDefault()
        Session.set 'truckLoad_editing_mass', this.number
        Deps.flush()
        utils.activateInput(tmpl.find('#mass-input'))
    'click .editable_delivery': (e, tmpl) ->
        e.preventDefault()
        Session.set 'truckLoad_editing_delivery', this.number
        Deps.flush()
        utils.activateInput(tmpl.find('#delivery-input'))
}

Template.truckLoadPallet.events utils.okCancelEvents('#mass-input', {
    ok: (value) ->
        fieldName = 'pallets.'+this.number+'.mass'
        db.updateField fieldName, value
        Session.set 'truckLoad_editing_mass', null
    cancel: ->
        Session.set 'truckLoad_editing_mass', null
})

Template.truckLoadPallet.events utils.okCancelEvents('#delivery-input', {
    ok: (value) ->
        fieldName = 'pallets.'+this.number+'.delivery'
        db.updateField fieldName, value
        Session.set 'truckLoad_editing_delivery', null
    cancel: ->
        Session.set 'truckLoad_editing_delivery', null
})
