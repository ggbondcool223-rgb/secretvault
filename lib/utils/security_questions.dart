class SecurityQuestions {
  static const List<String> predefinedQuestions = [
    'What is your mother\'s maiden name?',
    'What city were you born in?',
    'What is your favorite color?',
    'What is the name of your first pet?',
    'What is your favorite food?',
    'What is the name of your elementary school?',
    'What is your favorite movie?',
    'What is your childhood nickname?',
    'What is the model of your first car?',
    'What is your favorite book?',
  ];

  static String getQuestion(int index) {
    if (index >= 0 && index < predefinedQuestions.length) {
      return predefinedQuestions[index];
    }
    return predefinedQuestions[0];
  }
}
