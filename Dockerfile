# ------------------------------
# Android Build Environment
# ------------------------------
FROM openjdk:17-jdk-slim

# Install required dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    wget unzip git curl bash ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Set environment variables for Android SDK
ENV ANDROID_HOME=/opt/android-sdk
ENV PATH=$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$PATH

# Install Android SDK command-line tools
RUN mkdir -p $ANDROID_HOME/cmdline-tools \
    && cd $ANDROID_HOME/cmdline-tools \
    && wget https://dl.google.com/android/repository/commandlinetools-linux-10406996_latest.zip -O tools.zip \
    && unzip tools.zip -d $ANDROID_HOME/cmdline-tools \
    && mv $ANDROID_HOME/cmdline-tools/cmdline-tools $ANDROID_HOME/cmdline-tools/latest \
    && rm tools.zip

# Accept Android licenses automatically
RUN yes | sdkmanager --licenses

# Install required SDK components
RUN sdkmanager --install \
    "platform-tools" \
    "platforms;android-33" \
    "build-tools;33.0.0"

# Install Gradle
ENV GRADLE_VERSION=8.7
RUN wget https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip -O gradle.zip \
    && unzip gradle.zip -d /opt \
    && mv /opt/gradle-${GRADLE_VERSION} /opt/gradle \
    && rm gradle.zip
ENV PATH=/opt/gradle/bin:$PATH

# Set working directory
WORKDIR /app

# Default command (can be overridden by docker run)
CMD ["./gradlew", "assembleRelease"]


