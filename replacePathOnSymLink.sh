#
#!/bin/bash
#Скрипт заменяет файлы сертификатов на символические ссылки

#DIR_NAME=[pwd | grep -o '[^/]*$']
DIR_NAME=${PWD##*/} #Получение имени папки текущей директории
DIR_BACKUP=../../ssl_backup/${DIR_NAME} #Путь папки бэкапа сертификатов

main () {
    checkDirectory
    files
}

checkDirectory () {
    [ -d ${DIR_BACKUP} ] || { mkdir ${DIR_BACKUP} }
}

files () {
    if  cp ./* "${DIR_BACKUP}" && rm *.pem ; then
    createSymlink
    else
    exit 1
    fi
}
a=find ../../archive/${DIR_NAME}/ -name "cert[1-99].pem" | wc -l #Вывести количество файлов cert(n).pem
createSymlink () {
 #   a=1
    ln -s ../../archive/${DIR_NAME}/cert${a}.pem cert.pem 
    ln -s ../../archive/${DIR_NAME}/chain${a}.pem chain.pem
    ln -s ../../archive/${DIR_NAME}/fullchain${a}.pem fullchain.pem
    ln -s ../../archive/${DIR_NAME}/privkey${a}.pem privkey.pem
}


#certbot certonly --cert-name <domain> -d <domain> --work-dir /nginx-custom/server/certbot_work_dir \
#--logs-dir /nginx-custom/server/certbot_work_dir \
#--config-dir /nginx-custom/server/ssl \
#--webroot -w /nginx-custom/server/challenge
main
