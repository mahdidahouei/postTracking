T? getItemAtIndex<T>(List<T> list, int index) {
  if (index >= 0 && index < list.length) {
    return list[index];
  }
  return null;
}
