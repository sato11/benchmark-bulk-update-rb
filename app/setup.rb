require 'active_record'
require_relative './db_config'

ActiveRecord::Base.establish_connection(db_config['development'])

sql = <<-SQL
INSERT INTO entries(created_at, updated_at)
SELECT generated_at, generated_at
FROM (
  SELECT generate_series(1, 10000) as num, current_timestamp as generated_at
) nums;
SQL

ActiveRecord::Base.connection.execute(sql)
