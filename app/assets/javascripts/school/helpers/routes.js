(function() {
  // Routing functions
  window.shared || (window.shared = {});
  
  var baseUrl = '';  //'https://somerville-teacher-tool.herokuapp.com'; // can use this for local hacking
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