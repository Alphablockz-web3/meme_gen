FROM python:3.10-slim

# Install necessary dependencies including git for cloning asdf
RUN apt-get update && apt-get install -y \
    git make build-essential libssl-dev zlib1g-dev \
    libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm \
    libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev \
    libffi-dev liblzma-dev optipng \
    && rm -rf /var/lib/apt/lists/

# Cài đặt asdf
RUN git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.14.1 \
    && echo '. $HOME/.asdf/asdf.sh' >> ~/.bashrc \
    && echo '. $HOME/.asdf/completions/asdf.bash' >> ~/.bashrc

# Thiết lập thư mục làm việc
WORKDIR /app

# Copy mã nguồn vào container
COPY . .


# Cài đặt các plugin và môi trường
RUN bash -c "source ~/.bashrc && \
    asdf plugin-add python && \
    asdf plugin-add poetry && \
    asdf install && \
    make bootstrap && \
    make doctor && \
    make install"

RUN python -m venv .venv && \
    .venv/bin/pip install --upgrade pip setuptools wheel

ENV DEBUG=false
# Expose cổng dịch vụ
EXPOSE 5001

# Lệnh khởi động
CMD ["make", "run"]