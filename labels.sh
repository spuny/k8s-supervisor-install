#!/bin/bash
echo "Repair node hostnames to fit your cluster, than delete exit"
exit 1

kubectl label nodes k8s-master-1 openstack-mon-node=enabled
kubectl label nodes k8s-master-2 openstack-mon-node=enabled

kubectl label nodes k8s-ceph-1 ceph-osd=enabled
kubectl label nodes k8s-ceph-2 ceph-osd=enabled
kubectl label nodes k8s-ceph-3 ceph-osd=enabled
kubectl label nodes k8s-ceph-4 ceph-osd=enabled
kubectl label nodes k8s-ceph-1 ceph-mon=enabled
kubectl label nodes k8s-ceph-2 ceph-mon=enabled
kubectl label nodes k8s-ceph-3 ceph-mon=enabled
kubectl label nodes k8s-ceph-4 ceph-mon=enabled
kubectl label nodes k8s-ceph-1 ceph-mds=enabled
kubectl label nodes k8s-ceph-2 ceph-mds=enabled
kubectl label nodes k8s-ceph-3 ceph-mds=enabled
kubectl label nodes k8s-ceph-4 ceph-mds=enabled
kubectl label nodes k8s-ceph-1 ceph-mgr=enabled
kubectl label nodes k8s-ceph-2 ceph-mgr=enabled
kubectl label nodes k8s-ceph-3 ceph-mgr=enabled
kubectl label nodes k8s-ceph-4 ceph-mgr=enabled
kubectl label nodes k8s-ceph-1 ceph-rgw=enabled
kubectl label nodes k8s-ceph-2 ceph-rgw=enabled
kubectl label nodes k8s-ceph-3 ceph-rgw=enabled
kubectl label nodes k8s-ceph-4 ceph-rgw=enabled

kubectl label nodes k8s-cmp-1 openstack-compute-node=enabled
kubectl label nodes k8s-cmp-2 openstack-compute-node=enabled
kubectl label nodes k8s-cmp-1 openvswitch=enabled
kubectl label nodes k8s-cmp-2 openvswitch=enabled
kubectl label nodes k8s-cmp-1 linuxbridge=enabled
kubectl label nodes k8s-cmp-2 linuxbridge=enabled
kubectl label nodes k8s-cmp-1 openstack-mon-node=enabled
kubectl label nodes k8s-cmp-2 openstack-mon-node=enabled

kubectl label nodes k8s-worker-1 openstack-control-plane=enabled
kubectl label nodes k8s-worker-2 openstack-control-plane=enabled
kubectl label nodes k8s-worker-3 openstack-control-plane=enabled
kubectl label nodes k8s-worker-1 openvswitch=enabled
kubectl label nodes k8s-worker-2 openvswitch=enabled
kubectl label nodes k8s-worker-3 openvswitch=enabled
kubectl label nodes k8s-worker-1 linuxbridge=enabled
kubectl label nodes k8s-worker-2 linuxbridge=enabled
kubectl label nodes k8s-worker-3 linuxbridge=enabled
kubectl label nodes k8s-worker-1 openstack-mon=enabled
kubectl label nodes k8s-worker-2 openstack-mon=enabled
kubectl label nodes k8s-worker-3 openstack-mon=enabled
kubectl label nodes k8s-worker-1 openstack-mon-node=enabled
kubectl label nodes k8s-worker-2 openstack-mon-node=enabled
kubectl label nodes k8s-worker-3 openstack-mon-node=enabled
kubectl label nodes k8s-worker-1 horizon=enabled
kubectl label nodes k8s-worker-2 horizon=enabled
kubectl label nodes k8s-worker-3 horizon=enabled
