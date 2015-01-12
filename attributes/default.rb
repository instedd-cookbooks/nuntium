default['nuntium']['host_name'] = node['fqdn']

default['nuntium']['amqp']['vhost'] = '/nuntium'
default['nuntium']['amqp']['user'] = 'nuntium'
default['nuntium']['amqp']['password'] = 'nuntium'

default['nuntium']['google_oauth2']['client_id'] = ''
default['nuntium']['google_oauth2']['client_secret'] = ''

default['nuntium']['guisso']['enabled'] = false
default['nuntium']['guisso']['url'] = 'https://login.instedd.org'
default['nuntium']['guisso']['client_id'] = ''
default['nuntium']['guisso']['client_secret'] = ''

default['nuntium']['twitter']['token'] = nil
default['nuntium']['twitter']['secret'] = nil

default['nuntium']['web']['ssl']['enabled'] = false
default['nuntium']['web']['ssl']['cert_file'] = nil
default['nuntium']['web']['ssl']['cert_key_file'] = nil
default['nuntium']['web']['ssl']['cert_chain_file'] = nil

