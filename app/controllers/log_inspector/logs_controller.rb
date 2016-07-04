module LogInspector
  class LogsController < ApplicationController
    def dir_contents
      raise ':path param missing' unless params[:path].present?
      @directory = params[:path]
      raise "#{@directory} is not a directory" unless File.directory?( @directory )

      @dir_contents = []
      Dir.glob( "#{escape_glob(@directory)}/*" ) do |dir|
        @dir_contents << {
          is_directory: File.directory?(dir),
          name:         File.basename(dir),
          fullpath:     dir
        }
      end
      @dir_contents = @dir_contents.sort_by { |f| [ (!f[:is_directory]).to_s, f[:name] ] }
    end

    def index
      @directory = Rails.application.root.join('log')
    end

    def file_contents
      fp = params[:filepath]
      raise "#{fp} is not a file." unless File.file?(fp)
      @file_contents = {
        basename: File.basename( fp ),
        fullpath: fp,
        lines:    %x{wc -l "#{fp}"}.split.first.to_i,
        size:     File.size(fp)
      }
      @truncated = @file_contents[:lines] > 500 && !params[:show_all].present?
      @file_contents[:content] = @truncated ? %x{tail -n 500 "#{fp}"} : File.read( fp )
    end

    private

    def escape_glob(s)
      s.gsub(/[\\\{\}\[\]\*\?]/) { |x| "\\"+x }
    end
  end
end
