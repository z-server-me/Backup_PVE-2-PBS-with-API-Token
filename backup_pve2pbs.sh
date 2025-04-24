#!/bin/bash

# 🔐 Auth avec API Token
export PBS_REPOSITORY="backup@pbs!pveclient@192.168.1.100:marechal-pve"
export PBS_PASSWORD="XXXXXX-XXXXXX-XXXXXXXX-XXXXXXX"

PXAR_NAME="root.pxar"
LOGFILE="/var/log/backup-pve2pbs-token.log"

# 📲 Telegram
TELEGRAM_BOT_TOKEN="XXXXXXXXXX:XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
TELEGRAM_CHAT_ID="-XXXXXXXXXX"
TG_URL="https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendMessage"

# 🕒 Début
START_TIME="$(date)"
echo -e "[$START_TIME]\n🔄 Starting backup of / to $PBS_REPOSITORY as $PXAR_NAME (ID: backup)" > "$LOGFILE"

# 🚀 Backup (avec ID personnalisé)
proxmox-backup-client backup "$PXAR_NAME:/" --repository "$PBS_REPOSITORY" --backup-id backup >> "$LOGFILE" 2>&1
STATUS=$?
END_TIME="$(date)"

if [ "$STATUS" -eq 0 ]; then
    echo -e "\n[$END_TIME]\n✅ Backup completed successfully." >> "$LOGFILE"
else
    echo -e "\n[$END_TIME]\n❌ Backup failed with status $STATUS." >> "$LOGFILE"
fi

# 📦 Retention dynamique
RETENTION=$(proxmox-backup-client snapshot list --repository "$PBS_REPOSITORY" --backup-id backup 2>/dev/null | grep 'keep-' | tail -n1 | tr -d ' ')
[ -n "$RETENTION" ] && echo -e "\n📌 Retention policy: $RETENTION" >> "$LOGFILE"

# ✉️ Telegram en <pre>
LOG_TEXT=$(cat "$LOGFILE" | sed 's/&/\&amp;/g; s/</\&lt;/g; s/>/\&gt;/g')
curl -s -X POST "$TG_URL" \
  -d "chat_id=$TELEGRAM_CHAT_ID" \
  -d "parse_mode=HTML" \
  --data-urlencode "text=<pre>${LOG_TEXT}</pre>" > /dev/null

exit $STATUS
