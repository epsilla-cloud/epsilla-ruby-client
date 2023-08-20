# frozen_string_literal: true

module Epsilla
  class DataBase < Base

    # use db
    def use_db(db_name)
      @db_name = db_name
    end

    # load db
    def load_db(db_name, db_path, vector_scale: nil, wal_enabled: false)
      response = client.connection.post do |req|
        req.url "/api/load"
        req.body = {"name": db_name, "path": db_path}.to_json
        req.body["vectorScale"] = vector_scale if vector_scale
        req.body["walEnabled"] = wal_enabled if wal_enabled
      end
      return response.status, response.body
    end

    # unload db
    def unload_db(db_name)
      @db_name = nil
      response = client.connection.post do |req|
        req.url "/api/#{db_name}/unload"
      end
      return response.status, response.body
    end

    # create table in the db
    def create_table(table_name = "MyTable", table_fields = nil)
      unless @db_name
          raise Exception("[ERROR] Please use_db() first!")
      end
      unless table_fields
          table_fields = Array.new
      end

      response = client.connection.post do |req|
        req.url "/api/#{@db_name}/schema/tables"
        req.body = {"name": table_name, "fields": table_fields}.to_json
      end

      return response.status, response.body
    end

    # get a list of table names in current DB
    def list_tables()
      unless @db_name
        raise Exception("[ERROR] Please use_db() first!")
      end
      
      response = client.connection.post do |req|
        req.url "/api/#{@db_name}/schema/tables/show"
      end
      
      return response.status, response.body      
    end

    # insert data into table
    def insert(table_name = "MyTable", table_records = nil)
      unless @db_name
        raise Exception("[ERROR] Please use_db() first!")
      end
      unless table_records
        table_records = Array.new
      end
      response = client.connection.post do |req|
        req.url "/api/#{@db_name}/data/insert"
        req.body = {"table": table_name, "data": table_records}.to_json
      end
      
      return response.status, response.body
    end

    # rebuild the table
    def rebuild
      # puts "[INFO] waiting until rebuild is finished ..."
      response = client.connection.post do |req|
        req.url '/api/rebuild'
        req.options.timeout = 7200 # 7200s
      end
      return response.status, response.body
    end

    # query
    def query(table_name = "MyTable", query_field = "", query_vector = nil, response_fields = nil, limit = 1, with_distance = false)
      unless @db_name
        raise Exception("[ERROR] Please use_db() first!")
      end
      unless query_vector
        query_vector = ""
      end
      unless response_fields
        response_fields = Array.new
      end

      response = client.connection.post do |req|
        req.url "/api/#{@db_name}/data/query"
        req.body = {"table": table_name, "queryField": query_field, "queryVector": query_vector, "response": response_fields, "limit": limit, "withDistance": with_distance}.to_json
      end
      return response.status, response.body
    end

    # get 
    def get(table_name= "MyTable", response_fields = nil)
      unless @db_name
        raise Exception("[ERROR] Please use_db() first!")
      end
      unless response_fields
        response_fields = Array.new
      end
      response = client.connection.post do |req|
        req.url "/api/#{@db_name}/data/get"
        req.body = {"table": table_name, "response": response_fields}.to_json
      end
      return response.status, response.body
    end

    # drop table
    def drop_table(table_name)
      unless @db_name
        raise Exception("[ERROR] Please use_db() first!")
      end     
      response = client.connection.delete do |req|
        req.url "/api/#{@db_name}/schema/tables/#{table_name}"
      end
      return response.status, response.body
    end

    # drop db
    def drop_db(db_name)
      response = client.connection.delete do |req|
        req.url "/api/#{@db_name}/drop"
      end
      return response.status, response.body
    end

  end
end
