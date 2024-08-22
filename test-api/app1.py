from flask import Flask, send_file, abort
import os

app = Flask(__name__)

# Define the path to the YAML file
v1_yaml_file_path = 'config/v1/device-config.yaml'
v2_yaml_file_path = 'config/v2/device-config.yaml'

def get_yaml_file(filename):
    # Check if the file exists
    if os.path.exists(filename):
        # Send the YAML file to the client
        return send_file(filename, mimetype='application/x-yaml')
    else:
        # Return a 404 error if the file is not found
        abort(404, description="YAML file not found")

@app.route('/agent-registration/crds/v1', methods=['GET'])
def get_v1_yaml_file():
    return get_yaml_file(v1_yaml_file_path)

@app.route('/agent-registration/crds/v2', methods=['GET'])
def get_v2_yaml_file():
    return get_yaml_file(v2_yaml_file_path)

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=4000)

