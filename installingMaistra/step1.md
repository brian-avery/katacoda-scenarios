## Logging in to the Cluster via Dashboard

Click the [Console](https://console-openshift-console-[[HOST_SUBDOMAIN]]-443-[[KATACODA_HOST]].environments.katacoda.com) tab to open the dashboard.
* **Username:** ``admin``{{copy}}
* **Password:** ``admin``{{copy}}

## Logging in to the Cluster via CLI
Before creating any applications, login as admin. This will be required if you want to log in to the web console and use it.

To login to the OpenShift cluster from the Terminal run:

oc login -u admin -p admin{{execute}}

This will log you in using the credentials:

Username: admin
Password: admin
Use the same credentials to log into the web console.