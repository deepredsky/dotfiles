import os

def get_password(account):
    cmd = "/usr/bin/security 2>&1 >/dev/null find-generic-password -l %s -g" % account
    line = os.popen(cmd).readline()

    passwds = line.split()
    if len(passwds) == 2:
        return passwds[1][1:-1]
    else:
        raise RuntimeError("Didn't understand the format of `security`'s response")

if __name__ == "__main__":
    import sys
    import os
    import getpassword

    if len(sys.argv) != 2:
        print("Usage: %s <username>" % os.path.basename(sys.argv[0]))
        sys.exit(0)
    try:
        print(get_password(sys.argv[1]))
    except:
        print("Couldnt find password")
        sys.exit(1)
