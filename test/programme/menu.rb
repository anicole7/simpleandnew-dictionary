require "./helpers/sentences_helper.rb"
require "./helpers/sqlitedb_helper.rb"
require "./helpers/file_helper.rb"

# Notre class 'Main'
class Menu

    attr_accessor :sentences_helper
    attr_accessor :sqlitedb_helper
    attr_accessor :file_helper

    # Constructeur
    def initialize
        # Déclaration des différents helpers
        @file_helper = FileHelper.new
        @sentences_helper = SentencesHelper.new
        @sqlitedb_helper = SqlitedbHelper.new

        # Permet l'acces à l'application en attendant que
        # l'import de donnees soit termine
        thr = Thread.new { 
            time = Time.now
            dictionary_data = @file_helper.get_file_data
            dictionary_data.each do |word|
                @sqlitedb_helper.insert("words", {label: word.downcase, dictionary_id: 1})
            end
            time_end = Time.now
            #p "Import termine en " + (time_end - time).to_s + " secondes"
        }

        self.loop
    end

    ####################### Loop Console #######################
    def loop
        @sentences_helper.first_entrie
        while user_input = @sentences_helper.saisie # loop while getting user input

            found_word = ""
            words_to_remove = []

            case user_input
            when "1" # Ajouter un mot --- TERMINE
                @sentences_helper.prompt_word_to_add
                
                # On va pouvoir ajouter plusieurs mot séparés par une virgule grâce à .split(',')
                words_to_add = (@sentences_helper.saisie_string_words_data).split(',')

                # A chaque mot son traitement
                words_to_add.each do |word|

                    # Par défaut on ajoute dans le dictionnaire 1
                    result = @sqlitedb_helper.insert("words", {label: word.downcase, dictionary_id: 1})
                
                    if result != []
                        # Deux cas de non insertion possible
                        result[:errorMessage].include?("UNIQUE") ? @sentences_helper.word_exists(word) : @sentences_helper.word_empty
                    else
                        # Affiche les mots ajoutés au dictionnaire
                        @sentences_helper.display_word_added(word)
                    end
                end

            when "2" # Retirer un ou plusieurs mots séparés par une virgule --- TERMINE
                @sentences_helper.prompt_word_to_remove
                words_to_remove_input = (@sentences_helper.saisie_string_words_data).split(',')

                # Pas de données en retour d'execution du delete donc 
                # on check les mots qui existent parmi ceux selectionnes
                # pas de recheck aprés coup, un peu too much d'aprés moi
                words_to_remove_input.each do |word|
                    unless @sqlitedb_helper.get_one_by_single_param("words", "label", word).empty?
                        words_to_remove << word
                    end
                end
                @sqlitedb_helper.delete_by_param("words", "label", words_to_remove)
                @sentences_helper.words_removed_from_dictionnary(words_to_remove)
                

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
                    p word_clues
                    words = @sqlitedb_helper.search("words", "conditions", word_clues)
                when "b" # METHODE B (_ et %)
                    word_wildcards = @sentences_helper.description_method_b
                    words = @sqlitedb_helper.search("words", "wildcards", word_wildcards)
                end

                if words.count.positive?
                    words.each do |word|
                        found_word += " #{word}"
                    end
                    p "Mots trouves : " + found_word
                else
                    p "Aucun mot ne correspond à cette recherche"
                end

            when "q" # QUIT
                # TODO WRITE current DICTIONARY IN OUR FILE.text
                open('dictionary.text', 'w') do |f|
                    @sqlitedb_helper.get_all("words").each do |word|
                        f << word 
                        f.puts @string
                    end
                end

                @sentences_helper.bye_sentence
                break
            # PREMIER CHOIX INCONNU
            else
                @sentences_helper.wrong_action_choice
            end

            # FIN DE BOUCLE, AFFICHE LES MOTS DANS LE DICTIONNAIRE
            words = @sqlitedb_helper.get_all("words")
            @sentences_helper.words_in_dictionnary(words)
            

            # AFFICHAGE A LA FIN D'UNE BOUCLE
            @sentences_helper.end_loop
        end
    end
end

m = Menu.new