from behave.log_capture import capture
import requests
import config

def before_all(context):
    context.config.setup_logging()
    return

def before_feature(context, feature):
    context.session = requests.Session()
    context.host = config.LOCALHOST
    context.requests_params = {}
    context.requests_headers = {}
    context.requests_headers['Accept'] = 'text/turtle'
    context.ingested = {}
    context.proxydict = {}
    return

def before_scenario(context, scenario):
    # Remove params before next call
    context.requests_params = {}
    return

def before_step(context, step):
    return

def after_step(context, step):
    return

def after_scenario(context, scenario):
    # if (scenario.status == "failed"):
    #     for msg in context.log_capture.buffer:
    #         print(msg.getMessage())
    return

def after_feature(context, feature):
    context.session = None
    context.host = config.LOCALHOST
    context.requests_params = {}
    context.requests_headers = {}
    context.ingested = {}
    return

def after_all(context):
    return
