#Enable SIP Debug Logs
#In Asterisk CLI:

pjsip set logger on

#Restart Asterisk to apply:
sudo systemctl restart asterisk

#Check Registered Peers and Endpoints

pjsip show endpoints

#sample output 

Endpoint: 2000/2000             Transport: UDP                                             
  AOR: 2000                                      
  Contact: 192.168.1.101:5060       Status: Reachable (OK)
  ...
Endpoint: 1000/1000             Transport: UDP                                             
  AOR: 1000                                      
  Contact: 192.168.1.102:5060       Status: Reachable (OK)
  ...


####### /etc/asterisk/extensions.conf


[default]
exten => 2000,1,Dial(PJSIP/2000)
exten => 1000,1,Dial(PJSIP/1000)


#Summary
Asterisk installed and running

PJSIP configured with peers 2000 and 1000

SIP debug logging enabled

Confirm peers registration status with pjsip show endpoints


