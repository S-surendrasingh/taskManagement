Rails.application.configure do
  config.cache_classes = true
  config.eager_load = false

  config.consider_all_requests_local = true
  config.action_dispatch.show_exceptions = false
  config.action_controller.perform_caching = false
  config.cache_store = :null_store

  config.public_file_server.enabled = true
  config.public_file_server.headers = {
    "Cache-Control" => "public, max-age=3600"
  }

  config.active_storage.service = :test

  config.active_support.deprecation = :stderr
  config.active_support.disallowed_deprecation = :raise
  config.active_support.disallowed_deprecation_warnings = []

  config.active_record.migration_error = :page_load
end
