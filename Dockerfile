FROM nvidia/cuda:11.8.0-cudnn8-devel-ubuntu22.04

# Set working directory
WORKDIR /app

# Copy all files to the working directory
COPY . .

# Fix line endings and make entrypoint script executable
RUN sed -i 's/\r$//' scripts/entrypoint.sh
RUN chmod +x scripts/entrypoint.sh

# Prevent tzdata from prompting for input
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=America/Argentina/Buenos_Aires

# Install Python, pip, etc.
RUN apt-get update && apt-get install -y python3-pip build-essential nano
RUN apt-get install -y python3-dev espeak-ng megatools curl openssl wget

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    git curl build-essential libssl-dev zlib1g-dev \
    libbz2-dev libreadline-dev libsqlite3-dev wget llvm \
    libncursesw5-dev xz-utils tk-dev libxml2-dev \
    libxmlsec1-dev liblzma-dev libffi-dev \
    && apt-get clean
    
RUN apt-get install -y git && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# # Install tzdata with preset timezone
RUN apt-get update && apt-get install -y tzdata && \
    ln -fs /usr/share/zoneinfo/$TZ /etc/localtime && \
    dpkg-reconfigure --frontend noninteractive tzdata

RUN apt-get update && apt-get install -y \
    libssl-dev libffi-dev zlib1g-dev


RUN apt-get update && apt-get install -y libbz2-dev liblzma-dev


# Run the entrypoint script at build time
RUN scripts/entrypoint.sh
# CMD ["tail", "-f", "/dev/null"]
