//

int main (string[] args) {
    var loop = new MainLoop ();
    Graphics.setup (args);
    var window = new Window ();
    window.destroy.connect (loop.quit);
    var lua = new Luanator ();

    try {
        var netman = Wifi.netman ();
        var wifi = new Wifi (netman, (state) => {
            var color = "#c00";
            if (state == 40) {
                color = "yellow";
                window.showHttp ("0", "white");
                window.setTitle ("-", "white");
            }
            if (state == 70) {
                color = "green";
            }
            window.showLevel (state, color);
        }, (http_word) => {
            var color = "#c00";
            var http_status = int.parse (http_word);
            if (http_status < 100) {
                color = "brown";
            }
            if (http_status >= 200 && http_status < 300) {
                color = "green";
            }
            stdout.printf ("window showhttp %s %s\n", http_word, color);
            window.showHttp (http_word, color);
            lua.url (http_word);
        }, (essid) => {
            var color = "green";
            window.setTitle (essid, color);
        });
        stdout.printf ("Canary listening\n");
        loop.run ();
    } catch (IOError e) {
        stderr.printf ("%s\n", e.message);
        return 1;
    }

    return 0;
}
