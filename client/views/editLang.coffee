langSubscription = Meteor.subscribe 'lang'

utils = myTinker.utils

Template.editLang.langItems = -> Lang.find {}, {sort: [['de','asc']]}

Template.langItem.events {
    'click .editable-fr': (e, tmpl) ->
        e.preventDefault()
        Session.set 'langItem_editing_fr', this.word
        Deps.flush()
        utils.activateInput(tmpl.find '#fr-input')
    'click .editable-en': (e, tmpl) ->
        e.preventDefault()
        Session.set 'langItem_editing_en', this.word
        Deps.flush()
        utils.activateInput(tmpl.find '#en-input')
    'click .editable-de': (e, tmpl) ->
        e.preventDefault()
        Session.set 'langItem_editing_de', this.word
        Deps.flush()
        utils.activateInput(tmpl.find '#de-input')
}

Template.langItem.editingFr = ->
    Session.equals('langItem_editing_fr', this.word)

Template.langItem.editingEn = ->
    Session.equals('langItem_editing_en', this.word)

Template.langItem.editingDe = ->
    Session.equals('langItem_editing_de', this.word)

Template.langItem.events utils.okCancelEvents '#fr-input', {
    ok: (value) ->
        word = Session.get 'langItem_editing_fr'
        data = Lang.findOne({word:word})
        if data?
            Lang.update {_id:data._id}, {$set: {fr:value}}
        Session.set 'langItem_editing_fr', null
    cancel: ->
        Session.set 'langItem_editing_fr', null
}

Template.langItem.events utils.okCancelEvents '#en-input', {
    ok: (value) ->
        word = Session.get 'langItem_editing_en'
        data = Lang.findOne({word:word})
        if data?
            Lang.update {_id:data._id}, {$set: {en:value}}
        Session.set 'langItem_editing_en', null
    cancel: ->
        Session.set 'langItem_editing_en', null
}

Template.langItem.events utils.okCancelEvents '#de-input', {
    ok: (value) ->
        word = Session.get 'langItem_editing_de'
        data = Lang.findOne({word:word})
        if data?
            Lang.update {_id:data._id}, {$set: {de:value}}
        Session.set 'langItem_editing_de', null
    cancel: ->
        Session.set 'langItem_editing_de', null
}
