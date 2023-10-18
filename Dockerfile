# Use an official Microsoft base image
FROM mcr.microsoft.com/windows/servercore:ltsc2019

# Set the working directory
WORKDIR /app

# Install chocolatey
RUN @powershell -NoProfile -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"

# Install Visual Studio Build tools
RUN choco install visualstudio2019buildtools --package-parameters "--add Microsoft.VisualStudio.Component.VC.Tools.x86.x64 --add Microsoft.VisualStudio.Component.VC.Tools.ARM --add Microsoft.VisualStudio.Component.VC.Tools.ARM64 --add Microsoft.VisualStudio.Component.VC.ATL --add Microsoft.VisualStudio.Component.VC.ATLMFC --add Microsoft.VisualStudio.Component.VC.v141.x86.x64.Spectre --add Microsoft.VisualStudio.Component.Windows10SDK.18362 --add Microsoft.VisualStudio.Component.VC.CLI.Support --add Microsoft.VisualStudio.Component.VC.Redist.14.Latest"

# Download and install Qt online installer
RUN powershell -Command "Invoke-WebRequest -Uri https://download.qt.io/official_releases/online_installers/qt-unified-windows-x64-online.exe -OutFile qt-installer.exe"
RUN start /wait qt-installer.exe install --accept-licenses --accept-obligations qt.qt6.653.win64_msvc2019_64 qt.qt6.653.qt5compat qt.qt6.653.addons.qtmultimedia -m entrevrak@proton.me --pw Fake-password42

# Set up environment variables for Qt and MSVC
ENV QTDIR C:\\Qt\\6.5.3\\msvc2019_64
ENV PATH $QTDIR\\bin:$PATH

# Copy the current directory contents into the container at /app
COPY . /app

# Make port 80 available to the world outside this container
EXPOSE 80

# Define environment variable
ENV NAME World

# Run app.py when the container launches
CMD ["python", "app.py"]