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

    def delete_words_by_label(words_label)
        word_num = 1
        count = words_label.count

        request = "DELETE FROM words WHERE label in ("
        words_label.each do |label|
            request += "'" + label + "'"

            if word_num < count
                request += ", "
            end

            word_num += 1
        end
        request += ")"

        return request
    end

    def search_words_by_wildcards(word_wildcards)
        request = "SELECT * FROM words WHERE label LIKE '#{word_wildcards}'"
    end

    def search_words_by_conditions(conditions_values)
        min = conditions_values[:min]
        max = conditions_values[:max]
        first = conditions_values[:first]
        last = conditions_values[:last]

        request = "SELECT * from words WHERE "
        request += " LENGTH(label) >= #{min}" if min
        request += " and LENGTH(label) <= #{max}" if max
        # SUBSTRING(colName, 1, 1) --- for first letter
        request += " and SUBSTR(label, 1, 1) = '#{first}'" if first
        # SUBSTR(column, LENGTH(column) - 3, 4) --- for 4 last_letter
        request += " and SUBSTR(label, LENGTH(label), 1) = '#{last}'" if last
    end
end