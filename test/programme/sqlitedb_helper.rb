# Helper pour la gestion de bdd 

require "sqlite3"

class SqlitedbHelper

    attr_accessor :db

    # Open a database
    def open_db(db_name = nil)
        @db = SQLite3::Database.new db_name ? db_name : "simpleandnewdictionnary.db"
        @db.results_as_hash = true
    end

    # Create a database
    def init_table()
        @db.execute "CREATE TABLE IF NOT EXISTS 
        dictionaries(
            dictionary_id INTEGER PRIMARY KEY AUTOINCREMENT, 
            title TEXT NOT NULL UNIQUE,
            language TEXT NOT NULL
        )"
        @db.execute "CREATE TABLE IF NOT EXISTS 
        words(
            word_id INTEGER PRIMARY KEY, 
            label TEXT NOT NULL UNIQUE, 
            dictionary_id INTEGER NOT NULL,
            FOREIGN KEY (dictionary_id) REFERENCES dictionnaries (id) ON DELETE CASCADE ON UPDATE NO ACTION
        )"
    end

    # Drop databases
    def delete_table(db)
        db.execute "DROP TABLE IF EXISTS dictionaries"
        db.execute "DROP TABLE IF EXISTS words"
    end

    def get_all(table_name)
        data = []
        @db.execute("SELECT * from #{table_name};") do |row|
            data << row
        end

        return data
    end

    def test_insert(db)
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