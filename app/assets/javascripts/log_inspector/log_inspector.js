(function($) {
  $.widget( 'sh.logInspector', {
    options: {
      file_url:   '', // file api url
      folder_url: ''  // folder api url
    },

    _addPanels: function() {
      $('html').addClass('log-inspector-page');
      $("<div class='tree-pane'><div class='clearfix'></div><div class='ui-resizable-e ui-resizable-handle'></div></div><div class='file-pane'></div>").appendTo(this.element);
      $('.tree-pane').resizable({
        handles: { e: '.tree-pane > .ui-resizable-handle' },
        create: function( event, ui ) {
          $('.ui-resizable-e').css('cursor','ew-resize');
        }
      });
    },

    _create: function() {
      this._addPanels();
      this._initializeFolderTree();
    },

    _fileClick: function(path, all_lines) {
      var that = this;
      $.get(that.options.file_url, $.param({path: path, all_lines: all_lines}), function(data) {
        var $pane = that.element.find('.file-pane');
        $pane.empty();

        $("<div class='file-details'>"+$.map({'File': 'basename', 'Size': 'size', 'Lines': 'lines'}, function( data_key,label ) {
          return "<p class='"+data_key+"'><label>"+label+':</label><span>'+data[data_key]+'</span></p>';
        }).join('')+'</div>').appendTo($pane);

        if (data.truncated) {
          var $truncated = $("<div class='truncated'><p>Displaying last 500 lines of "+data.basename+".</p><a href='#'>Show all lines</a> <span class='disp-all-caption'>(This may respond slowly)</span></div>").appendTo($pane);
          $truncated.find('a').click( function() { that._fileClick(path, true); });
        }

        if (data.lines == '0') {
          $("<div><hr/><div class='no-contents'>No contents.</pre></div>").appendTo($pane);
        } else {
          $('<div><hr/><pre>'+data.contents+'</pre></div>').appendTo($pane);
        }
      });
    },

    _initializeFolderTree: function() {
      var $tree = $("<div class='folder-tree'></div>").prependTo(this.element.find('.tree-pane'));
      var that = this;
      $tree.folderTree({
        root: 'log',
        contents_url: that.options.folder_url,
        file_click: function(event, data) { that._fileClick(data.path, false); }
      });
    },
  });
})(jQuery);
