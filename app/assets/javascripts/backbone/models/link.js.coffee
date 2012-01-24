LinksApp.Models.Link = Backbone.Model.extend({
    urlRoot: '/linkss'
})

LinksApp.Collections.Links = Backbone.Collection.extend({
    model: LinksApp.Models.Link
    url: '/links'
    comparator: (link) ->
        link.get('updated_at')
})
