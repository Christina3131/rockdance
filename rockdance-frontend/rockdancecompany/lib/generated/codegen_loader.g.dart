// DO NOT EDIT. This is code generated via package:easy_localization/generate.dart

// ignore_for_file: prefer_single_quotes, avoid_renaming_method_parameters, constant_identifier_names

import 'dart:ui';

import 'package:easy_localization/easy_localization.dart' show AssetLoader;

class CodegenLoader extends AssetLoader{
  const CodegenLoader();

  @override
  Future<Map<String, dynamic>?> load(String path, Locale locale) {
    return Future.value(mapLocales[locale.toString()]);
  }

  static const Map<String,dynamic> _en = {
  "nav.home": "Home",
  "nav.about": "About",
  "nav.calendar": "Calendar",
  "nav.contact": "Contact Us",
  "nav.login": "Log in",
  "nav.signup": "Sign up",
  "nav.members": "Members",
  "home.welcomeTitle": "Welcome to the Rock Dance Company app!",
  "home.welcomeBody": "In this app, you can discover more about our club, stay updated with the calendar of events, and get in touch with us easily.\n\nYou can log in if you are a member and explore what awaits you on the other side of the app.\n\nIn the sidebar, you can also access our social media platforms in just one click.",
  "contact.title": "Contact Us",
  "contact.firstName": "First name",
  "contact.surname": "Surname",
  "contact.email": "Email",
  "contact.phone": "Phone",
  "contact.message": "Message",
  "contact.send": "Send",
  "about.missions": "Missions",
  "about.values": "Values",
  "login.password": "Password",
  "login.signin": "No account? Sign up",
  "login.required": "Required",
  "login.invalidEmail": "Invalid email",
  "login.approve": "Your account is awaiting admin approval.",
  "login.credentials": "Invalid email or password.",
  "login.input": "Please enter a valid email and password.",
  "login:failed": "Login failed. Please try again.",
  "signup": "Sign up",
  "signup.name": "Name",
  "signup.surname": "Surname",
  "signup.required": "Required",
  "signup.email": "Email",
  "signup.password": "Password",
  "signup.create": "Create account",
  "signup.invalidEmail": "Invalid email address",
  "signup.success": "Registered! Wait for admin approval.",
  "members.area": "Members Area",
  "members.polls": "Polls",
  "members.calendar": "Members Calendar",
  "members.meetings": "meetings",
  "polls.state": "No open polls right now.",
  "meeting": "Meetings",
  "meeting.scheduled": "No meetings scheduled yet.",
  "calendar": "Calendar"
};
static const Map<String,dynamic> _fr = {
  "nav.home": "Accueil",
  "nav.about": "À propos",
  "nav.calendar": "Calendrier",
  "nav.contact": "Contact",
  "nav.login": "Se connecter",
  "nav.signup": "S'inscrire",
  "nav.members": "Espace membres",
  "home.welcomeTitle": "Bienvenue dans l'application Rock Dance Company !",
  "home.welcomeBody": "Dans cette application, vous pouvez en savoir plus sur notre club, rester informé du calendrier des événements et nous contacter facilement. \n\nSi vous êtes membre, vous pouvez vous connecter et découvrir ce qui vous attend de l'autre côté de l'application. \n\nDans la barre latérale, vous pouvez également accéder à nos réseaux sociaux en un seul clic.",
  "contact.title": "Contactez-nous",
  "contact.firstName": "Prénom",
  "contact.surname": "Nom",
  "contact.email": "Email",
  "contact.phone": "Téléphone",
  "contact.message": "Message",
  "contact.send": "Envoyer",
  "about.missions": "Missions",
  "about.values": "Valeurs",
  "login.password": "Mot de passe",
  "login.signin": "Pas de compte ? Inscrivez-vous",
  "login.required": "Obligatoire",
  "login.invalidEmail": "Adresse e-mail invalide",
  "login.approve": "Votre compte est en attente d'approbation par un administrateur.",
  "login.credentials": "Email ou mot de passe invalide.",
  "login.input": "Veuillez entrer un email et un mot de passe valides.",
  "login:failed": "Échec de la connexion. Veuillez réessayer.",
  "signup": "S'inscrire",
  "signup.name": "Prénom",
  "signup.surname": "Nom",
  "signup.required": "Obligatoire",
  "signup.email": "Email",
  "signup.password": "Mot de passe",
  "signup.create": "Créer un compte",
  "signup.invalidEmail": "Adresse e-mail invalide",
  "signup.success": "Enregistré ! Attendez l'approbation de l'administrateur.",
  "members.area": "Espace membres",
  "members.polls": "Sondages",
  "members.calendar": "Calendrier des membres",
  "members.meetings": "Réunions",
  "polls.state": "Aucun sondage ouvert pour le moment.",
  "meeting": "Réunions",
  "meeting.scheduled": "Aucune réunion programmée pour le moment.",
  "calendar": "Calendrier",
  "navbar.copied": "Copié dans le presse-papiers"
};
static const Map<String, Map<String,dynamic>> mapLocales = {"en": _en, "fr": _fr};
}
