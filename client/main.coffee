@Lang = new Meteor.Collection 'lang'

Session.setDefault('lang_id', 'fr')
Session.setDefault('lang', {})
langHandle = Meteor.subscribe('lang')

Deps.autorun ->
    langData = {}
    lang_id = Session.get 'lang_id'
    data = Lang.find {}
    data.forEach (entry) ->
        langData[entry.word] = entry[lang_id]
    Session.set 'lang', langData
    null

Template.main.greeting = ->
    'Welcome to app.'

Template.main.lang = (e) -> Session.get 'lang'

setNav = (name) ->
        Session.set 'navbar:navId', name

Meteor.Router.add {
    '/activities': ->
        setNav 'Activities'
        'create'
    '/custom/:activity': (name) ->
        setNav 'Activities'
        'custom'+name
    '/account': ->
        setNav 'Settings'
        'account'
    '/editLang': ->
        setNav 'Settings'
        'editLang'
    '*': ->
        setNav 'Activities'
        'create'
}

Meteor.Router.filters {
    'checkLoggedIn': (page) ->
        if Meteor.loggingIn()
            return 'loading'
        else if Meteor.user()
            return page
        else
            return 'loginForm'
}

Meteor.Router.filter 'checkLoggedIn', {
    except: ['loginForm']
}
