#install the ServiceMesh operator
cat <<EOM | oc apply -f -
apiVersion: operators.coreos.com/v1alpha1
kind: Subscription
metadata:
  name: maistraoperator
  namespace: openshift-operators
spec:
  channel: 'stable'
  installPlanApproval: Automatic
  name: maistraoperator
  source: community-operators
  sourceNamespace: openshift-marketplace
EOM

#install the Kiali operator
cat <<EOM | oc apply -f -
apiVersion: operators.coreos.com/v1alpha1
kind: Subscription
metadata:
  name: kiali
  namespace: openshift-operators
spec:
  channel: 'stable'
  installPlanApproval: Automatic
  name: kiali
  source: community-operators
  sourceNamespace: openshift-marketplace
EOM

oc new-project istio-system

cat <<EOM | oc apply -n istio-system -f -
apiVersion: maistra.io/v1
kind: ServiceMeshControlPlane
metadata:
  name: minimal-install
spec:
    istio:
        kiali:
            enabled: true
EOM