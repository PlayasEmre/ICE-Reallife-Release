<!--//                                                  \\
--||   Project: MTA - German ICE Reallife Gamemode    ||
--||   Developers: PlayasEmre                         ||
--||   Version: 5.0                                   ||
--\\                                                  //-->
 
 
🛠️ Installationsanleitung für das Script
Um das Script erfolgreich zu installieren und in Betrieb zu nehmen, führen Sie bitte die folgenden Schritte durch:

1. Datenbank-Konfiguration
Navigieren Sie zum Ordner mysql. Hier müssen Sie die Datei mysql_start anpassen, um die Verbindungsinformationen für Ihre Datenbank einzurichten.

2. Allgemeine Server-Einstellungen
Öffnen Sie im Ordner settings die Datei settings.lua. In dieser Konfigurationsdatei können Sie wichtige Parameter wie den Servernamen und andere spezifische Einstellungen nach Ihren Wünschen bearbeiten.

3. Startreihenfolge der Ressourcen
Beim Starten des Servers ist es zwingend erforderlich, die Ressource DGS zuerst zu starten. Achten Sie auf diese Reihenfolge, damit alle Abhängigkeiten korrekt geladen werden.

Nachdem Sie diese Schritte sorgfältig durchgeführt haben, sollte das Script voll funktionsfähig sein.


🛠️ Updates für ICE: Kurz & Einfach
Dieses System sucht automatisch nach Updates, damit Sie sich um nichts kümmern müssen.
1. Update finden (Prüfung)
Der Server prüft automatisch jede Stunde auf eine neue Versionsnummer bei GitHub.
Update-Meldung: Wenn ein Update bereitsteht, sehen alle Administratoren im Chat eine Benachrichtigung. Wenn Sie das Update ignorieren, erhalten Sie jede Stunde eine Erinnerung.
2. Update installieren (Download)
Da der automatische Download ausgeschaltet ist, müssen Sie den Download manuell mit einem Befehl starten:
Geben Sie im Chat ein:
/update ICE

Was passiert danach?
Das System lädt die neuen Dateien herunter.
Die Ressource ICE startet sich danach automatisch einmal neu.
3. Versionsnummer anzeigen
Wenn Sie wissen möchten, welche Version gerade installiert ist:
/ICEver



