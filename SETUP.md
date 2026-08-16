# ICE Reallife – Einrichtungsanleitung

Diese Anleitung richtet sich an alle, die diesen Gamemode auf einem eigenen
MTA:SA-Server zum Laufen bringen wollen – auch ohne Vorerfahrung als
Entwickler.

## 1. Voraussetzungen

- Ein laufender **MTA:SA-Server** (Windows), Version passend zu 1.6.
- Ein **MySQL/MariaDB-Server**. Am einfachsten über [XAMPP](https://www.apachefriends.org/)
  (bringt MySQL direkt mit, kein separates Installieren nötig).
- Grundkenntnisse im Bearbeiten von Textdateien (die Konfiguration erfolgt
  über einfache `.lua`- und `.conf`-Dateien, kein Programmieren nötig).

## 2. Ressource einspielen

1. Den kompletten `ICE`-Ordner nach `server/mods/deathmatch/resources/` kopieren.
2. Der Ordnername sollte `ICE` bleiben (das ist gleichzeitig der Ressourcen-Name,
   mit dem der Server sie später startet).

## 3. Datenbank einrichten

Das Skript legt seine komplette Datenbankstruktur **automatisch selbst an** –
es wird keine separate `.sql`-Datei mehr importiert oder benötigt.

1. XAMPP starten, MySQL-Dienst starten.
2. Über phpMyAdmin (oder die MySQL-Konsole) eine **leere** Datenbank anlegen,
   z.B. mit dem Namen `reallife`. Es müssen keine Tabellen angelegt werden –
   das übernimmt das Skript beim ersten Start von selbst.
3. Zugangsdaten eintragen in [mysql/mysql_start.lua](mysql/mysql_start.lua)
   (Zeile 8-11):

   ```lua
   gMysqlHost = "127.0.0.1"   -- MySQL-Server-Adresse (bei XAMPP auf demselben PC: 127.0.0.1)
   gMysqlUser = "root"        -- MySQL-Benutzername
   gMysqlPass = ""            -- MySQL-Passwort (bei XAMPP-Standard leer)
   gMysqlDatabase = "reallife" -- Name der in Schritt 2 angelegten Datenbank
   ```

Beim ersten Start des Servers meldet die Server-Konsole, wie viele Tabellen
neu angelegt wurden (`[DB-Setup] ... Tabelle(n) angelegt ...`). Bei jedem
weiteren Start werden nur noch fehlende, neu hinzugekommene Tabellen ergänzt –
bestehende Daten werden nie angefasst.

## 4. Server-Konfiguration (mtaserver.conf)

In `server/mods/deathmatch/mtaserver.conf`:

1. Die Ressource zum Autostart hinzufügen:

   ```xml
   <resource src="ICE" startup="1" protected="0" />
   ```

2. Servername, Slots, Passwort etc. nach Wunsch anpassen (Standard-MTA-Einstellungen,
   nicht spezifisch für dieses Skript).

## 5. Server starten

1. `MTA Server.exe` (bzw. `MTA64 Server.exe`) im `server`-Ordner starten.
2. In der Server-Konsole sollte `ICE-Reallife` als laufende Ressource erscheinen
   und keine roten Fehlermeldungen zeigen. Meldungen mit `[DB-Setup]` bestätigen
   den automatischen Datenbank-Aufbau (siehe Schritt 3).
3. Mit MTA:SA verbinden, Account per `/register` anlegen, danach `/login`.

## 6. Ersten Admin-Account einrichten

Da es anfangs noch keine Admins gibt, muss der allererste Admin direkt in der
Datenbank gesetzt werden:

1. In phpMyAdmin die Tabelle `userdata` öffnen.
2. Bei der eigenen Zeile (per `UID`, zu finden über die Tabelle `players`,
   Spalte `Name`) das Feld `Adminlevel` auf einen hohen Wert setzen (z.B. `6`).
3. Im Spiel neu einloggen – die Adminrechte sind dann aktiv, weitere Admins
   lassen sich danach bequem über die Admin-Befehle im Spiel vergeben.

## 7. Web-Panel – optional

Das Web-Panel ist eine **separate PHP-Webseite** (eigenes Projekt, liegt
üblicherweise unter `C:\xampp\htdocs\WebPanel`, läuft über Apache/PHP aus
XAMPP) – nicht Teil dieser MTA-Ressource. Spieler können sich dort einloggen
und z.B. Fahrzeuge, Fraktion, Inventar, Haus, Ranglisten einsehen und (falls
Coins aktiviert sind) Premium/Coins verwalten; Admins bekommen zusätzlich
Spielerliste, Kick/Bann, Screenshots und Log-Einsicht direkt über den Browser.

Die Verbindung läuft in zwei Richtungen:

- **Panel → Datenbank**: Das Panel liest die meisten Daten (Geld, Fraktion,
  Fahrzeuge, ...) direkt aus derselben MySQL-Datenbank wie das MTA-Skript.
- **Panel → MTA-Server (live)**: Für Live-Funktionen (aktuelle Spielerliste,
  Kick, Bann, Screenshot, Nachricht senden, Logs) ruft das Panel Funktionen
  in [webpanel/webpanel_server.lua](webpanel/webpanel_server.lua) per HTTP auf
  (in `meta.xml` mit `http="true"` exportiert).

### Einrichtung

1. Den `WebPanel`-Ordner nach `C:\xampp\htdocs\WebPanel` kopieren (Apache in
   XAMPP starten).
2. In `WebPanel/cfg.php` folgendes prüfen/anpassen (die Datei ist bereits
   ausführlich kommentiert):
   - MySQL-Zugangsdaten (Zeile ~269) – **müssen exakt** zu
     `mysql/mysql_start.lua` passen (Host, Nutzer, Passwort, Datenbankname).
   - `MTA_IP`, `MTA_PORT` (Standard `22003`), `MTA_HTTP_PORT` (Standard `22005`).
   - `MTA_USER` / `MTA_PASS`: ein MTA-Account mit Admin-Rechten in der ACL,
     über den das Panel sich beim Server anmeldet.
   - `SERVER_TIMEZONE`: muss zur Zeitzone passen, in der der MTA-Server läuft
     (sonst sind Zeitban-Längen falsch berechnet).
   - `ICE_RESOURCE_PFAD`: Pfad zum `ICE`-Ordner auf diesem Rechner (für das
     Auslesen der Log-Dateien).
3. In `mtaserver.conf` die IP-Adresse des Webservers eintragen:
   ```xml
   <http_dos_exclude>127.0.0.1</http_dos_exclude>
   <auth_serial_http_ip_exceptions>127.0.0.1</auth_serial_http_ip_exceptions>
   ```
   (`127.0.0.1`, falls Panel und MTA-Server auf demselben Rechner laufen –
   sonst die tatsächliche IP des Webservers.)
4. Falls der MTA-Account durch "Authorized Serial Account Protection"
   geschützt ist, zusätzlich `MTA_HTTP_CODE` setzen (Anleitung dazu direkt in
   `cfg.php`, Abschnitt "Zugangscode für die HTTP-Schnittstelle").

Ohne dieses Panel läuft der Gamemode komplett normal weiter – es ist ein
optionales Zusatzwerkzeug, keine Voraussetzung.

## 8. Typische Stolperfallen

- **"Verbindung zum MySQL-Server kann nicht hergestellt werden"**: MySQL-Dienst
  läuft nicht, oder die Zugangsdaten in `mysql/mysql_start.lua` stimmen nicht.
- **Ressource startet nicht**: Serverkonsole nach der genauen Fehlermeldung
  durchsuchen – meist ein Tippfehler in `meta.xml` oder eine fehlende Datei.
- **Datenbank-Backup**: Wird nicht automatisch vom Skript erledigt. Empfohlen:
  regelmäßiger `mysqldump`-Export per Windows-Aufgabenplanung (kann bei Bedarf
  separat eingerichtet werden).
