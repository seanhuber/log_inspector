module LogInspector
  class LogController < ApplicationController
    include ActionView::Helpers::NumberHelper

    before_filter :restrict_access, only: [:file_api, :folder_api]

    def file_api
      path = ensure_path :file?

      resp_h = {
        basename: File.basename(path),
        lines:    `wc -l "#{path}"`.split.first.to_i,
        path:     path,
        size:     number_to_human_size(File.size(path))
      }
      resp_h[:truncated] = resp_h[:lines] > 500 && params[:all_lines] != 'true'
      resp_h[:lines] = number_with_delimiter resp_h[:lines]
      resp_h[:contents] = resp_h[:truncated] ? `tail -n 500 "#{path}"` : File.read(path)

      render json: resp_h
    end

    def folder_api
      resp_h = {folders: [], files: []}
      Dir.glob( "#{ensure_path(:directory?).gsub(/[\\\{\}\[\]\*\?]/){|x| "\\"+x}}/*" ) do |sub_path|
        resp_h[ File.directory?(sub_path) ? :folders : :files ] << File.basename(sub_path)
      end
      render json: resp_h
    end

    # TODO: document restricting access: http://guides.rubyonrails.org/routing.html#advanced-constraints
    def index
      render 'log_inspector/index'
    end

    private

    def ensure_path file_method
      path = params.require(:path).split '/'
      raise ArgumentError, "Expected path to start with 'log/' but received: #{path.join('/')}" unless path[0] == 'log'
      path[0] = LogInspector.log_path || Rails.root.join('log')
      path = path.join '/'
      raise ArgumentError, "Bad path: #{path}" unless File.send file_method, path
      path
    end

    def restrict_access
      authenticate_or_request_with_http_token do |token, options|
        LogInspector::Encryptor.api_token token
      end
    end
  end
end
