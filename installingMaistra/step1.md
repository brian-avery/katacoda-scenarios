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

## Installing the Operators
Open the OpenShift web console in a Web browser and:

Navigate to Catalog → OperatorHub.

Select the community Maistra Operator to display information about the Operator.

Click Install. On the Create Operator Subscription page, selecting All namespaces on the cluster (default).

Select either Automatic or Manual approval strategy. Click Subscribe.

This installs the Maistra operator and makes it available to all projects in the cluster.

