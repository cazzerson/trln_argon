module TrlnArgon
  # Put any shared overrides of BlacklightHelperBehavior
  # in this module. Overrides in the local TRLN Argon based
  # applications go in app/helpers/blacklight_helper.rb
  module ViewHelpers
    module BlacklightHelperBehavior
      include Blacklight::BlacklightHelperBehavior

      def url_for_document(doc, options = {})
        return unless doc.respond_to?(:id)
        return solr_document_url(doc, options) if local_filter_applied?
        trln_solr_document_url(doc, options)
      end

      def application_name
        TrlnArgon::Engine.configuration.application_name
      end

      # Fixes a bug in blacklight. In the case where an accessor method is
      # used to retrieve the field value this method needs to check for the presence
      # of a value returned from that accessor method, not merely the presence of an accessor method
      # or a field value. This prevents a field label from being output if there's no value
      # returned by the accessor method.
      def document_has_value?(document, field_config)
        document.has?(field_config.field) ||
          (document.has_highlight_field? field_config.field if field_config.highlight) ||
          (field_config.accessor && document.send(field_config.accessor).present?)
      end

      # Add class to body when local filter is applied
      def extra_body_classes
        if local_filter_applied?
          super << 'local-filter'
        else
          super
        end
      end
    end
  end
end
