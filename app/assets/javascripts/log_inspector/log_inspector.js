
function intializeLogInspector( dir_contents_url, file_contents_url, root_dir ) {
  $(window).resize(function() {
    $('.panel').height($(window).height() - $('.panel').position().top - 10); // 10px padding
  });

  $('body').css({ 'overflow-y': 'hidden' });
  $(window).trigger('resize');

  $.get(dir_contents_url, $.param({path: root_dir}));

  $('.folder-list').on('click', 'li', function() {
    $('.folder-list li').removeClass('selected');
    $(this).addClass('selected');

    if ( $(this).hasClass('file') ) {
      getFileContents( $(this).data('full-path') );
    }
    return false;
  });

  function getFileContents( filepath ) {
    $('.file-contents').addClass('throbbing');
    $.get(file_contents_url, $.param({filepath: filepath}));
  }

  $('.folder-list').on('click', 'li.directory > .chevron', function() {
    if ( $(this).hasClass('glyphicon-chevron-right') ) {
      $(this).switchClass( 'glyphicon-chevron-right', 'glyphicon-chevron-down' );
      var sub_list = $(this).siblings('ul');
      sub_list.show();
      if ( sub_list.hasClass('loading') ) {
        $.get(dir_contents_url, $.param({path: $(this).parent().attr('data-full-path')}));
      }
    } else if ( $(this).hasClass('glyphicon-chevron-down') ) {
      $(this).switchClass('glyphicon-chevron-down', 'glyphicon-chevron-right');
      $(this).siblings('ul').hide();
    }
    return false;
  });

  $('.sr-log-panel.right').on('click', '.display-all-lines', function() {
    $('.file-contents').addClass('throbbing');
    $.get( $(this).attr('href') );
    return false;
  });
}
