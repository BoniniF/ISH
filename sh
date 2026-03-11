#!/bin/sh

#to execute, curl -L [url] | sh or similar with wget

mv "$0" installer.sh

echo -e "\n\n\n\n\nBenvenuto, questa è una versione limitata del già piccolo Alpine linux, perciò a breve incomincerà l'installazione di risosrse utili e personalizzazioni per sopperire all'assenza di JIT (just in time) imposta da iPadOS."
echo
 read -p "è raccomandata una connessione ad internet stabile, può assicurare le condizioni siano favorevoli? (y,n) " input

if [ $input != "y" ]
then
echo "è pregato di avviare nuovamente l'installatore quando le condizioni saranno favorevoli"

exit 0
fi

n=11

echo -e "\nAggiornamento apk:    (1/$n)"
apk update

echo -e "\nAggiunta Git:         (2/$n)"
apk add git

echo -e "\nAggiunta micro 	     (3/$n)"
apk add micro

echo -e "\nAggiunta Java 8    	 (4/$n)"
apk add openjdk8 java-common

echo -e "\nAggiunta nano    	 (5/$n)"
apk add nano

echo -e "\nEssenziali: 		     (6/$n)"
apk add sl
echo -e "					     (7/$n)"
apk add cmatrix


echo -e "\nImpostazione profile: (8/$n)"

cat << 'EOF' > ~/.profile

 alias micro='GOGC=off micro'                                                                                                                              
                                                                                                                              
 export ENV="$HOME/.ashrc"   

EOF



echo -e "\nImpostazione ashrc:   (9/$n)"

cat << 'EOF' > ~/.ashrc

alias micro='GOGC=off micro'
alias java='/usr/lib/jvm/java-1.8-openjdk/bin/java -Xms64m -Xmx128m -Xint'
alias javac='/usr/lib/jvm/java-1.8-openjdk/bin/javac -J-Xms64m -J-Xmx128m -J-Xint'

# Funzione per compilare ed eseguire al volo
javaB() {
	            [ -z "$1" ] && { echo "Uso: javaB <nomeFile>.java [argomenti...]"; return 1; }

	                                FILE=$1
	                                                        CLASS_NAME="${FILE%.java}"
	                                                                                    shift # Rimuove il nome del file, lasciando in $@ solo i tuoi argomenti

	                                                                                                                        NEEDS_COMPILE=false

	                                                                                                                                                                # 1. Verifica se qualche .java è più nuovo del relativo .class
	                                                                                                                                                                                                            for f in *.java; do
	                                                                                                                                                                                                                                                                if [ ! -f "${f%.java}.class" ] || [ "$f" -nt "${f%.java}.class" ]; then
	                                                                                                                                                                                                                                                                                                                                NEEDS_COMPILE=true
	                                                                                                                                                                                                                                                                                                                                                                                                            break
	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                fi
	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        done

	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    # 2. Compila solo se necessario
	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    if [ "$NEEDS_COMPILE" = true ]; then
	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            /usr/lib/jvm/java-1.8-openjdk/bin/javac -J-Xms64m -J-Xmx128m -J-Xint *.java || return 1
	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        fi

	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        # 3. Esegue passando tutti i restanti argomenti ($@)
	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            /usr/lib/jvm/java-1.8-openjdk/bin/java -Xms64m -Xmx128m -Xint "$CLASS_NAME" "$@"
	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                }

EOF

echo -e "\nImportante configurazione (10/$n)"
source ~/.ashrc
echo -e "\nAltra altrettanto         (11/$n)"
source ~/.profile


echo -e "\nInstallazione completata con successo, almeno così mi auguro"

cmatrix

