# Copyright 2017 Red Hat, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License. You may obtain
# a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations
# under the License.
#
# == Class: tripleo::profile::base::ironic_inspector
#
# Ironic inspector profile for TripleO
#
# === Parameters
#
# [*bootstrap_node*]
#   (Optional) The hostname of the node responsible for bootstrapping tasks
#   Defaults to hiera('ironic_inspector_short_bootstrap_node_name')
#
# [*step*]
#   (Optional) The current step of the deployment
#   Defaults to hiera('step')

class tripleo::profile::base::ironic_inspector (
  $bootstrap_node = hiera('ironic_inspector_short_bootstrap_node_name', undef),
  $step           = Integer(hiera('step')),
) {

  if $::hostname == downcase($bootstrap_node) {
    $sync_db = true
  } else {
    $sync_db = false
  }

  if $step >= 4 or ($step >= 3 and $sync_db) {
    include ::ironic::inspector::cors
    class { '::ironic::inspector':
      sync_db => $sync_db,
    }

    include ::ironic::inspector::pxe_filter
    include ::ironic::inspector::pxe_filter::dnsmasq
    include ::ironic::config
  }
}
