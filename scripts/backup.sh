#!/bin/bash

DATA=$(date +%Y-%m-%d_%H-%M-%S)

mkdir -p backups/automaticos

docker exec mysql-restored \
mysqldump -u root -p335412 meubanco \
> backups/automaticos/meubanco_$DATA.sql

tar -czf backups/automaticos/backup_$DATA.tar.gz \
backups/automaticos/meubanco_$DATA.sql

echo "Backup concluído com sucesso!"
