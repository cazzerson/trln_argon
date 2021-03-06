task :ci do
  ENV['environment'] = 'test'
  Rake::Task['engine_cart:generate'].invoke
  Rake::Task['spec'].invoke
end

namespace :trln_argon do
  namespace :solr do
    require 'trln_argon/field.rb'
    require 'trln_argon/fields.rb'

    desc 'list missing field definitions'
    task 'missing_fields' do
      Rake::Task['trln_argon:solr:all_fields'].invoke
      Rake::Task['trln_argon:solr:defined_fields'].invoke
      missing_fields = @all_fields.reject do |n|
        @defined_fields.include?(n) || n.end_with?('_t') || n.end_with?('_str') || n == '_version_'
      end
      if missing_fields.present?
        puts missing_fields
      else
        puts 'No missing fields.'
      end
    end

    desc 'list all Solr fields'
    task :list_all_fields do
      Rake::Task['trln_argon:solr:all_fields'].invoke
      puts @all_fields
    end

    desc 'list all Solr fields defined in TRLN Argon'
    task :list_defined_fields do
      Rake::Task['trln_argon:solr:defined_fields'].invoke
      puts @defined_fields
    end

    desc 'get all fields defined in TRLN Argon'
    task defined_fields: :environment do
      include TrlnArgon::Fields
      @defined_fields = TrlnArgon::Fields.solr_field_names
    end

    desc 'get all Solr fields'
    task all_fields: :environment do
      def blacklight_config
        CatalogController.blacklight_config
      end

      class SolrFieldsTestClass < CatalogController
        include Blacklight::SearchHelper

        blacklight_config.configure do |config|
          config.solr_path = 'admin/luke'
        end
      end
      controller = SolrFieldsTestClass.new

      response, = controller.search_results(numTerms: 0)

      puts 'all_fields source repository:'
      puts blacklight_config.connection_config[:url]

      @all_fields = response['fields'].map { |field_name, _| field_name }
    end
  end
end
