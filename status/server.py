import sys
import flask

app = flask.Flask(__name__)


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
    hostname = hostname.split('.')[0]
    devices.append({
      'vpn_ip': vpn_ip,
      'hostname': hostname,
      'public_ip': public_ip,
      'last_connected': last_connected,
      'image_url': get_image_for_hostname(hostname),
      'is_robot': is_robot(hostname),
    })
  return devices


def get_image_for_hostname(hostname):
    words = hostname.split('-')
    if is_robot(hostname):
        return 'static/turtlebot.jpg'
    if 'laptop' in words or 'macbook' in words:
        return 'static/macbook.jpg'
    if 'gpu' in words or 'desktop' in words:
        return 'static/gtx1080.jpg'
    return 'static/clouds.jpg'

def is_robot(hostname):
    words = hostname.split('-')
    return 'robot' in words or 'ros' in words or 'turtlebot' in words

if __name__ == '__main__':
  port = 8004
  for arg in sys.argv:
    if '--port' in arg:
      port = int(arg.split('=')[-1])
  app.run('0.0.0.0', port=port)
