Template.navbar.lang = (e) -> Session.get 'lang'

Template.navbar.events {
    'click li': (event) ->
        event.preventDefault()
        id = event.currentTarget.id
        switch id
            when 'navbarActivities' then Meteor.Router.to '/activities'
            when 'navbarSettings' then Meteor.Router.to '/account'
            when 'navbarLogout'
                Meteor.logout()
                Meteor.Router.to '/'
            when 'set-lang-fr' then Session.set 'lang_id', 'fr'
            when 'set-lang-de' then Session.set 'lang_id', 'de'
            when 'set-lang-en' then Session.set 'lang_id', 'en'
    'click a.brand': (event) ->
        event.preventDefault()
        Meteor.Router.to '/'
}

Template.navbar.rendered = ->
    Deps.autorun ->
        navId = Session.get 'navbar:navId'
        $('#titleNavbar li').removeClass 'active'
        $('#navbar'+navId).addClass 'active'
