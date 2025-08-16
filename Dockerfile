# ------------------------------
# Android Build Environment
# ------------------------------
FROM openjdk:11-jdk-slim

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

# Copy project files
WORKDIR /app
COPY . .

# Make gradlew executable
RUN chmod +x ./gradlew

# Use Gradle Wrapper (defined in gradle-wrapper.properties)
CMD ["./gradlew", "assembleRelease"]
