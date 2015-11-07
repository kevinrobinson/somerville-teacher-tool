$(function() {
  if ($('body').hasClass('students') || $('body').hasClass('homerooms')) {

    var calendarIconPath = require('./images/calendar-icon.svg');
    window.datepicker_options = {
      showOn: "button",
      buttonImage: calendarIconPath,
      buttonImageOnly: true,
      buttonText: "Select date",
      dateFormat: 'yy-mm-dd',
      minDate: 0    // intervention end date cannot be earlier than today
    }

    $(".datepicker").datepicker(window.datepicker_options);

  }
});
