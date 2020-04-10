from datetime import datetime

class log:
    def __init__(self, filepath):
        self.filepath = filepath

    def log(self, message, overwrite=False):
        mode = 'a+'
        if(overwrite):
            mode = 'w+'

        with open(self.filepath, mode) as f:
            d = datetime.now()
            timestamp = "[" + "{0:0=2d}".format(d.hour) + ':' + "{0:0=2d}".format(d.minute) + ':' + "{0:0=2d}".format(d.second) + "]"
            f.write(timestamp + message + "\n")
