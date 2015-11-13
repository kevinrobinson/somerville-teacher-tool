(function(root) {

  var InterventionPlotBand = function initializeInterventionPlotBand (intervention) {
    this.name = intervention.name;
    this.from = InterventionPlotBand.toHighChartsDate(intervention.start_date);
    this.to = InterventionPlotBand.toHighChartsDate(intervention.end_date);
  }

  InterventionPlotBand.toHighChartsDate = function interventionDatesToHighChartsDate (date) {
    return Date.UTC(date['year'],
             date['month'] - 1,   // JavaScript months start with 0, Ruby months start with 1
             date['day'])
  }

  InterventionPlotBand.prototype.toHighCharts = function interventionToHighCharts () {
    return $.extend({},
      InterventionPlotBand.base_options, {
        from: this.from,
        to: this.to,
      }
    );
  }

  InterventionPlotBand.base_options = {
    color: 'rgba(248,231,28,.23)',
    zIndex: 2,
  }

  root.InterventionPlotBand = InterventionPlotBand;

})(window)
