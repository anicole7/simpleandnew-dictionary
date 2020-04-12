require "./helpers/sentences_helper.rb"
require "./helpers/sqlitedb_helper.rb"
require "./helpers/file_helper.rb"

# Déclaration des différents helpers
sentences_helper = SentencesHelper.new
sqlitedb_helper = SqlitedbHelper.new
file_helper = FileHelper.new

####################### loop console #######################

sentences_helper.first_entrie

while user_input = sentences_helper.saisie # loop while getting user input

    case user_input
    when "1" # Ajouter un mot
        sentences_helper.prompt_word_to_add
        word_to_add = sentences_helper.saisie
        # TODO chercher le mot et l'ajouter s'il n'existe pas
        # afficher un message de succées ou erreur

    when "2" # Retirer d'un mot
        sentences_helper.prompt_word_to_remove
        word_to_remove = sentences_helper.saisie
        # TODO chercher le mot et le supprimer s'il existe
        # afficher un message de succées ou erreur

    when "3" # Recherche d'un mot 2 méthodes
        sentences_helper.search_two_choices
        
        # SELECTION DE LA METHODE
        sentences_helper.prompt
        method_input = sentences_helper.saisie

        # SI PREMIER CHOIX INCONNU
        if method_input != 'a' && method_input != 'b'
            sentences_helper.wrong_method_choice
        end

        # BOUCLE TANT QUE METHODE INCONNUE
        until method_input == 'a' || method_input == 'b'
            sentences_helper.prompt
            method_input = sentences_helper.saisie

            if method_input != 'a' && method_input != 'b'
                sentences_helper.wrong_method_choice
            end
        end

        case method_input
        when "a" # METHODE A (4 questions)
            word_clues = sentences_helper.a_entrie
            # TODO chercher le(s) mot(s) et le(s) retourner s'il(s) existe(nt)
            # afficher un message de succées ou erreur

        when "b" # METHODE B (_ et %)
            word_wildcards = sentences_helper.description_method_b
            # TODO chercher le(s) mot(s) et le(s) retourner s'il(s) existe(nt)
            # afficher un message de succées ou erreur

        end # METHOD A/B END

    when "q" # QUIT
        sentences_helper.bye_sentence
        break
    # PREMIER CHOIX INCONNU
    else
        sentences_helper.wrong_action_choice
    end

    # AFFICHAGE A LA FIN D'UNE BOUCLE
    sentences_helper.end_loop
end