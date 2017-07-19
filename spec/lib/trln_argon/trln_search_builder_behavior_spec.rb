describe TrlnArgon::TrlnSearchBuilderBehavior do
  let(:solr_parameters) { Blacklight::Solr::Request.new }
  let(:blacklight_config) { CatalogController.blacklight_config.deep_copy }
  let(:user_params) { {} }
  let(:context) { CatalogController.new }
  let(:search_builder_class) do
    Class.new(Blacklight::SearchBuilder) do
      include Blacklight::Solr::SearchBuilderBehavior
      include TrlnArgon::TrlnSearchBuilderBehavior
    end
  end
  let(:search_builder) { search_builder_class.new(context) }

  before { allow(context).to receive(:blacklight_config).and_return(blacklight_config) }

  describe 'apply_local_filter' do
    context 'local filter is applied' do
      let(:builder_with_params) { search_builder.with(local_filter: 'true') }

      it 'applies the local holdings query' do
        expect(builder_with_params.show_only_local_holdings(solr_parameters).to_s).to(
          include('institution_f:unc OR institution_f:trln')
        )
      end
    end

    context 'local filter is not applied' do
      let(:builder_with_params) { search_builder.with(local_filter: 'false') }

      it 'does not apply the local holdings query' do
        expect(builder_with_params.show_only_local_holdings(solr_parameters).to_s).to include('')
      end
    end
  end

  describe 'show_only_local_holdings' do
    it 'adds parameters to restrict results to local holdings' do
      expect(search_builder.show_only_local_holdings(solr_parameters).to_s).to(
        include('institution_f:unc OR institution_f:trln')
      )
    end
  end

  describe 'rollup_duplicate_records' do
    it 'adds parameters to rollup duplicate records' do
      expect(search_builder.rollup_duplicate_records(solr_parameters).to_s).to include('')
    end
  end
end