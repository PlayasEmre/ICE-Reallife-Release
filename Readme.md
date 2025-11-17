<!--//                                                  \\
--||   Project: MTA - German ICE Reallife Gamemode    ||
--||   Developers: PlayasEmre                         ||
--||   Version: 5.0                                   ||
--\\                                                  //-->
 
 
Um das Script funktionieren zu installieren musst du unter dem ordner mysql die mysql_start anpassen.
Die settings.lua unter dem ordner settings musst du bearbeiten für um den Servernamen und alles weitere zu editieren.
Beim Server start immer als erstes die Ressource DGS starten.
Hasst du dies alles getan sollte das Script funktionieren.

To install the script you have to adjust the mysql_start under the folder mysql.
You have to edit the settings.lua under the settings folder for to edit the server name and everything else.
When starting the server, always start the resource DGS first.
If you do all of this, the script should work.



🧑‍💻 Kurzanleitung: Update-System ICE
Als Administrator müssen Sie keine Konfigurationsdateien (wie Tokens oder Intervalle) ändern. Die automatische Versionsprüfung und die Sicherheitseinstellungen werden zentral verwaltet.
1. So funktioniert die Prüfung
Das Skript prüft automatisch alle 1 Stunde (oder dem eingestellten Intervall) auf eine neue Versionsnummer bei GitHub.
Kein Update verfügbar: Sie sehen keine Meldung. Die Ressource ist aktuell.
Update verfügbar: Wenn die Version bei GitHub höher ist, erhalten alle Administratoren (Admin Level 9+) sofort eine Chat-Benachrichtigung, gefolgt von einer Erinnerung alle 36 Sekunden.
2. Update auslösen (Download und Installation)
Da der automatische Download deaktiviert ist (AUTO_DOWNLOAD_ENABLED = false), müssen Sie den Download manuell autorisieren.
Geben Sie den folgenden Befehl im Chat ein, um den Update-Prozess zu starten:
/update ICE


Was passiert dann?
Der Server stoppt alle Prüf-Timer.
Das Skript lädt alle geänderten Dateien herunter.
Nach Abschluss des Downloads startet sich die Ressource ICE automatisch neu, um die Änderungen zu übernehmen.
3. Versionsprüfung
Um jederzeit die aktuell installierte Version auf dem Server anzuzeigen, nutzen Sie:
/ICEver
