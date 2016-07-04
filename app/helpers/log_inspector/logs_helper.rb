module LogInspector
  module LogsHelper
    def jq_dirpath dir
      dir.gsub("'","\\\\'").html_safe
    end
  end
end
