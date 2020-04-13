# Helper pour la gestion de la base de donnée

class BddStructureHelper

    def initialize
        # puts "INITIALISE BDD STRUCTURE HELPER"
    end

    def get_table_list
        table_list = ["words", "dictionaries"]

        return table_list
    end

    def get_tables_structure
        tables_structure = []
        self.get_table_list.each do |table|
            tables_structure << public_send("get_#{table}_table_structure")
        end

        return tables_structure
    end

    def get_words_table_structure
        return "CREATE TABLE IF NOT EXISTS 
        words(
            word_id INTEGER PRIMARY KEY AUTOINCREMENT, 
            label TEXT NOT NULL UNIQUE CHECK(length(label) >= 1), 
            dictionary_id INTEGER NOT NULL CHECK(typeof(dictionary_id) = 'integer' and dictionary_id > 0),
            FOREIGN KEY (dictionary_id) REFERENCES dictionnaries (id) ON DELETE CASCADE ON UPDATE NO ACTION
        )"
    end

    def get_dictionaries_table_structure
        return "CREATE TABLE IF NOT EXISTS 
        dictionaries(
            dictionary_id INTEGER PRIMARY KEY AUTOINCREMENT, 
            title TEXT NOT NULL UNIQUE CHECK(length(title) >= 1),
            language TEXT NOT NULL
        )"
    end

end
