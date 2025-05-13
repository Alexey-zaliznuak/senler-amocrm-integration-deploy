FROM rabbitmq:3.12-management

# Устанавливаем curl (для образов на основе Debian)
RUN apt-get update && apt-get install -y curl

# Скачиваем плагин
RUN curl -L -o $RABBITMQ_HOME/plugins/rabbitmq_delayed_message_exchange-3.12.0.ez \
    https://github.com/rabbitmq/rabbitmq-delayed-message-exchange/releases/download/v3.12.0/rabbitmq_delayed_message_exchange-3.12.0.ez

# Включаем плагин
RUN rabbitmq-plugins enable rabbitmq_delayed_message_exchange

CMD [ "rabbitmq-server" ]
