LinksApp.Views.LinksIndex = Backbone.View.extend({
    initialize: () ->
        _.bindAll(this, 'render')
        @collection.bind('reset', @render)
        @collection.bind('remove', @render)
        @template = _.template($('#links-index-template').html())

    render: () ->
        content = @template({links: @collection.models})
        $(@el).html(content)
        return this
})
