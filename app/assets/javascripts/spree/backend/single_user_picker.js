$.fn.singleUserAutocomplete = function () {
  'use strict';

  this.select2({
    minimumInputLength: 1,
    multiple: false,
    ajax: {
      url: Spree.routes.users_api,
      datatype: 'json',
      cache: true,
      data: function (term) {
        return {
          q: term,
          token: Spree.api_key
        };
      },
      results: function (data) {
        return {
          results: data.users
        };
      }
    },
    formatResult: function (user) {
      return user.email;
    },
    formatSelection: function (user) {
      return user.email;
    }
  });
};

$(document).ready(function () {
  $('[data-hook="single_user_picker"]').singleUserAutocomplete();
});
