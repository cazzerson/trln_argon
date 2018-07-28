TrlnArgon::Engine.configure do |config|
  config.preferred_records      = ENV['PREFERRED_RECORDS'] || 'unc'
  config.local_institution_code = ENV['LOCAL_INSTITUTION_CODE'] || 'unc'
  config.local_records          = ENV['LOCAL_RECORDS'] || 'unc, trln'
  config.application_name       = ENV['APPLICATION_NAME'] || 'TRLN Argon'
  config.refworks_url           = ENV['REFWORKS_URL'] || 'http://www.refworks.com.libproxy.lib.unc.edu/express/ExpressImport.asp?vendor=SearchUNC&filter=RIS%20Format&encoding=65001&url='
  config.root_url               = ENV['ROOT_URL'] || 'https://discovery.trln.org'
  config.article_search_url     = ENV['ARTICLE_SEARCH_URL'] || 'http://libproxy.lib.unc.edu/login?url=http://unc.summon.serialssolutions.com/search?s.secure=f&s.ho=t&s.role=authenticated&s.ps=20&s.q='
  config.contact_url            = ENV['CONTACT_URL'] || 'https://library.unc.edu/ask/'
  config.feedback_url           = ENV['FEEDBACK_URL'] || ''

  config.code_mappings = {
    git_url: 'https://github.com/trln/argon_code_mappings',
    git_branch: 'master'
  }
  git_fetcher = TrlnArgon::MappingsGitFetcher.new(git_url: config.code_mappings[:git_url])
  TrlnArgon::LookupManager.fetcher = git_fetcher

  TrlnArgon::LookupManager.instance.map('ncsu.library.DHHILL')
end
