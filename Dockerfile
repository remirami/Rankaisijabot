FROM python:3.8-slim

ARG bot_token_arg

# Set pip to have cleaner logs and no saved cache
ENV PIP_NO_CACHE_DIR=false \
    PIPENV_HIDE_EMOJIS=1 \
    PIPENV_IGNORE_VIRTUALENVS=1 \
    PIPENV_NOSPIN=1 \
    BOT_TOKEN=$bot_token_arg

RUN apt-get -y update \
    && apt-get install -y \
        git \
    && rm -rf /var/lib/apt/lists/*

# Install pipenv
RUN pip install -U pipenv

# Create the working directory
WORKDIR /bot

# Install project dependencies
COPY Pipfile* ./
RUN pipenv install --system --deploy --sequential

# Copy the source code in last to optimize rebuilding the image
COPY . .

ENTRYPOINT ["python"]
CMD ["-m", "bot"]