(function() {
  // Routing functions
  window.shared || (window.shared = {});
  
  var baseUrl = ''; // can set this to production to prototype exploratory views
  window.shared.Routes = {
    student: function(id) {
      return baseUrl + '/students/' + id;
    },
    homeroom: function(id) {
      return baseUrl + '/homerooms/' + id;
    },
    school: function(id) {
      return baseUrl + '/school/' + id;
    }
  };
})();