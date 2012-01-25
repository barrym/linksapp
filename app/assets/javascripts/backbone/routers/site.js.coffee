LinksApp.Routers.Site = Backbone.Router.extend({
    routes: {
        ''               : 'home'
        'links'          : 'links'
        'links/:id'      : 'link'
    }

    initialize: () ->
        $('#working').show()
        @links = new LinksApp.Collections.Links()
        @links.fetch {
            success: () ->
                $('#working').hide()
        }


        # TODO: if websockets, then update via that, otherwise do a fetch every time they go to /links

    home: () ->
        view = new LinksApp.Views.Home()
        $('#main').empty()
        $('#main').append(view.render().el)

    links: () ->
        $('#working').show()
        console.log("fetching links")
        view = new LinksApp.Views.LinksIndex({collection:@links})
        $('#main').empty()
        $('#main').append(view.render().el)
        $('#working').hide()
        # @links.fetch({
        #     success: (collection, resp) ->
        #         view = new LinksApp.Views.LinksIndex({collection:collection})
        #         $('#main').empty()
        #         $('#main').append(view.render().el)
        #         $('#working').hide()
        #     error: (collection, resp) ->
        #         console.log("error loading links index")
        #         console.log(resp)
        #         $('#working').hide()

        # })

    link: (id) ->
        $('#working').show()
        link = @links.get(id)
        # link = new LinksApp.Models.Link({id:id})
        # link.fetch({
        #     success: (model, resp) ->
        view = new LinksApp.Views.LinksShow({model:link})
        $('#main').empty()
        $('#main').append(view.render().el)
        $('#working').hide()
#
#             error: () ->
#                 console.log("category not found")
#                 $('#working').hide()
#         })

})
