--//                                                 \\
--||   Project: MTA - German ICE Reallife Gamemode    ||
--||   Developers: PlayasEmre                         ||
--||   Version: 5.0                                   ||
--\\                                                 //
 
🛠️ Installationsanleitung für das Script Um das Script erfolgreich zu installieren und in Betrieb zu nehmen, führen Sie bitte die folgenden Schritte durch:

Datenbank-Konfiguration Navigieren Sie zum Ordner mysql. Hier müssen Sie die Datei mysql_start anpassen, um die Verbindungsinformationen für Ihre Datenbank einzurichten.

Allgemeine Server-Einstellungen Öffnen Sie im Ordner settings die Datei settings.lua. In dieser Konfigurationsdatei können Sie wichtige Parameter wie den Servernamen und andere spezifische Einstellungen nach Ihren Wünschen bearbeiten.

Startreihenfolge der Ressourcen Beim Starten des Servers ist es zwingend erforderlich, die Ressource DGS zuerst zu starten. Achten Sie auf diese Reihenfolge, damit alle Abhängigkeiten korrekt geladen werden.

Nachdem Sie diese Schritte sorgfältig durchgeführt haben, sollte das Script voll funktionsfähig sein.

🛠️ Updates für ICE: Sicher & Kontrolliert Dieses System überwacht Ihren Server-Status automatisch. Sie behalten die volle Kontrolle darüber, wann Updates installiert werden.

Automatische Überprüfung Der Server prüft jede Stunde im Hintergrund, ob auf GitHub eine neue Version verfügbar ist.

Update-Benachrichtigung Sollte eine neue Version bereitstehen, erhalten alle Administratoren automatisch eine Benachrichtigung im Chat. Falls das Update noch nicht installiert wurde, werden die Administratoren stündlich daran erinnert.

Manuelle Installation Um die Sicherheit zu gewährleisten, wird kein Update automatisch installiert. Sie entscheiden, wann der richtige Zeitpunkt für einen Neustart ist. Geben Sie dazu einfach den folgenden Befehl im Chat ein: /update ICE

Was passiert danach?

Das System lädt die neuen Dateien direkt von GitHub herunter.
Die Ressource ICE startet sich nach Abschluss des Updates automatisch einmal neu.
