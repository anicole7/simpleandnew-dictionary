# Helper pour la gestion de bdd 

require_relative "./bdd_structure_helper.rb"
require_relative "./word_sqlite_request_helper.rb"

require "sqlite3"

class SqlitedbHelper

    attr_accessor :sqlitedb_helper
    attr_accessor :word_sqlite_request_helper
    attr_accessor :bdd_structure_helper

    # Constructeur
    def initialize(db_name = nil)
        puts "INITIALISE DB HELPER"
        @bdd_structure_helper = BddStructureHelper.new
        @word_sqlite_request_helper = WordSqliteRequestHelper.new

        open_db(db_name)
        delete_table
        init_table
    end

    # Open a database and return the sqlite3 Object
    def open_db(db_name = nil)
        if db_name != nil && !db_name.empty?
            # Créera automatiquement la base même si elle n'existe pas
            @sqlitedb_helper = SQLite3::Database.new db_name 
        else
            # Par défaut ouvre simpleandnewdictionnary.db
            @sqlitedb_helper = SQLite3::Database.new "simpleandnewdictionnary.db"
        end
        @sqlitedb_helper.results_as_hash = true

        return @sqlitedb_helper
    end

    # Create a database
    def init_table
        @bdd_structure_helper.get_tables_structure.each do |table_structure|
            execute_request(table_structure)
        end
    end

    # Drop databases
    def delete_table
        @bdd_structure_helper.get_table_list.each do |table_name|
            execute_request("DROP TABLE IF EXISTS #{table_name}")
        end
    end

    # Select * from a table
    def get_all(table_name)
        data = execute_request("SELECT * from #{table_name};") 
    end

    # Insert object in a table
    def insert(table_name, object_hash)
        result = []
        request_values = nil

        case table_name
        when "words"
            request_values = @word_sqlite_request_helper.insert_word(object_hash)
        when "dictionaries"
            request_values = @dictionary_sqlite_request_helper.insert_dictionary(object_hash)
        end

        # request_values[0] for request string, request_values[1] for values
        result = execute_request(request_values[0], request_values[1])
        return result
    end

    # Delete object(s) from a table with a specific parameter
    def delete_by_param(table_name, param, values)
        result = []

        case table_name
        when "words"
            request = @word_sqlite_request_helper.public_send("delete_#{table_name}_by_#{param}", values)
        when "dictionaries"
            request = @dictionary_sqlite_request_helper.public_send("delete_#{table_name}_by_#{param}", values)
        end

        result = execute_request(request)
        return result
    end

    def search(table_name, method, value)
        case table_name
        when "words"
            request = @word_sqlite_request_helper.public_send("search_#{table_name}_by_#{method}", value)
        when "dictionaries"
            request = @dictionary_sqlite_request_helper.public_send("search_#{table_name}_by_#{method}", value)
        end

        p request
        result = execute_request(request)
        p result
        return result
    end

    # Request execution
    def execute_request(request, params = nil)
        result = []

        begin
            if params
                @sqlitedb_helper.execute(request, params) do |row|
                    result << row
                end
            else
                @sqlitedb_helper.execute(request) do |row|
                    result << row
                end
            end
        rescue => exception
            p exception
            return false
        end
        
        return result
    end

end
