class StorageKeys {
  static const String completedAlphabets = "completed_alphabets";
  static const String wordLevelOne = "word_level_one";
  static const String wordLevelTwo = "word_level_two";
  static const String wordLevelThree = "word_level_three";
  static const String wordLevelFour = "word_level_four";
  static const String wordLevelFive = "word_level_five";

  static const String achievementsUnlocked = "achievements_unlocked";

  static const String userName = "userName";
  static const String userAvatar = "userAvatar";
  static const String onboardingDone = "onboarding_done";

  static const Map<String, String> legacyWordKeys = {
    wordLevelOne: "کلمات یک هجایی",
    wordLevelTwo: "کلمات دو هجایی",
    wordLevelThree: "کلمات سه هجایی",
    wordLevelFour: "کلمات چهار و پنج هجایی",
    wordLevelFive: 'کلمات پنج هجایی',
  };

  static const Map<String, String> legacySettingsKeys = {};

  static const List<String> allProgressKeys = [
    completedAlphabets,
    wordLevelOne,
    wordLevelTwo,
    wordLevelThree,
    wordLevelFour,
    wordLevelFive,
    achievementsUnlocked,
  ];
}
