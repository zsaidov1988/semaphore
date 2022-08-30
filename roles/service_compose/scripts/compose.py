from pyaml_env import parse_config
import os
import yaml

script_dir = os.path.dirname(__file__)
file_path = os.path.join(script_dir, 'services.vars.yml')
compose = {
    "services": {},
    "volumes": {}
}
config = parse_config(file_path)
for key, value in config['services'].items():
    compose['services'][key] = value['compose']
    if (value['loki']):
        compose['services'][key]['<<'] = '*loki'
    if (value['generate_image']):
        image_path = f"{config['registry']}/{config['gitlab_group']}/{config['stack_name']}_{key}:{config['image_tag']}"
        compose['services'][key]['image'] = image_path
    if (value['generate_vault_env']):
        vault_file_path = f"ENV_FILE_PATH=/secrets/{key}.env".replace("_", "-")
        if ("environment" in compose['services'][key].keys()):
            env_list = compose['services'][key]['environment']
            env_list.append(vault_file_path)
            compose['services'][key]['environment'] = env_list
        else:
            compose['services'][key]['environment'] = vault_file_path
        # print(env_list)
if (config['volumes']):
    for key, value in config['volumes'].items():
        compose['volumes'][key] = ""

with open('result.yml', 'w') as yaml_file:
    yaml.dump(compose, yaml_file, default_flow_style=False)
