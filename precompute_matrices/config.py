"""
===========================
A very simple yaml config wrapper
===========================

Dr. Cai Wingfield
---------------------------
Embodied Cognition Lab
Department of Psychology
University of Lancaster
c.wingfield@lancaster.ac.uk
caiwingfield.net
---------------------------
2019
---------------------------
"""

from os import path

import yaml


class Config(object):

    path = path.join(path.dirname(path.realpath(__file__)), 'config.yaml')

    def __init__(self):
        with open(Config.path, mode="r", encoding="utf-8") as config:
            d = yaml.load(config, yaml.SafeLoader)
        self.sensorimotor_norms_location    = d["sensorimotor-norms-location"]
        self.sensorimotor_app_data_location = d["sensorimotor-data-location"]
