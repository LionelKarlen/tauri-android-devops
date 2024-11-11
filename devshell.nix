{pkgs}:
with pkgs; let
  # android-studio is not available in aarch64-darwin
  conditionalPackages =
    if pkgs.system != "aarch64-darwin"
    then [android-studio]
    else [];
in
  with pkgs;
  # Configure your development environment.
  #
  # Documentation: https://github.com/numtide/devshell
    devshell.mkShell {
      name = "android-project";
      motd = ''
        Entered the Android app development environment.
      '';
      env = [
        {
          name = "ANDROID_HOME";
          value = "${android-sdk}/share/android-sdk";
        }
        {
          name = "ANDROID_SDK_ROOT";
          value = "${android-sdk}/share/android-sdk";
        }
        {
          name = "JAVA_HOME";
          value = jdk.home;
        }
        {
          name = "NDK_HOME";
          value = "${android-sdk}/share/android-sdk/ndk/27.1.12297006";
        }
        {
          name = "GRADLE_OPTS";
          value = "-Dorg.gradle.project.android.aapt2FromMavenOverride=${android-sdk}/share/android-sdk/build-tools/34.0.0/aapt2";
        }
      ];
      packages =
        [
          android-sdk
          gradle
          jdk
        ]
        ++ conditionalPackages;
    }
