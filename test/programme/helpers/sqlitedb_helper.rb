# Helper pour la gestion de bdd 

require_relative  "./word_sqlite_request_helper.rb"

require "sqlite3"

class SqlitedbHelper

    attr_accessor :sqlitedb_helper
    attr_accessor :sqlitedb_words_helper

    def initialize(db_name = nil)
        puts "INITIALISE DB HELPER"
        open_db(db_name)
        delete_table
        init_table

        @sqlitedb_words_helper = WordSqliteRequestHelper.new
    end

    # Open a database
    def open_db(db_name = nil)
        @sqlitedb_helper = SQLite3::Database.new db_name ? db_name : "simpleandnewdictionnary.db"
        @sqlitedb_helper.results_as_hash = true
    end

    # Create a database
    def init_table
        execute_request("CREATE TABLE IF NOT EXISTS 
        dictionaries(
            dictionary_id INTEGER PRIMARY KEY AUTOINCREMENT, 
            title TEXT NOT NULL UNIQUE,
            language TEXT NOT NULL
        )")

        execute_request("CREATE TABLE IF NOT EXISTS 
        words(
            word_id INTEGER PRIMARY KEY AUTOINCREMENT, 
            label TEXT NOT NULL UNIQUE, 
            dictionary_id INTEGER NOT NULL,
            FOREIGN KEY (dictionary_id) REFERENCES dictionnaries (id) ON DELETE CASCADE ON UPDATE NO ACTION
        )")
    end

    # Drop databases
    def delete_table
        execute_request("DROP TABLE IF EXISTS dictionaries")
        execute_request("DROP TABLE IF EXISTS words")
    end

    def get_all(table_name)
        data = execute_request("SELECT * from #{table_name};") 
    end

    def insert(table_name, object_hash)
        request_values = nil
        result = []

        case table_name
        when "words"
            request_values = @sqlitedb_words_helper.insert_word(object_hash)
        when "dictionaries"
            request_values = @sqlitedb_dictionaries_helper.insert_dictionary(object_hash)
        end

        #puts request_values

        result = execute_request(request_values[0], request_values[1])
    end

    def execute_request(request, params = nil)
        result = []

        if params
            @sqlitedb_helper.execute(request, params) do |row|
                result << row
            end
        else
            @sqlitedb_helper.execute(request) do |row|
                result << row
            end
        end

        return result
    end

    # ############### A REVOIR

    def test_insert
        # Execute a few inserts
        test_words = []
        test_dictionaries = {title: "Larousse 2020", language: "Francais"}

        @title = test_dictionaries[:title]
        @language = test_dictionaries[:language]

        begin
            db.execute "INSERT INTO dictionaries (title, language) values (?, ?)", [@title, @language]
        rescue => exception
            p exception
        end

        db.execute("select * from dictionaries") do |row|
            @dictionary = row
        end

        test_words << { label: "tornade",  dictionary_id: @dictionary["dictionary_id"] }
        test_words << { label: "annoncer", dictionary_id: @dictionary["dictionary_id"] }
        test_words << { label: "pointu",   dictionary_id: @dictionary["dictionary_id"] }
        test_words << { label: "palette",  dictionary_id: @dictionary["dictionary_id"] }
        test_words << { label: "saveur",   dictionary_id: @dictionary["dictionary_id"] }

        p test_words

        test_words.each do |words|
            db.execute "INSERT INTO words (label, dictionary_id) VALUES (?, ?)", words[:label], words[:dictionary_id]
        end

        #Execute inserts with parameter markers
        #db.execute("INSERT INTO students (name, email, grade, blog) VALUES (?, ?, ?, ?)", [@name, @email, @grade, @blog])

        db.execute("select * from words") do |row|
            @words = row
            p row
        end
    end

end