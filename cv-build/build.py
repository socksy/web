#!/usr/bin/env python3
import yaml
import typst
from datetime import datetime
from jinja2 import Template
from pathlib import Path
from watchfiles import watch

def now():
    return datetime.now().strftime("[%H:%M]")

cwd = Path(__file__).resolve().parent
root = cwd.parent
cv_yaml = root.joinpath("cv.yaml")
template_typ = cwd.joinpath("template.typ")
output_typ = cwd.joinpath("output.typ")
output_pdf = cwd.joinpath("benlovell_cv.pdf")
def render():
    with open(cv_yaml) as f:
        cv_data = yaml.safe_load(f)

    with open(template_typ) as f:
        template = Template(f.read())

    with open(output_typ, 'w') as f:
        f.write(template.render(cv_data))

    try:
        typst.compile(output_typ, root=root, output=output_pdf)
        print(f"{now()} Built successfully")
    except RuntimeError as err:
        print(f"{now()} Could not build:")
        print(err)
        print(80*"-")

render()
for changes in watch(cv_yaml, template_typ):
    render()
