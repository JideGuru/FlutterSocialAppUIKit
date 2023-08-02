class Validations {
  static String? validateNickname(String? value) {
    if (value == null || value.isEmpty) return '닉네임을 입력해주세요.';
    final RegExp nameExp = new RegExp(r'^[A-za-zğüşöçİĞÜŞÖÇ가-힣 ]+$');
    if (!nameExp.hasMatch(value)) return '한글 또는 알파벳으로만 표현해주세요.';
    if (value.length > 10) return '10 글자 이하로 표현해주세요.';
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return '학교 이메일 주소를 입력해주세요.';
    final RegExp nameExp = new RegExp(
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,2"
        r"53}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-z"
        r"A-Z0-9])?)*$");
    if (!nameExp.hasMatch(value)) return '유효하지 않은 이메일 형식입니다.';
    if (!value.endsWith('@jbnu.ac.kr')) return '학교 이메일이 아닙니다.';
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty || value.length < 6)
      return '유효한 비밀번호를 입력해주세요.';
    return null;
  }

  static String? validateStudentNumber(String? value) {
    if (value == null || value.isEmpty) return '연도 네 자리를 입력해주세요.';
    final RegExp nameExp = new RegExp(r'^[0-9]+$');
    if (!nameExp.hasMatch(value)) return '연도 네 자리를 입력해주세요.';
    if (value.length != 4) return '연도 네 자리를 입력해주세요.';
    return null;
  }
}
