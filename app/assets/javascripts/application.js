// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require turbolinks
//= require jquery3
//= require chosen-jquery
//= require popper
//= require bootstrap
//= require_tree .
(function() {
  $(document).on('click', '.toggle-window', function(e) {
    e.preventDefault();
    var panel = $(this).parent().parent();
    var conversations = panel.parent().parent();
    console.log(conversations)
    var messages_list = panel.find('.messages-list');
    conversations.find('.card-body').not(panel.find('.card-body')).hide();
    conversations.find('.card-footer').not(panel.find('.card-footer')).hide();
    panel.find('.card-body').toggle();
    panel.find('.card-footer').toggle();
    panel.attr('class', 'card');
 
    if (panel.find('.card-body').is(':visible')) {
      var height = messages_list[0].scrollHeight;
      messages_list.scrollTop(height);
    }
  });
})();

$(document).on('turbolinks:load', function(){
  $('#email_message_user_id').chosen();  
})

