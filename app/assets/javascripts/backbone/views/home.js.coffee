LinksApp.Views.Home = Backbone.View.extend({
    initialize: () ->
        _.bindAll(this, 'render')
        @template = _.template($('#home-template').html())

    render: () ->
        content = @template()
        $(@el).html(content)
        return this
})
