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

def with_active_record_update_all
  Entry.update_all(updated_at: Time.current)
end

def with_active_record_update
  Entry.find_in_batches do |entries|
    entries.each do |entry|
      entry.update(updated_at: Time.current)
    end
  end
end

def with_active_record_import
  Entry.find_in_batches do |entries|
    arr = []
    entries.each do |entry|
      entry.updated_at = Time.current
      arr << entry
    end
    Entry.import arr, on_duplicate_key_update: [:updated_at]
  end
end

def with_active_record_upsert_all
  Entry.find_in_batches do |entries|
    arr = []
    entries.each do |entry|
      entry.updated_at = Time.current
      arr << entry.attributes
    end
    Entry.upsert_all(arr)
  end
end

Benchmark.bm(12) do |x|
  x.report('SQL') { with_sql }
  x.report('.update_all') { with_active_record_update_all }
  # x.report('.update') { with_active_record_update }
  x.report('.import') { with_active_record_import }
  x.report('.upsert_all') { with_active_record_upsert_all }
end

Benchmark.memory do |x|
  x.report('SQL') { with_sql }
  x.report('.update_all') { with_active_record_update_all }
  # x.report('.update') { with_active_record_update }
  x.report('.import') { with_active_record_import }
  x.report('.upsert_all') { with_active_record_upsert_all }
  x.compare!
end
