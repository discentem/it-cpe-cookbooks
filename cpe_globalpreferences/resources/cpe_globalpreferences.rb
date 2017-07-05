#
# Cookbook Name:: cpe_globalpreferences
# Resource:: cpe_globalpreferences
#
# vim: syntax=ruby:expandtab:shiftwidth=2:softtabstop=2:tabstop=2
#
# Copyright (c) 2017-present, Pinterest, Inc.
# All rights reserved.
#
# This source code is licensed under the Apache 2.0 license found in the
# LICENSE file in the root directory of this source tree.
#

resource_name :cpe_globalpreferences
default_action :run

gp_prefs = {}

action :run do
  gp_prefs = node['cpe_globalpreferences'].reject { |_k, v| v.nil? }
  return if gp_prefs.empty?
  organization = node['organization'] ? node['organization'] : 'Pinterest'
  prefix = node['cpe_profiles']['prefix']
  node.default['cpe_profiles']["#{prefix}.globalpreferences"] = {
    'PayloadIdentifier' => "#{prefix}.globalpreferences",
    'PayloadRemovalDisallowed' => true,
    'PayloadScope' => 'System',
    'PayloadType' => 'Configuration',
    'PayloadUUID' => '2B1C9890-B062-499B-B13D-3CDA9D40FF96',
    'PayloadOrganization' => organization,
    'PayloadVersion' => 1,
    'PayloadDisplayName' => 'Global Preferences',
    'PayloadContent' => [
      {
        'PayloadType' => 'com.apple.ManagedClient.preferences',
        'PayloadVersion' => 1,
        'PayloadIdentifier' => "#{prefix}.globalpreferences",
        'PayloadUUID' => '97DD1F38-93EE-49C8-9ECD-B2C2EA29E77F',
        'PayloadEnabled' => true,
        'PayloadDisplayName' => 'Global Preferences',
        'PayloadContent' => {
          '.GlobalPreferences' => {
            'Forced' => [
              {
                'mcx_preference_settings' => gp_prefs,
              },
            ],
          },
        },
      },
    ],
  }
end
