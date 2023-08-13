#!/usr/bin/env ruby

# Try this simple example
# 1. docker run --pull=always -d -p 8888:8888 epsilla/vectordb
# 2. gem install epsilla-ruby && gem update epsilla-ruby
# 3. ruby hello_epsilla.rb


require "epsilla"

# Connect to Epsilla VectorDB
client = Epsilla::Client.new(protocol="http", host="127.0.0.1", port="8888")
# puts client.live?

# Load DB with path
status_code, response = client.database.load_db(db_name="MyDB", db_path="/tmp/epsilla")
puts status_code, response

# Set DB to current DB
client.database.use_db(db_name="MyDB")

# Create a table with schema in current DB
table_fields= [
  {"name" => "ID", "dataType" => "INT"},
  {"name" => "Doc", "dataType" => "STRING"},
  {"name" => "Embedding", "dataType" => "VECTOR_FLOAT", "dimensions" => 4}
]
# table_fields.each { |x| puts "==#{x}"}
status_code, response = client.database.create_table(table_name="MyTable", table_fields=table_fields)
puts status_code, response

# Insert new vector records into table
table_records = [
  {"ID" => 1, "Doc" => "Berlin", "Embedding" => [0.05, 0.61, 0.76, 0.74]},
  {"ID" => 2, "Doc" => "London", "Embedding" => [0.19, 0.81, 0.75, 0.11]},
  {"ID" => 3, "Doc" => "Moscow", "Embedding" => [0.36, 0.55, 0.47, 0.94]},
  {"ID" => 4, "Doc" => "San Francisco", "Embedding" => [0.18, 0.01, 0.85, 0.80]},
  {"ID" => 5, "Doc" => "Shanghai", "Embedding" => [0.24, 0.18, 0.22, 0.44]}  
]

status_code, response = client.database.insert(table_name="MyTable", table_records=table_records)
puts status_code, response

# Rebuild
status_code, response = client.database.rebuild()
puts status_code, response

# Query Vectors
query_field = "Embedding"
response_fields = ["Doc"]
query_vector=[0.35, 0.55, 0.47, 0.94]
limit=1
status_code, response = client.database.query(table_name="MyTable", query_field=query_field, query_vector=query_vector, response_fields=response_fields, limit=limit, with_distance=true)
puts status_code, response


# Drop table
status_code, response = client.database.drop_table("MyTable")
puts status_code, response

# Unload db
status_code, response = client.database.unload_db("MyDB")
puts status_code, response



