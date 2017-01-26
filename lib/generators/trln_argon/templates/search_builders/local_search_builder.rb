class LocalSearchBuilder < Blacklight::SearchBuilder

  include Blacklight::Solr::SearchBuilderBehavior
  include BlacklightAdvancedSearch::AdvancedSearchBuilder
  include TrlnArgon::TrlnSearchBuilderBehavior

  self.default_processor_chain += [:add_advanced_parse_q_to_solr, :add_advanced_search_to_solr]
  self.default_processor_chain += [:show_only_local_holdings]

end
