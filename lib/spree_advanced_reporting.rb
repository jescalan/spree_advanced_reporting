require "ruport"

module Spree
  module AdvancedReporting
    class Engine < Rails::Engine
      engine_name "spree_advanced_reporting"

      config.autoload_paths += %W(#{config.root}/lib)

      def self.activate
        Dir.glob(File.join(File.dirname(__FILE__), "../app/**/*_decorator.rb")).each do |c|
          Rails.env.production? ? require(c) : load(c)
        end

        # Ruport::Controller::Table.formats.merge({ :flot => MyFlotFormatter })
        # if Mime::Type.lookup_by_extension(:pdf) != 'application/pdf'
        #   Mime::Type.register('application/pdf', :pdf)
        # end
        
        Ruport::Formatter::HTML.class_eval do
          # Renders individual rows for the table.
          def build_row(data = self.data)
            @odd = !@odd
            klass = @odd ? "odd" : "even"
            output <<
            "\t\t<tr class=\"#{klass}\">\n\t\t\t<td>" +
              data.to_a.join("</td>\n\t\t\t<td>") +
              "</td>\n\t\t</tr>\n"
          end

          def html_table
            @odd = false
            "<table class=\"tablesorter\">\n" << yield << "</table>\n"
          end

          def build_table_header
            output << "\t<table class=\"tablesorter\">\n"
            unless data.column_names.empty? || !options.show_table_headers
              output << "\t\t<thead><tr>\n\t\t\t<th>" + 
                data.column_names.join("</th>\n\t\t\t<th>") + 
                "</th>\n\t\t</tr></thead>\n"
            end
          end
        end
      end

      config.to_prepare &method(:activate).to_proc
    end
  end
end

