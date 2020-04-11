# Helper qui va structurer les requêtes pour la table Words

class WordSqliteRequestHelper

    def initialize
        puts "INITIALISE WORD REQUEST HELPER"
    end

    # Insert Word structured as a HASH
    def insert_word(word)
        key_num = 1
        values = []
        request = "INSERT INTO words ("
        interpolValues = "VALUES ("

        word.each { |key, value| 
            request += "#{key}" 
            interpolValues += "?"
            values << value

            if key_num < word.keys.count
                request += ", "  
                interpolValues += ", " 
            end

            key_num += 1
        }
        request += ") " + interpolValues +")"

        return request, values
    end
end