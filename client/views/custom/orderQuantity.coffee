log = (txt) -> console.log 'orderQuantity: '+txt

utils = myTinker.utils
db = myTinker.customActivities

# default session values
Session.setDefault 'editing_demand', null
Session.setDefault 'editing_demandVar', null
Session.setDefault 'editing_delay', null
Session.setDefault 'editing_delayVar', null
Session.setDefault 'editing_orderCosts', null
Session.setDefault 'editing_storageCosts', null

Template.customOrderQuantity.lang = -> Session.get 'lang'
Template.customOrderQuantity.loading = -> db.loading()

# orderQuantityCustomers
Template.orderQuantityCustomers.lang = -> Session.get 'lang'

Template.orderQuantityCustomers.demand = -> db.getOrAddField 'demand', 10
Template.orderQuantityCustomers.demandVar = -> db.getOrAddField 'demandVar', 0

Template.orderQuantityCustomers.editingDemand = -> Session.get 'editing_demand'
Template.orderQuantityCustomers.editingDemandVar = -> Session.get 'editing_demandVar'

Template.orderQuantityCustomers.events utils.okCancelEvents('#demand-input', {
    ok: (value) ->
        db.updateField 'demand', value
        Session.set 'editing_demand', null
    cancel: -> Session.set 'editing_demand', null
})

Template.orderQuantityCustomers.events utils.okCancelEvents('#demandVar-input', {
    ok: (value) ->
        db.updateField 'demandVar', value
        Session.set 'editing_demandVar', null
    cancel: -> Session.set 'editing_demandVar', null
})

Template.orderQuantityCustomers.events {
    'click .editableDemand': (e,tmpl) ->
        e.preventDefault()
        Session.set 'editing_demand', true
        Deps.flush()
        utils.activateInput(tmpl.find('#demand-input'))
    'click .editableDemandVar': (e,tmpl) ->
        e.preventDefault()
        Session.set 'editing_demandVar', true
        Deps.flush()
        utils.activateInput(tmpl.find('#demandVar-input'))
}

# orderQuantitySuppliers
Template.orderQuantitySuppliers.lang = -> Session.get 'lang'

Template.orderQuantitySuppliers.delay = -> db.getOrAddField 'delay',4
Template.orderQuantitySuppliers.delayVar = -> db.getOrAddField 'delayVar', 0

Template.orderQuantitySuppliers.editingDelay = -> Session.get 'editing_delay'
Template.orderQuantitySuppliers.editingDelayVar = -> Session.get 'editing_delayVar'

Template.orderQuantitySuppliers.events utils.okCancelEvents('#delay-input', {
    ok: (value) ->
        db.updateField 'delay', value
        Session.set 'editing_delay', null
    cancel: -> Session.set 'editing_delay', null
})

Template.orderQuantitySuppliers.events utils.okCancelEvents('#delayVar-input', {
    ok: (value) ->
        db.updateField 'delayVar', value
        Session.set 'editing_delayVar', null
    cancel: -> Session.set 'editing_delayVar', null
})

Template.orderQuantitySuppliers.events {
    'click .editableDelay': (e,tmpl) ->
        e.preventDefault()
        Session.set 'editing_delay', true
        Deps.flush()
        utils.activateInput(tmpl.find('#delay-input'))
    'click .editableDelayVar': (e,tmpl) ->
        e.preventDefault()
        Session.set 'editing_delayVar', true
        Deps.flush()
        utils.activateInput(tmpl.find('#delayVar-input'))
}

# orderQuantityCosts
Template.orderQuantityCosts.lang = -> Session.get 'lang'

Template.orderQuantityCosts.orderCosts = -> db.getOrAddField 'orderCosts', 50
Template.orderQuantityCosts.storageCosts = -> db.getOrAddField 'storageCosts', 20

Template.orderQuantityCosts.editingOrderCosts = -> Session.get 'editing_orderCosts'
Template.orderQuantityCosts.editingStorageCosts = -> Session.get 'editing_storageCosts'

Template.orderQuantityCosts.events utils.okCancelEvents('#orderCosts-input', {
    ok: (value) ->
        db.updateField 'orderCosts', value
        Session.set 'editing_orderCosts', null
    cancel: -> Session.set 'editing_orderCosts', null
})

Template.orderQuantityCosts.events utils.okCancelEvents('#storageCosts-input', {
    ok: (value) ->
        db.updateField 'storageCosts', value
        Session.set 'editing_storageCosts', null
    cancel: -> Session.set 'editing_storageCosts', null
})

Template.orderQuantityCosts.events {
    'click .editableOrderCosts': (e,tmpl) ->
        e.preventDefault()
        Session.set 'editing_orderCosts', true
        Deps.flush()
        utils.activateInput(tmpl.find('#orderCosts-input'))
    'click .editableStorageCosts': (e,tmpl) ->
        e.preventDefault()
        Session.set 'editing_storageCosts', true
        Deps.flush()
        utils.activateInput(tmpl.find('#storageCosts-input'))
}

# orderQuantityDone
Template.orderQuantityDone.lang = -> Session.get 'lang'

Template.orderQuantityDone.events {
    'click .generatePDF': (e) ->
        e.preventDefault()
        generatePDF()
}

generatePDF = ->
    data = db.getData()
    return if not data?

    txt = 'act="orderQuantity";'
    txt += 'cust=['+data.demand+','+data.demandVar+'];'
    txt += 'supp=['+data.delay+','+data.delayVar+'];'
    txt += 'costs=['+data.orderCosts+','+data.storageCosts+'];'

    lang = Session.get 'lang'
    pdf = myTinker.pdfCreator()
    pdf.generate {
        dmText:txt
        title:lang['OrderQuantity']
        description:data.description
        username:Meteor.user()?.username
        filename:lang['OrderQuantity']
    }
