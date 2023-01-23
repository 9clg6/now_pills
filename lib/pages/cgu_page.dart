import 'package:flutter/material.dart';
import 'package:now_pills/constants.dart';

class CGUPage extends StatelessWidget {
  const CGUPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("CGU", style: TextStyle(color: Colors.white)),
        backgroundColor: mainColor,
        leading: IconButton(
          onPressed: Navigator.of(context).pop,
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white,),
        ),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          child: SingleChildScrollView(
            child: Column(
              children: const [
                Text("CONTRAT GENERALE D'UTILISATION", style: cguTitle),
                Divider(),
                Text("1. Introduction", style: cguTitle),
                Text("Ce contrat d'utilisation régit l'utilisation de l'application de notification NowPills développée par Clément Guyon. En utilisant l'Application, vous acceptez les termes et conditions de ce Contrat. Si vous n'acceptez pas les termes et conditions d'utilisations', vous ne devez pas utiliser l'application. Cette application est une application de notifications, la thématique choisie (les médicaments) est à but purement marketing. Cette application n'a pas vocation à remplacer votre responsabilité vis-à-vis de votre santé. La non-prise de votre traitement n'implique que vous et aucune responsabilité ne pourra être imputé à NowPills en cas de manquement de votre part."),
                Divider(),
                Text("2. Utilisation de l'application", style: cguTitle),
                Text("L'application est un outil informatif destiné à aider les utilisateurs à se souvenir lorsqu'ils doivent prendre leurs médicaments. Elle permet aux utilisateurs de saisir le nom du médicament, le nombre de prises par jour, les horaires où ils doivent les prendre et la durée du traitement. Lorsque l'heure de leur traitement arrive, les utilisateurs reçoivent une notification sonore sur leur téléphone."),
                Divider(),
                Text("3. Avertissement de santé", style: cguTitle),
                Text("L'application ne remplace pas un médecin et ne donne pas de conseil médical. Elle ne fournit pas d'informations sur des médicaments ou des maladies et ne fait pas de diagnostic. Les utilisateurs doivent consulter un médecin pour toute question ou préoccupation concernant leur santé."),
                Divider(),
                Text("4. Responsabilité", style: cguTitle),
                Text("Nous ne serons pas responsables des dommages, y compris, sans s'y limiter, les dommages directs, indirects, spéciaux, accessoires ou consécutifs, découlant de l'utilisation ou de l'incapacité à utiliser l'application. Nous ne garantissons pas que l'Application sera sans erreur, fiable ou disponible à tout moment."),
                Divider(),
                Text("5. Propriété intellectuelle", style: cguTitle),
                Text("L'Application et tous les droits de propriété intellectuelle y afférents (y compris les droits d'auteur, marques commerciales, brevets, etc.) sont la propriété exclusive de Nous. Toute utilisation non autorisée de l'application ou de ses droits de propriété intellectuelle est strictement interdite."),
                Divider(),
                Text("6. Modification du Contrat", style: cguTitle),
                Text("Nous nous réservons le droit de modifier les termes et conditions de ce Contrat à tout moment. Si nous le faisons, nous afficherons les modifications sur cette page et vous serez responsable de vérifier régulièrement cette page pour les modifications."),
                Divider(),
                Text("7. Résiliation", style: cguTitle),
                Text("Nous nous réservons le droit de résilier ce Contrat à tout moment, pour quel que raison que ce soit, sans préavis. Si nous résilions ce Contrat, vous ne pourriez plus utiliser l'application."),
                Divider(),
                Text("8. Loi applicable et juridiction", style: cguTitle),
                Text("Ce Contrat sera régi et interprété conformément aux lois françaises et tout litige découlant de ou lié à ce contrat sera soumis à la juridiction exclusive des tribunaux de Lyon."),
                Divider(),
                Text("9. Acceptation du Contrat", style: cguTitle),
                Text("En utilisant l'application, vous acceptez les termes et conditions de ce Contrat. Si vous n'acceptez pas les termes et conditions de ce Contrat, vous ne devez pas utiliser l'application."),
                Divider(),
                Text("10. Contactez-nous", style: cguTitle),
                Text("Si vous avez des questions concernant ce Contrat, veuillez nous contacter à l'adresse e-mail clement.guyon1@gmail.com."),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

