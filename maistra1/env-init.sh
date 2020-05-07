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

#install the Jaeger operator
cat <<EOM | oc apply -f -
apiVersion: operators.coreos.com/v1alpha1
kind: Subscription
metadata:
  name: jaeger
  namespace: openshift-operators
spec:
  channel: 'stable'
  installPlanApproval: Automatic
  name: jaeger
  source: community-operators
  sourceNamespace: openshift-marketplace
EOM

#todo: wait for operators to deploy

oc new-project istio-system

#wait for crds
for crd in servicemeshcontrolplanes.maistra.io servicemeshmemberrolls.maistra.io kialis.kiali.io jaegers.jaegertracing.io
do
    echo -n "Waiting for $crd ..."
    while ! oc get crd $crd > /dev/null 2>&1
    do
        sleep 2
        echo -n '.'
    done
    echo "done."
done

#wait for service mesh operator deployment
local servicemesh_deployment=$(oc get deployment -n openshift-operators -o name 2>/dev/null | grep istio)
while [ "${servicemesh_deployment}" == "" ]
do
    sleep 2
    servicemesh_deployment=$(oc get deployment -n openshift-operators -o name 2>/dev/null | grep istio)
done

#wait for Kiali operator deployment
local kiali_deployment=$(oc get deployment -n openshift-operators -o name 2>/dev/null | grep kiali)
while [ "${kiali_deployment}" == "" ]
do
    sleep 2
    kiali_deployment=$(oc get deployment -n openshift-operators -o name 2>/dev/null | grep kiali)
done

#wait for Jaeger operator deployment
local jaeger_deployment=$(oc get deployment -n openshift-operators -o name 2>/dev/null | grep jaeger)
while [ "${jaeger_deployment}" == "" ]
do
    sleep 2
    jaeger_deployment=$(oc get deployment -n openshift-operators -o name 2>/dev/null | grep jaeger)
done

infomsg "Waiting for operator deployments to start..."
for op in ${servicemesh_deployment} ${kiali_deployment} ${jaeger_deployment}
do
    echo -n "Waiting for ${op} to be ready..."
    readyReplicas="0"
    while [ "$?" != "0" -o "$readyReplicas" == "0" ]
    do
        sleep 1
        echo -n '.'
        readyReplicas="$(oc get ${op} -n openshift-operators -o jsonpath='{.status.readyReplicas}' 2> /dev/null)"
    done
    echo "done."
done

#create our smcp
cat <<EOM | oc apply -n istio-system -f -
apiVersion: maistra.io/v1
kind: ServiceMeshControlPlane
metadata:
  name: minimal-install
spec:
    template: default
EOM

#create our smmr
cat <<EOM | oc apply -n istio-system -f -
apiVersion: maistra.io/v1
kind: ServiceMeshMemberRoll
metadata:
  name: default
spec:
  members:
EOM