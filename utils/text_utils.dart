class TextUtils {
  static const int maxDrugNameLength = 12;

  static String truncateDrugName(String name) {
    if (name.length <= maxDrugNameLength) {
      return name;
    }
    return '${name.substring(0, maxDrugNameLength)}...';
  }
}