FROM archlinux

ENV SDK_CLI_VERSION 6858069
ENV BUILD_TOOLS_VERSION 29.0.2
ENV PLATFORM_TOOLS_VERSION 29

ENV SDK_CLI_PAHT /home/sdk-tools
ENV ANDROID_SDK_ROOT /home/android-sdk

ENV PATH ${PATH}:${SDK_CLI_PAHT}/bin

# Update distro & download dependencies
RUN pacman -Sy --noconfirm \
    && pacman -S unzip jdk-openjdk gradle wget git --noconfirm

# Download android sdk tools
RUN wget -q https://dl.google.com/android/repository/commandlinetools-linux-${SDK_CLI_VERSION}_latest.zip -O ${SDK_CLI_PAHT}.zip \
    && unzip -qq ${SDK_CLI_PAHT}.zip -d ${SDK_CLI_PAHT} \
    && rm ${SDK_CLI_PAHT}.zip \
    && mv ${SDK_CLI_PAHT}/cmdline-tools/* ${SDK_CLI_PAHT} \
    && rm -rf ${SDK_CLI_PAHT}/cmdline-tools

# Install build-tools and platform-tools
RUN mkdir -p "${ANDROID_SDK_ROOT}/licenses" \
    && echo "24333f8a63b6825ea9c5514f83c2829b004d1fee" > "${ANDROID_SDK_ROOT}/licenses/android-sdk-license" \
    && sdkmanager --sdk_root=${ANDROID_SDK_ROOT} --install "build-tools;${BUILD_TOOLS_VERSION}" \
    && sdkmanager --sdk_root=${ANDROID_SDK_ROOT} --install "platforms;android-${PLATFORM_TOOLS_VERSION}"