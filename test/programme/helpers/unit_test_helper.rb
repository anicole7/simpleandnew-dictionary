require_relative "./sqlitedb_helper.rb"
require_relative "./file_helper.rb"

class UnitTestHelper

    attr_accessor :file_helper
    attr_accessor :sqlitedb_helper

    def initialize
        puts "INITIALISE UNIT TEST HELPER"
        @file_helper = FileHelper.new
        @sqlitedb_helper = SqlitedbHelper.new
    end

    def test_open_file(file_path = nil)
        begin
            @res = @file_helper.open_file(file_path)
        rescue StandardError => e
            p e.message
        end
        return @res
    end

    # FUNCTION TEST BDD #
    def test_open_db(db_name = nil)
        begin
            @res = @sqlitedb_helper.open_db(db_name)
        rescue StandardError => e
            p e.message
        end
        return @res
    end

    def test_get_all_words
        @sqlitedb_helper.get_all("words")
    end

    def test_insert_word(object_hash)
        @sqlitedb_helper.insert("words", object_hash)
    end

    def test_delete_word_by_label(words_label)
        @sqlitedb_helper.delete_by_param("words", "label", words_label)
    end

    def test_search_words_by_wildcards(value)
        @sqlitedb_helper.search("words", "wildcards", value)
    end

    def test_search_words_by_conditions(value)
        @sqlitedb_helper.search("words", "conditions", value)
    end

end

####################### DEBUT DES TEST UNITAIRES #######################

unitTest = UnitTestHelper.new

####################### TEST FILE #######################
p "# TEST FILE #"
p "Did not work, test_open_file('')" if !unitTest.test_open_file('')
p "Did not work, test_open_file('file_inexistant')" if !unitTest.test_open_file('file_inexistant')
p "Did work, test_open_file('./dictionary.text')" if unitTest.test_open_file("./dictionary.text")
p "Did work, test_open_file()" if unitTest.test_open_file()
p "Success at open_file returns " 
p unitTest.file_helper.open_file()
p "Fail at open_file returns " 
p unitTest.file_helper.open_file("")

####################### TEST BDD #######################
### TEST D'OUVERTURE DE BDD ###
p "# TEST BDD #"
p "Did work, test_open_db('')" if unitTest.test_open_db("")
p "Did work, test_open_db('bdd_inexistant.bd')" if unitTest.test_open_db('bdd_inexistant.bd')
p "Did work, test_open_db('./simpleandnewdictionnary.db')" if unitTest.test_open_db('./simpleandnewdictionnary.db')
p "Did work, test_open_db()" if unitTest.test_open_db()
p "Sucess at open_db returns " 
p unitTest.sqlitedb_helper.open_db("")

### SUITE DE TEST D'INSERTION DE WORDS EN BDD ###
p "# TEST INSERTION BDD #"
unitTest.test_insert_word(words = {label: "test", dictionary_id: 1})
words = unitTest.test_get_all_words
p "Did work, test_insert_word(words = {label: 'test', dictionary_id: 1})" if words.count == 1

# TEST CHECK LENGTH of label >= 1
unitTest.test_insert_word(words = {label: '', dictionary_id: 1})
words = unitTest.test_get_all_words
p "Did not work, test_insert_word(words = {label: '', dictionary_id: 1})" if words.count == 1

# TEST CHECK dictionary_id is integer
unitTest.test_insert_word(words = {label: 'test2', dictionary_id: ''})
words = unitTest.test_get_all_words
p "Did not work, test_insert_word(words = {label: 'test2', dictionary_id: ''})" if words.count == 1

# TEST CHECK dictionary_id is > 0
unitTest.test_insert_word(words = {label: 'test2', dictionary_id: 0})
words = unitTest.test_get_all_words
p "Did not work, test_insert_word(words = {label: 'test2', dictionary_id: 0})" if words.count == 1

# TEST UNIQUENESS OF label CONSTRAINT
unitTest.test_insert_word(words = {label: "test", dictionary_id: 1})
words = unitTest.test_get_all_words
p "Did not work, test_insert_word(words = {label: 'test', dictionary_id: 1})" if words.count == 1

# TEST SUPPRESSION DE WORDS EN BDD ###
p "# TEST SUPPRESSION BDD #"
unitTest.test_delete_word_by_label(["test"])
words = unitTest.test_get_all_words
p "Did work, test_delete_word_by_label(['test'])" if words.count == 0

# INSERTION EN MAJUSCULES
unitTest.test_insert_word(words = {label: "TEST", dictionary_id: 1})
words = unitTest.test_get_all_words
p "Did work, test_insert_word(words = {label: 'TEST', dictionary_id: 1})" if words.count == 1

# TEST SUPPRESSION AVEC CASSE
unitTest.test_delete_word_by_label(["test"])
words = unitTest.test_get_all_words
p "Did not work, test_delete_word_by_label(['test'])" if words.count == 1
unitTest.test_delete_word_by_label(["TEST"])
words = unitTest.test_get_all_words
p "Did work, test_delete_word_by_label(['TEST'])" if words.count == 0

# INSERTION DE PLUSIEURS MOTS
unitTest.test_insert_word(words = {label: "TEST1", dictionary_id: 1})
words = unitTest.test_get_all_words
p "Did work, test_insert_word(words = {label: 'TEST1', dictionary_id: 1})" if words.count == 1
unitTest.test_insert_word(words = {label: "TEST2", dictionary_id: 1})
words = unitTest.test_get_all_words
p "Did work, test_insert_word(words = {label: 'TEST2', dictionary_id: 1})" if words.count == 2
unitTest.test_insert_word(words = {label: "TEST3", dictionary_id: 1})
words = unitTest.test_get_all_words
p "Did work, test_insert_word(words = {label: 'TEST3', dictionary_id: 1})" if words.count == 3

# TEST SUPPRESSION PLUSIEURS MOTS D'UN COUP
unitTest.test_delete_word_by_label(["TEST1", "TEST2", "TEST3"])
words = unitTest.test_get_all_words
p "Did work, test_delete_word_by_label(['TEST1', 'TEST2', 'TEST3'])" if words.count == 0

# INSERTION DE MOTS
unitTest.test_insert_word(words = {label: "Z", dictionary_id: 1})
unitTest.test_insert_word(words = {label: "Un", dictionary_id: 1})
unitTest.test_insert_word(words = {label: "Vie", dictionary_id: 1})
unitTest.test_insert_word(words = {label: "Deux", dictionary_id: 1})
unitTest.test_insert_word(words = {label: "Boire", dictionary_id: 1})
unitTest.test_insert_word(words = {label: "Rougir", dictionary_id: 1})
unitTest.test_insert_word(words = {label: "Jardins", dictionary_id: 1})
unitTest.test_insert_word(words = {label: "Ronfler", dictionary_id: 1})
unitTest.test_insert_word(words = {label: "Bonjour", dictionary_id: 1})
unitTest.test_insert_word(words = {label: "Bonsoir", dictionary_id: 1})
unitTest.test_insert_word(words = {label: "Jardiner", dictionary_id: 1})

words = unitTest.test_get_all_words
p "Did work, test_insert_word" if words.count == 11

### TEST DE RECHERCHE ###

p "TEST DE RECHERCHE WILDCARDS"

# Melange correct _ et %
words = unitTest.test_search_words_by_wildcards("_on%")
p "Did work, test_search_words_by_wildcards('_on%')" if words.count == 3
# Melange incorrect _ et %
words = unitTest.test_search_words_by_wildcards("_onaz%")
p "Did work, test_search_words_by_wildcards('_onaz%')" if words.count == 0
# UNIQUEMENT ____
words = unitTest.test_search_words_by_wildcards("____")
p "Did work, test_search_words_by_wildcards('____')" if words.count == 1
# UNIQUEMENT %
words = unitTest.test_search_words_by_wildcards("%")
p "Did work, test_search_words_by_wildcards('%')" if words.count == 11
# TEST %%
words = unitTest.test_search_words_by_wildcards("%%")
p "Did work, test_search_words_by_wildcards('%%')" if words.count == 11

p "TEST DE RECHERCHE CONDITIONS"

# TOUS LES PARAMETRES NIL
words = unitTest.test_search_words_by_conditions({min: nil, max: nil, first: nil, last: nil})
p "Did work, test_search_words_by_conditions({min: nil, max: nil, first: nil, last: nil})" if words.count == 11

# PREMIER ET DERNIER NIL
words = unitTest.test_search_words_by_conditions({min: nil, max: 5, first: 'V', last: nil})
p "Did work, test_search_words_by_conditions({min: nil, max: 5, first: 'V', last: nil})" if words.count == 1

# AUCUN NIL
words =  unitTest.test_search_words_by_conditions({min: 0, max: 10, first: 'B', last: 'r'})
p "Did work, test_search_words_by_conditions({min: 0, max: 10, first: 'B', last: 'r'})" if words.count == 2

# MAUVAISES CONDITIONS
words =  unitTest.test_search_words_by_conditions({min: 2, max: 0, first: 'J', last: 'r'})
p "Did work, test_search_words_by_conditions({min: 2, max: 0, first: 'J', last: 'r'})" if words.count == 0

# CONDITIONS PARTICULIERES
words =  unitTest.test_search_words_by_conditions({min: 1, max: 1, first: 'Z', last: 'Z'})
p "Did work, test_search_words_by_conditions({min: 1, max: 1, first: 'Z', last: 'Z'})" if words.count == 1

# TODO: GERER LE CAS INSENSIBLE A LA CASSE
