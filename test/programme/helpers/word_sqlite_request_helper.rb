# Helper qui va structurer les requêtes pour la table Words

class WordSqliteRequestHelper

    def initialize
        # puts "INITIALISE WORD REQUEST HELPER"
    end

    def get_words_by_label(label)
        return "SELECT * FROM words WHERE label = '#{label}'"
    end

    def get_all_words
        return "SELECT * FROM words"
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

        word_count = words_label.count

        request = "DELETE FROM words WHERE label in ("
        words_label.each do |label|
            request += "'" + label + "'"

            if word_num < word_count
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

        unless conditions_values.values.any?
            request = "SELECT * from words"
            return request
        end

        and_flag = false
        and_sentence = " and"

        min = conditions_values[:min].to_s
        max = conditions_values[:max].to_s
        first = conditions_values[:first].to_s
        last = conditions_values[:last].to_s

        request = "SELECT * from words WHERE"

        if min && !min.empty?
            request += " LENGTH(label) >= #{min}"
            and_flag = true
        end

        if max && !max.empty?
            max_cond = " LENGTH(label) <= #{max}"
            request += and_flag ? (and_sentence + max_cond) : max_cond
            and_flag = true
        end

        if first && !first.empty?
            first_cond = " SUBSTR(label, 1, 1) = '#{first}'"
            request += and_flag ? (and_sentence + first_cond) : first_cond
            and_flag = true
        end

        if last && !last.empty?
            last_cond = " SUBSTR(label, LENGTH(label), 1) = '#{last}'"
            request += and_flag ? (and_sentence + last_cond) : last_cond
            and_flag = true
        end

        return request
    end

    def format_words_result(words_values)
        result = []

        words_values.each do |word|
            result << word["label"]
        end

        return result
    end
end