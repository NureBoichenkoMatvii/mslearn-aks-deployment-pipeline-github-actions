FROM nginx:1.18

# Install necessary packages, including Node.js 14
RUN apt-get update -y && \
    apt-get install -y curl gnupg2 && \
    curl -sL https://deb.nodesource.com/setup_14.x | bash - && \
    apt-get install -y nodejs git

# Install Hugo
RUN curl -sL https://github.com/gohugoio/hugo/releases/download/v0.72.0/hugo_extended_0.72.0_Linux-64bit.tar.gz | \
    tar -xz && \
    mv hugo /usr/bin

# Install a compatible version of PostCSS CLI and Autoprefixer globally
RUN npm install -g postcss-cli@8.3.1 autoprefixer@10.2.6 postcss@8.2.15

# Clone the repository
RUN git clone https://github.com/MicrosoftDocs/mslearn-aks-deployment-pipeline-github-actions /contoso-website

# Set the working directory
WORKDIR /contoso-website/src

# Initialize submodules
RUN git submodule update --init themes/introduction

# Build the Hugo site
RUN hugo 
RUN mv public/* /usr/share/nginx/html

# Expose port 80
EXPOSE 80
