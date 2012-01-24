LinksApp.Routers.Site = Backbone.Router.extend({
    routes: {
        ''               : 'home'
        'links'          : 'links'
    }

    # initialize: () ->

    home: () ->
        view = new LinksApp.Views.Home()
        $('#main').empty()
        $('#main').append(view.render().el)

    links: () ->
        $('#working').show()
        @collection = new LinksApp.Collections.Links()
        console.log("fetching links")
        @collection.fetch({
            success: (collection, resp) ->
                view = new LinksApp.Views.LinksIndex({collection:collection})
                $('#main').empty()
                $('#main').append(view.render().el)
                $('#working').hide()
            error: (collection, resp) ->
                console.log("error loading users index")
                console.log(resp)
                $('#working').hide()

        })

})
