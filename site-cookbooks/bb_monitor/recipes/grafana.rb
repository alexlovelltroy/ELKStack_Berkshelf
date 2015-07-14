=begin
#<
Wrapper around upstream grafana recipe to provide a custom default configuration
#>
=end

package 'mysql-client'

bash 'create grafana database' do
  code <<-EOS
    mysql -u#{node['grafana']['ini']['database']['user']} -p#{node['grafana']['ini']['database']['password']} -h#{node['grafana']['dbhost']} -e"CREATE DATABASE IF NOT EXISTS #{node['grafana']['ini']['database']['name']}"
  EOS
end


include_recipe 'grafana'

grafana_datasource 'graphite-cluster' do
  source(
    type: 'graphite',
    url: 'http://' + node[:graphite][:host] + ':8081',
    access: 'direct'
  )
end

grafana_dashboard 'system-stats'

#template "#{node['grafana']['install_dir']}/app/dashboards/default.json" do
  #source 'system_stats.json.erb'
  #owner 'root'
  #group 'root'
  #mode '0664'
#end
