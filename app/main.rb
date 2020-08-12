require 'active_record'
require 'activerecord-import'
require 'benchmark/memory'
require_relative './db_config'
require_relative './models/entry'

Entry.establish_connection(db_config['development'])

def with_sql
  sql = ['UPDATE entries SET updated_at = ?', Time.current]
  bulk_update_query = Entry.sanitize_sql_array(sql)
  Entry.connection.execute(bulk_update_query)
end

def with_active_record
  Entry.update_all(updated_at: Time.current)
end

def with_active_record_import
  Entry.find_in_batches do |batch|
    arr = []
    batch.each do |app_coupons_customer|
      app_coupons_customer.updated_at = Time.current
      arr << app_coupons_customer
    end
    Entry.import arr, on_duplicate_key_update: [:updated_at]
  end
end

Benchmark.bm(12) do |x|
  x.report('SQL') { with_sql }
  x.report('.update_all') { with_active_record }
  x.report('.import') { with_active_record_import }
end

Benchmark.memory do |x|
  x.report('SQL') { with_sql }
  x.report('.update_all') { with_active_record }
  x.report('.import') { with_active_record_import }
  x.compare!
end
