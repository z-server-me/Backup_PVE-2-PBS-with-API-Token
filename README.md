# 🛡️ Backup PVE vers PBS via Token API

## 📦 Objectif

Sauvegarder automatiquement la racine `/` de l'hôte Proxmox VE vers un Proxmox Backup Server en utilisant un **utilisateur dédié avec un token API**, de façon sécurisée, avec **notification Telegram**.

---

## ✅ Fonctionnalités

- 🔐 Authentification via API Token (`backup@pbs!pveclient`)
- 💾 Backup de `/` sous format `pxar`
- 📦 Stocké sous l'ID personnalisé `backup`
- 📩 Envoi du log complet sur Telegram
- 🧹 Affichage de la stratégie de rétention appliquée

---

## ⚙️ Configuration

### 🔐 Authentification
- PBS : `192.168.1.100`
- Datastore : `marechal-pve`
- Utilisateur : `backup@pbs`
- Token ID : `pveclient`
- Droits : `DatastoreBackup` sur `/datastore/marechal-pve`

### 📂 Emplacement du script
`/home/scripts/backup_pve2pbs.sh`

---

## 🕒 Cron jobs recommandés

### 🔁 Sauvegarde les **lundis et jeudis** à **01h50**
50 1 * * 1,4 bash /home/scripts/backup_pve2pbs.sh
---

## 📩 Exemple de notification Telegram
[Thu Apr 24 05:45:37 PM CEST 2025]
🔄 Starting backup of / to backup@pbs!pveclient@192.168.1.100:marechal-pve as root.pxar (ID: backup)

processed 22.9 GiB in 1m, uploaded 19.9 MiB
root.pxar: reused 32.0 GiB (99.7%)
Duration: 81.3s

[Thu Apr 24 05:46:58 PM CEST 2025]
✅ Backup completed successfully.
📌 Retention policy: keep-last=2,keep-weekly=2,keep-monthly=1,keep-yearly=12

---

## 🧠 Astuces

- Les sauvegardes sont visibles dans PBS sous : `host/backup`
- Le token API est plus sécurisé que root@pam et ne nécessite pas de mot de passe PAM
- L’identifiant `backup` évite l'erreur "owner mismatch" avec root@pam

---

## 🛠️ Dépendances

- `proxmox-backup-client` installé sur PVE
- PBS fonctionnel
- Token API configuré dans PBS
- Script Telegram fonctionnel
