$.fn.singleUserAutocomplete = function () {
  'use strict';

  this.select2({
    minimumInputLength: 1,
    multiple: false,
    ajax: {
      url: Spree.routes.users_api,
      datatype: 'json',
      data: function (term) {
        return {
          q: {
            email_cont: term
          },
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
