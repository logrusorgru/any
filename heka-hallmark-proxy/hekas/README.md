Proxy
=====

#### Proxy

Proxy config
```toml
# proxy listener
net  = "tcp"
bind = "127.0.0.1:9000"     # proxy listener

# servers

# server #1
[[users]]
hallmark = "token-poken"
net      = "tcp"
address  = "127.0.0.1:9001" # destination (Heka destiantion)

# server #2
[[users]]
hallmark = "token-shpoken"
net      = "tcp"
address  = "127.0.0.1:9002" # destination (Heka destiantion)
```

#### Hekas

Heka config files (in this direcory):

Heka clients:
- agent1.toml (server #1)
- agent2.toml (server #1)
- agent3.toml (server #2)

Heka servers:
- server1.toml (agent1 & agent2) listen on 9001
- server2.toml (agent3)          listen on 9002

#### InfluxDB

Come into InfluxDB cli

```
influx
```

Create databses

```
CREATE DATABASE "server1"
CREATE DATABASE "server2"
SHOW DATABASES
```

Create users

```
CREATE USER user1 WITH PASSWORD 'psw1'
CREATE USER user2 WITH PASSWORD 'psw2'
SHOW USERS
```

Grant

```
GRANT ALL ON server1 TO user1
GRANT ALL ON server2 TO user2
SHOW GRANTS FOR user1
SHOW GRANTS FOR user2
```

### Run

```bash
nohup ./heka-hallmark-proxy -config test.toml > proxy.log 2>&1 &
sudo -u heka nohup hekad -config hekas/server1.toml > server1.log 2>&1 &
sudo -u heka nohup hekad -config hekas/server2.toml > server2.log 2>&1 &
sudo -u heka nohup hekad -config hekas/agent1.toml > agent1.log 2>&1 &
sudo -u heka nohup hekad -config hekas/agent2.toml > agent2.log 2>&1 &
sudo -u heka nohup hekad -config hekas/agent3.toml > agent3.log 2>&1 &
```

#### Grafana

Create two datasources:
- Server1
  - databse: server1
  - user: user1
  - psw: psw1
- Server2
  - database: server2
  - user: user2
  - psw: psw2

The Server1 and the Server2 are names of datasources.

Add measurements to dashboard:
- create new dashboard
- click: "dashboard managmnent (gear)"
- click "View as JSON"
- copy-paste the dashboard.json file content to textarea
- close JSON-view
- click "save dashboard"

#### Stop hekas & proxy

```bahs
sudo pkill -QUIT -f heka
```