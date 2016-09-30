import flask

app = flask.Flask(__name__)

hostname_images = {
	'nealla-eggbert': 'static/macbook.jpg',
	'nealla-grapefruit': 'static/gtx1080.jpg',
	'nealla-jill': 'static/gtx1080.jpg',
	'robot-blood': 'static/turtlebot.jpg',
}


@app.route('/static/<path:path>')
def static_file(path):
    return flask.send_from_directory(app.static_folder, path)


@app.route('/')
def route_dashboard():
  return flask.render_template('index.html', devices=get_devices())


def get_devices():
  lines = open('/etc/openvpn/openvpn-status.log').readlines()
  start = lines.index('ROUTING TABLE\n') + 2
  end = lines.index('GLOBAL STATS\n')

  devices = []
  for line in lines[start:end]:
    vpn_ip, hostname, public_ip, last_connected = line.split(',')
    device = {
      'vpn_ip': vpn_ip,
      'hostname': hostname,
      'public_ip': public_ip,
      'last_connected': last_connected,
      'image_url': '/static/clouds.jpg',
      'is_robot': hostname.startswith('robot'),
    }
    for host in hostname_images:
      if hostname.startswith(host):
        device['image_url'] = hostname_images[host]
    devices.append(device)
  return devices

if __name__ == '__main__':
  app.run('0.0.0.0', port=80)
