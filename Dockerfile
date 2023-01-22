FROM amazon/aws-lambda-ruby:latest

COPY lambda_function.rb ${LAMBDA_TASK_ROOT}

COPY Gemfile ${LAMBDA_TASK_ROOT}

ENV GEM_HOME=${LAMBDA_TASK_ROOT}
RUN bundle install

CMD [ "lambda_function.lambda_handler" ]
