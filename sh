#!/bin/sh

#to execute, sh sh

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


version=$(wget -qO- https://boninif.github.io/ISH/updated)
echo "SH_VERSION=\"$version\"" > ~/.ashrc

cat << 'EOF' >> ~/.ashrc


REMOTE_VERSION=$(wget -qO- https://boninif.github.io/ISH/updated 2>/dev/null)

if [ -n "$(wget -qO- https://boninif.github.io/ISH/updated 2>/dev/null)" ] && [ "$(wget -qO- https://boninif.github.io/ISH/updated 2>/dev/null)" != "$SH_VERSION" ]; then
    echo "Nuova versione disponibile ($REMOTE_VERSION). Aggiornamento..."
    
   cd ~
    wget -q https://boninif.github.io/ISH/sh
    sh sh
    exit
fi


alias micro='GOGC=off micro'
alias java='/usr/lib/jvm/java-1.8-openjdk/bin/java -Xms64m -Xmx128m -Xint'
alias javac='/usr/lib/jvm/java-1.8-openjdk/bin/javac -J-Xms64m -J-Xmx128m -J-Xint'

# Funzione per compilare ed eseguire

javaB() {
    [ -z "$1" ] && { echo "Uso: javaB <file>.java [argomenti...]"; return 1; }

    FILE="$1"
    shift

    DIR=$(dirname "$FILE")
    MAIN=$(basename "$FILE" .java)

    NEEDS_COMPILE=false

    for f in $(find "$DIR" -name "*.java"); do
        class="${f%.java}.class"

        if [ ! -f "$class" ] || [ "$f" -nt "$class" ]; then
            NEEDS_COMPILE=true
            break
        fi
    done

    if [ "$NEEDS_COMPILE" = true ]; then
        find "$DIR" -name "*.java" | xargs javac \
            -J-Xms64m -J-Xmx128m -J-Xint || return 1
    fi

    java -Xms64m -Xmx128m -Xint -cp "$DIR" "$MAIN" "$@"
}


EOF

echo -e "\nImportante configurazione (10/$n)"
source ~/.ashrc
echo -e "\nAltra altrettanto         (11/$n)"
source ~/.profile


echo -e "\nInstallazione completata con successo, o perlomeno così mi auguro"

cmatrix

