Meteor.startup ->
    add = (word, fr, en, de) ->
        if (Lang.find {word:word}).count() > 0
            console.log 'BootstrapLang: word already added: '+word
        else
            Lang.insert {
                word:word
                fr:fr
                en:en
                de:de
            }

    Lang.remove {}

    add 'Activities', 'Activités', 'Activities', 'Aktivitäten'
    add 'Settings', 'Réglages', 'Settings', 'Settings'
    add 'Logout', 'Sortir', 'Logout', 'Logout'

    add 'Loading', 'Chargement', 'Loading', 'Loading'

    add 'Width', 'Largeur', 'Width', 'Breite'
    add 'width', 'largeur', 'width', 'Breite'
    add 'Length', 'Longueur', 'Length', 'Länge'
    add 'length', 'longueur', 'length', 'Länge'
    add 'Height', 'Hauteur', 'Height', 'Höhe'
    add 'height', 'hauteur', 'height', 'Höhe'

    # change password page
    add 'changePassword', 'Changement de mot de passe', 'Change password', 'Passwort Ändern'
    add 'currentPassword', 'Mot de passe actuel', 'Current password', 'Aktuelles Passwort'
    add 'newPassword', 'Nouveau mot de passe', 'New password', 'Neues Passwort'
    add 'changePasswordButton', 'Valider', 'Validate', 'Validieren'

    # activities names
    add 'Levers', 'Loi des leviers', "Levers' law", 'Hebelgesetz'
    add 'TruckLoad', 'Répartition de la charge (camion)', 'Load distribution (truck)', 'Lastverteilung (Lastwagen)'
    add 'OrderQuantity', 'Quantité de commande', 'Order quantity', 'Bestellmenge'
    add 'Palletizing', 'Palettisation', 'Palletizing', 'Palettierung'

    # general terms
    add 'NewCustomActivity', 'Nouvelle activité', 'New activity', 'Neue Aktivität'
    add 'Description', 'Description', 'Description', 'Beschreibung'
    add 'Done', 'Terminé', 'Done', 'Fertig'
    add 'DownloadPDF', 'Télécharger PDF', 'Download PDF', 'PDF herunterladen'

    # levers' law
    add 'Lever', 'Levier', 'Lever', 'Hebel'
    add 'Mass', 'Masse', 'Mass', 'Masse'
    add 'Position', 'Position', 'Position', 'Position'
    add 'Side', 'Côté', 'Side', 'Seite'

    add 'leverFixedPallets', 'Palettes fixes', 'Fixed pallets', 'Feste Paletten'
    add 'leverTangiblePallets', 'Palettes tangibles', 'Tangible pallets', 'Greifbare Paletten'

    # truckLoad
    add 'Pallets', 'Palettes', 'Pallets', 'Paletten'
    add 'Customer', 'Client', 'Customer', 'Kunde'
    add 'TypeOfActivity',"Type d'activité",'Type of activity','Aktivitätstyp'
    add 'VehicleLength', 'Longueur du véhicule','Vehicle length','Wagen länge'
    add 'Truck', 'Camion', 'Truck', 'Lastwagen'
    add 'Wagon', 'Wagon', 'Wagon', 'Wagen'

    # load-bearing capacity
    add 'LoadBearing', 'Charge au sol', 'Load-bearing capacity', 'Bodenbelastung'
    add 'StorageSurface', 'Surface de stockage', 'Storage surface', 'Lagerbereich'
    add 'MaximalLoad', 'Charge max.', 'Max. load', 'Max. Bodenbelastung'

    # order quantity
    add 'Customers', 'Clients', 'Customers', 'Kunden'
    add 'Demand', 'Demande', 'Demand', 'Bestellmenge'
    add 'palletsPerDay', 'palettes/jour', 'pallets/day', 'Paletten/Tag'
    add 'Suppliers', 'Fournisseurs', 'Suppliers', 'Lieferanten'
    add 'DeliveryDelay', 'Délai de livraison', 'Delivery delay', 'Lieferzeit'
    add 'days', 'jours', 'days', 'Tage'
    add 'RandomVariations', 'Variations aléatoires', 'Random variations', 'Zufällige Variationen'
    add 'pallets', 'palettes', 'pallets', 'Paletten'
    add 'Costs', 'Coûts', 'Costs', 'Kosten'
    add 'OrderCosts', 'Coûts de passation de commande', 'Order costs', 'Bestellkosten Konstant'
    add 'StorageCosts', 'Coûts de stockage', 'Storage costs', 'Lagerkostensatz'

    # palletization
    add 'PalletHeight', 'Hauteur de la palette', 'Pallet height', 'Palettenhöhe'
    add 'Boxes', 'Paquets', 'Boxes', 'Pakete'
    add 'mass', 'masse', 'mass', 'Masse'
