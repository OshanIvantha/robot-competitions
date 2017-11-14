double frontGap = (pathWidth - robotLength) / 2.0;

boolean isOnJunction() {
  return isLeftOpen() || isRightOpen();
}

boolean isOnEnd() {
  return (!isLeftOpen()) and (getFrontSonar() < 10) and (!isRightOpen());
}

boolean isLeftOpen() {
  return getLeftSonar() >= pathWidth - robotWidth;
}

boolean isFrontOpen() {
  return getFrontSonar() >= frontGap;
}

boolean isRightOpen() {
  return getRightSonar() >= pathWidth - robotWidth;
}
