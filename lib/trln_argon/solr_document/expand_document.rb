module TrlnArgon
  module SolrDocument
    module ExpandDocument
      def expanded_holdings_to_text
        @expanded_holdings_to_text ||= expanded_holdings.flat_map do |inst, loc_b_map|
          loc_b_map.flat_map do |loc_b, loc_n_map|
            loc_n_map.map do |_loc_n, items|
              I18n.t('trln_argon.item_location',
                     inst_display: I18n.t("trln_argon.institution.#{inst}.short_name"),
                     loc_b_display: TrlnArgon::LookupManager.instance.map("#{inst}.loc_b.#{loc_b}"),
                     call_number: items['call_no'].strip)
            end
          end
        end
      end

      def expanded_holdings
        @expanded_holdings ||= Hash[docs_with_merged_holdings.map do |doc|
          [doc.record_association,
           doc.holdings]
        end]
      end

      def docs_with_merged_holdings
        array = []
        docs_merged_by_inst.each do |inst, docs|
          first_doc = docs.first.dup
          first_doc[TrlnArgon::Fields::ITEMS] = docs.flat_map { |d| d[TrlnArgon::Fields::ITEMS] }.compact
          first_doc[TrlnArgon::Fields::HOLDINGS] = docs.flat_map { |d| d[TrlnArgon::Fields::HOLDINGS] }.compact
          first_doc[TrlnArgon::Fields::URLS] = docs.flat_map { |d| d[TrlnArgon::Fields::URLS] }.compact
          array << first_doc
        end
        array
      end

      def docs_merged_by_inst
        @docs_merged_by_inst ||= expanded_documents.group_by { |doc| doc.record_association.first }
      end

      def expanded_documents
        @expanded_documents ||= expanded_docs_search.documents.present? ? expanded_docs_search.documents : [self]
      end

      private

      def expanded_docs_search
        @expanded_docs_search ||= begin
          controller = CatalogController.new
          search_builder = SearchBuilder.new([:add_query_to_solr], controller)
          query = search_builder.where("#{TrlnArgon::Fields::ROLLUP_ID}:#{self[TrlnArgon::Fields::ROLLUP_ID]}").merge(rows: 100)
          controller.repository.search(query)
        end
      end
    end
  end
end
