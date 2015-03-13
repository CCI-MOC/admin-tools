#!/usr/bin/env python2
import jinja2
import yaml
import os.path

src_dir = os.path.dirname(__file__)
ks_template_file = os.path.join(src_dir, 'ks-template.cfg')

with open(ks_template_file) as f:
    template = jinja2.Template(f.read())

with open('settings.yaml') as f:
    settings = yaml.safe_load(f)

text = template.render(cfg=settings)

with open('ks-out.cfg', 'w') as f:
    f.write(text)
