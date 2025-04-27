#!/usr/bin/env bash

##############################################################################
##
##  Gradle start up script for UNIX systems
##  Optimized for compatibility and error handling
##
##############################################################################

# Fail immediately on errors, unset variables, and pipeline failures
set -euo pipefail

# Default JVM options (recommended to modify via JAVA_OPTS/GRADLE_OPTS instead)
DEFAULT_JVM_OPTS=()

APP_NAME="Gradle"
APP_BASE_NAME=$(basename "$0")

# File descriptor settings
MAX_FD="maximum"
CAN_SET_MAX_FD=true

# OS detection flags (using POSIX-compliant case syntax)
case "$(uname -s)" in
  CYGWIN*|MINGW*|MSYS*)
    cygwin=true
    msys=true
    ;;
  Darwin*)
    darwin=true
    ;;
  *)
    cygwin=false
    msys=false
    darwin=false
    ;;
esac

# Enhanced error handling functions
die() {
  printf '\n%s\n' "ERROR: $*" >&2
  exit 1
}

warn() {
  printf '%s\n' "WARNING: $*" >&2
}

# Resolve symlinks and get absolute path to APP_HOME
resolve_app_home() {
  local PRG="$0"
  # Need this for relative symlinks
  while [ -h "$PRG" ]; do
    local ls_link=$(ls -ld "$PRG")
    local link=$(expr "$ls_link" : '.*-> \(.*\)$')
    if expr "$link" : '/.*' >/dev/null; then
      PRG="$link"
    else
      PRG=$(dirname "$PRG")"/$link"
    fi
  done
  cd "$(dirname "$PRG")" >/dev/null || die "Cannot cd to $(dirname "$PRG")"
  APP_HOME=$(pwd -P)
  cd - >/dev/null || die "Cannot return to original directory"
}

# Platform-specific initialization
platform_init() {
  if "$cygwin" || "$msys"; then
    # Convert Windows paths to UNIX paths
    [ -n "${JAVA_HOME:-}" ] && JAVA_HOME=$(cygpath --unix "$JAVA_HOME")
    CLASSPATH=$(cygpath --path --unix "$CLASSPATH")
  fi
}

# Set maximum file descriptors
set_max_fd() {
  if ! "$darwin" && ! "$cygwin" && "$CAN_SET_MAX_FD"; then
    MAX_FD_LIMIT=$(ulimit -H -n 2>/dev/null) || warn "Cannot query max file descriptor limit"
    if [ "$MAX_FD" = "maximum" ] || [ "$MAX_FD" = "max" ]; then
      MAX_FD="$MAX_FD_LIMIT"
    fi
    ulimit -n "$MAX_FD" 2>/dev/null || warn "Could not set maximum file descriptor limit to $MAX_FD"
  fi
}

# Find Java executable
find_java() {
  if [ -n "${JAVA_HOME:-}" ]; then
    if [ -x "$JAVA_HOME/jre/sh/java" ]; then
      JAVACMD="$JAVA_HOME/jre/sh/java"  # IBM JDK
    elif [ -x "$JAVA_HOME/bin/java" ]; then
      JAVACMD="$JAVA_HOME/bin/java"
    else
      die "JAVA_HOME is set to invalid directory: $JAVA_HOME"
    fi
  else
    JAVACMD=$(command -v java 2>/dev/null) || die "JAVA_HOME not set and 'java' not found in PATH"
  fi

  # Verify Java executable
  [ -x "$JAVACMD" ] || die "Cannot execute Java: $JAVACMD"
}

# Main execution flow
main() {
  resolve_app_home
  CLASSPATH=$APP_HOME/gradle/wrapper/gradle-wrapper.jar

  # Platform-specific initialization
  platform_init

  # Set maximum file descriptors
  set_max_fd

  # Find Java executable
  find_java

  # Prepare JVM options
  local jvm_opts=("${DEFAULT_JVM_OPTS[@]}")
  jvm_opts+=("${JAVA_OPTS[@]}")
  jvm_opts+=("${GRADLE_OPTS[@]}")
  jvm_opts+=("-Dorg.gradle.appname=$APP_BASE_NAME")

  # Execute Gradle
  exec "$JAVACMD" "${jvm_opts[@]}" -classpath "$CLASSPATH" org.gradle.wrapper.GradleWrapperMain "$@"
}

# Run main function
main "$@"