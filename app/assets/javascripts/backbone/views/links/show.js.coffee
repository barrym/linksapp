LinksApp.Views.LinksShow = Backbone.View.extend({

    events: {
        'click a#like' : 'like'
    }

    initialize: () ->
        _.bindAll(this, 'render')
        @model.bind('reset', @render)
        @model.bind('remove', @render)
        @template = _.template($('#links-show-template').html())

    render: () ->
        content = @template(@model.toJSON())
        $(@el).html(content)
        return this

    like: () ->
        console.log("liking")

})
