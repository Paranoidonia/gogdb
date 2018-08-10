#!/bin/sh
DATABASE='gogdb'
DUMP_CMDS='/etc/gogdb/backupcsv.psql'
BACKUP_CSV='/var/local/gogdb/backups/csv'
BACKUP_PSQL='/var/local/gogdb/backups/psql'

set -e

month=`date '+%Y-%m'`
today=`date '+%Y-%m-%d'`

mkdir -p "$BACKUP_PSQL/$month"
mkdir -p "$BACKUP_CSV/$month"

# Postgres custom dump
pg_dump -F custom "$DATABASE" -f "$BACKUP_PSQL/$month/gogdb_$today.dump"
cd "$BACKUP_PSQL"
find * -name "*.dump" | sort > "$BACKUP_PSQL/filelist.txt"

# CSV export
tempdir=`mktemp -d`
cd "$tempdir"
psql "$DATABASE" -f "$DUMP_CMDS"
zip "$BACKUP_CSV/$month/gogdb_$today.zip" *.csv
rm -r "$tempdir"
cd "$BACKUP_CSV"
find * -name "*.zip" | sort > "$BACKUP_CSV/filelist.txt"

