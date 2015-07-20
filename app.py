from gevent import monkey
monkey.patch_all()

from sourcesage import app, socketio
    
if __name__ == '__main__':
    socketio.run(app, port=6789)