enum SoloGameButtonStatus {
  complated,
  playable,
  unplayable;

  static SoloGameButtonStatus status(int index, currentIndex) {
    return index < currentIndex
        ? SoloGameButtonStatus.complated
        : index == currentIndex
            ? SoloGameButtonStatus.playable
            : SoloGameButtonStatus.unplayable;
  }
}
