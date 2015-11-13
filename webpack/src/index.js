window.jQuery = window.$ = require('jquery');

// `about` is expressed as a module of CSS and images
require('./about/index.scss')

require('jquery-ujs');

require('./vendor/jquery-ui.min'); // manually put here, since it needs images and CSS generated from the website
require('./vendor/highcharts');
require('./vendor/rounded-corners');
require('./vendor/jquery.tooltipster.min.js');
window.Tablesort = require('./vendor/tablesort.min');
require('./vendor/tablesort.numeric');
window.Mustache = require('./vendor/mustache.min');
window.Cookies = require('./vendor/js.cookie');
require('./vendor/classList');

require('./sorts/mcas_sort');
require('./sorts/reverse_number');

require('./charts/attendance_chart');
require('./charts/behavior_chart');
require('./charts/empty_view');
require('./charts/intervention_plot_band');
require('./charts/mcas_growth_chart');
require('./charts/mcas_scaled_chart');
require('./charts/profile_chart_settings');
require('./charts/roster_chart');
require('./charts/roster_chart_settings');
require('./charts/star_chart');



require('./roster');
require('./roster_bulk_assignment');
require('./profile');
require('./profile_interventions');
require('./session_timeout_warning');
require('./datepicker');

require('./student-searchbar');


// all the css
require('./styles/index.scss')


