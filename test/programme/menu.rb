require "./helpers/sentences_helper.rb"
require "./helpers/sqlitedb_helper.rb"
require "./helpers/file_helper.rb"

class Menu

    attr_accessor :sentences_helper
    attr_accessor :sqlitedb_helper
    attr_accessor :file_helper

    # Constructeur
    def initialize
        puts "INITIALISE MENU"

        # Déclaration des différents helpers
        @file_helper = FileHelper.new
        @sentences_helper = SentencesHelper.new
        @sqlitedb_helper = SqlitedbHelper.new

        dictionary_data = @file_helper.get_file_data
        dictionary_data.each do |word|
            @sqlitedb_helper.insert("words", {label: word, dictionary_id: 1})
        end

        self.loop
    end

    ####################### Loop Console #######################
    def loop
        @sentences_helper.first_entrie
        while user_input = @sentences_helper.saisie # loop while getting user input

            added_word = ""

            case user_input
            when "1" # Ajouter un mot
                @sentences_helper.prompt_word_to_add
                # On va pouvoir ajouter plusieurs mot séparés par une virgule grâce à .split(',')
                words_to_add = (@sentences_helper.saisie).split(',')

                # A chaque mot son traitement
                words_to_add.each do |word|
                    # Par défaut on ajoute dans le dictionnaire 1
                    if (t = @sqlitedb_helper.insert("words", {label: word, dictionary_id: 1})) != []
                        error = t[:errorMessage]
                        if error.include?("UNIQUE")
                            @sentences_helper.word_exists(word)
                        else
                            @sentences_helper.word_empty
                        end
                    else
                        added_word +=  " #{word}"
                    end
                end
                @sentences_helper.display_words_added(words_to_add, added_word)
                
                # TODO implémenter un helper pour la gestion des erreurs ?

            when "2" # Retirer un ou plusieurs mots
                @sentences_helper.prompt_word_to_remove
                word_to_remove = @sentences_helper.saisie
                @sqlitedb_helper.delete_by_param("words", "label", word_to_remove.split(","))
                # TODO afficher un message de succées ou erreur

            when "3" # Recherche d'un mot 2 méthodes
                @sentences_helper.search_two_choices
                
                # SELECTION DE LA METHODE
                @sentences_helper.prompt
                method_input = @sentences_helper.saisie

                # SI PREMIER CHOIX INCONNU
                if method_input != 'a' && method_input != 'b'
                   @sentences_helper.wrong_method_choice
                end

                # BOUCLE TANT QUE METHODE INCONNUE
                until method_input == 'a' || method_input == 'b'
                    @sentences_helper.prompt
                    method_input = @sentences_helper.saisie

                    if method_input != 'a' && method_input != 'b'
                        @sentences_helper.wrong_method_choice
                    end
                end

                case method_input
                when "a" # METHODE A (4 questions)
                    word_clues = @sentences_helper.a_entrie
                    words = @sqlitedb_helper.search("words", "conditions", word_clues)
                    p words
                    # afficher un message de succées ou erreur

                when "b" # METHODE B (_ et %)
                    word_wildcards = @sentences_helper.description_method_b
                    words = @sqlitedb_helper.search("words", "wildcards", word_wildcards)
                    p words
                    # afficher un message de succées ou erreur

                end

            when "q" # QUIT
                @sentences_helper.bye_sentence
                break
            # PREMIER CHOIX INCONNU
            else
                @sentences_helper.wrong_action_choice
            end

            # FIN DE BOUCLE, AFFICHE LES MOTS DANS LE DICTIONNAIRE
            words = @sqlitedb_helper.get_all("words")
            list = "#{words.count} Mots dans le dictionnaire : "
            words.each_with_index do |label, index|
                list += "#{label} " + ((index+1) < words.count ? ", " : "")
            end
            p list

            # AFFICHAGE A LA FIN D'UNE BOUCLE
            @sentences_helper.end_loop
        end
    end
end

m = Menu.new