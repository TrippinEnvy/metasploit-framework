module WorkspaceServlet

    def self.api_path
      '/api/1/msf/workspace'
    end

    def self.registered(app)
      app.get WorkspaceServlet.api_path, &get_workspace
      app.post WorkspaceServlet.api_path, &add_workspace
    end

    private

    def self.get_workspace
      lambda {
        begin
          opts = parse_json_request(request, true)
          if (opts[:all])
            data = get_db().workspaces
          else
            data = get_db().find_workspace(opts[:workspace_name])
          end

          set_json_response(data)
        rescue Exception => e
          set_error_on_response(e)
        end
      }
    end

    def self.add_workspace
      lambda {
        begin
          opts = parse_json_request(request, true)
          get_db().add_workspace(opts[:workspace_name])
          set_empty_response
        rescue Exception => e
          set_error_on_response(e)
        end
      }
    end
end