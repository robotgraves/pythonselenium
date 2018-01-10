FROM robotgraves/virtualpython
LABEL authors="Alex Paul,John Nolette <john@neetgroup.net>"

# LIBS
RUN apt-get update -qqy && apt-get install -qqy -y bzip2 \
    zlib1g-dev libopenjpeg-dev libjpeg-dev xvfb node

# FIREFOX BROWSER
ENV FIREFOX_VERSION 57.0.4
RUN apt-get -qqy --no-install-recommends install firefox \
    && rm -rf /var/lib/apt/lists/* /var/cache/apt/* \
    && wget --no-verbose -O /tmp/firefox.tar.bz2 https://download-installer.cdn.mozilla.net/pub/firefox/releases/$FIREFOX_VERSION/linux-x86_64/en-US/firefox-${FIREFOX_VERSION}.tar.bz2 \
    && apt-get -y purge firefox \
    && rm -rf /opt/firefox \
    && tar -C /opt -xjf /tmp/firefox.tar.bz2 \
    && rm /tmp/firefox.tar.bz2 \
    && mv /opt/firefox /opt/firefox-$FIREFOX_VERSION \
    && ln -fs /opt/firefox-$FIREFOX_VERSION/firefox /usr/bin/firefox

# GECKODRIVER 0.19.1
ENV GECKODRIVER_VERSION 1.10.0
RUN npm install -g geckodriver@${GECKODRIVER_VERSION}

# CHROME BROWSER
ARG CHROME_VERSION="google-chrome-stable=63.0.3239.84"
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list \
    && apt-get update -qqy \
    && apt-get -qqy install ${CHROME_VERSION:-google-chrome-stable} \
    && rm /etc/apt/sources.list.d/google-chrome.list \
    && rm -rf /var/lib/apt/lists/* /var/cache/apt/*

# CHROME DRIVER
ENV CHROMEDRIVER_VERSION 2.34
RUN npm install -g chromedriver@${CHROMEDRIVER_VERSION}
