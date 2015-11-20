(function(root) {

  /*
  This owns a piece of the DOM rendered by Rails.  It takes an initial list of `interventions` 
  and then owns that state and any changes to it over time.
  
  This class expects a few Mustache templates to be available on the page (see constructor).

  The structure of this class is to:
  - take a DOM element to render into, and some initial state
  - store state as instance variables
  - bind any event listeners once
  - call `render` to project the state onto the page
  - use client-side templates to do the rendering
  - when a user action occurs, update state in instances variables and re-render

  It's similar to a Backbone View, and the main flow of data is the same as a single
  React component.
  */  
  var InterventionsController = function (options) {
    this.initialize(options);
  };

  _.extend(InterventionsController.prototype, {
    // Expects: {$el, interventions}
    // Optional: {datepickerOptions}
    initialize: function(options) {
      this.options = options;
      this.$el = this.options.$el;

      // state
      this.interventions = this.options.interventions;
      this.selectedInterventionId = this.defaultSelectedIntervention();
      this.isShowingNewIntervention = false;

      // templates, these should be available on the page (or could be compiled and provided
      // as a JS asset)
      this.templates = {
        main: $('#main-interventions-template').html(),
        interventionCell: $('#intervention-cell-template').html(),
        interventionDetails: $('#intervention-detail-template').html(),
        newInterventionForm: $('#new-intervention-form-template').html()
      };
    },

    defaultSelectedIntervention: function() {
      return (this.interventions.length === 0)
        ? null
        : this.interventions[0].id
    },

    bindListeners: function () {
      this.$el.on('click', '#open-intervention-form', this.onAddNewIntervention.bind(this));
      this.$el.on('click', '#close-intervention-form', this.onCancelNewIntervention.bind(this));
      this.$el.on('click', '.intervention-cell', this.onSelectedIntervention.bind(this));
      this.$el.on('ajax:success', '.new_intervention', this.onNewInterventionSaveSucceeded.bind(this));
      this.$el.on('ajax:error', '.new_intervention', this.onNewInterventionSaveFailed.bind(this));

      // TODO(kr) progress notes
      // $('.add-progress-note-area').hide();
      // $('body').on('click', '.add-progress-note', function() {
      //   $(this).parent().children('.add-progress-note-area').show();
      //   $(this).hide();
      // });
      // $('body').on('click', '.cancel-progress-note', function() {
      //   interventionsController.clearProgressNoteForm();
      // });
    },

    onSelectedIntervention: function (e) {
      var interventionId = $(e.currentTarget).data('id');
      this.selectedInterventionId = interventionId;
      this.render();
    },

    onAddNewIntervention: function () {
      this.selectedInterventionId = null;
      this.isShowingNewIntervention = true;
      this.render();
    },

    onCancelNewIntervention: function () {
      this.selectedInterventionId = this.defaultSelectedIntervention();
      this.isShowingNewIntervention = false;
      this.render();
    },

    onNewInterventionSaveSucceeded: function (e, data, status, xhr) {
      this.interventions = [data].concat(this.interventions);
      this.selectedInterventionId = this.defaultSelectedIntervention();
      this.isShowingNewIntervention = false;
      this.render();
    },

    // TODO(kr)
    onNewInterventionSaveFailed: function(e, xhr, status, error) {
      console.log('error', arguments);
      // <% @intervention.errors.full_messages.each do |msg| %>
      //   $('#interventions-tab form .errors').prepend("<br/><li><%= msg %></li>");
      // <% end %>
    },

    render: function () {
      this.$el.html(Mustache.render(this.templates.main, {}));
      this.$el.find('.intervention-cell-list').html(this.renderInterventionCells());
      this.$el.find('.intervention-details-list').html(this.renderInterventionDetails());
      this.$el.find('.new-intervention-container').html(this.renderNewInterventionForm());

      this.$el.find('.datepicker').datepicker(this.options.datepickerOptions || {});
    },

    renderInterventionCells: function () {
      // TODO(kr) when no interventions
      var htmlPieces = this.interventions.map(function(intervention) {
        var activatedClass = (intervention.id === this.selectedInterventionId) ? 'activated' : '';
        return Mustache.render(this.templates.interventionCell, _.assign({}, intervention, { activatedClass: activatedClass }));
      }, this);
      return htmlPieces.join('');
    },

    renderInterventionDetails: function () {
      if (this.selectedInterventionId === null) {
        return '';
      }
      var intervention = _.findWhere(this.interventions, { id: this.selectedInterventionId });
      return Mustache.render(this.templates.interventionDetails, intervention);
    },

    renderNewInterventionForm: function() {
      return (this.isShowingNewIntervention)
        ? Mustache.render(this.templates.newInterventionForm, {})
        : '';
    }
  });

  root.InterventionsController = InterventionsController;

})(window)