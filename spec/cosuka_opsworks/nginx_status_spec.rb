require 'spec_helper'
require 'cosuka_opsworks/nginx_status'

describe CosukaOpsworks::NginxStatus do
  describe '#usage' do
    let(:status) {CosukaOpsworks::NginxStatus.new }

    context 'worker_connections = 1024, active_connections = 10' do
      it '1%' do
        allow(status).to receive(:`).with('grep worker_connections /etc/nginx/nginx.conf').and_return('  worker_connections  1024;')
        allow(status).to receive(:`).with("curl -s http://127.0.0.1/nginx_status | grep 'Active connections'").and_return('Active connections: 10')
        expect(status.usage).to eq 1
      end
    end

    context 'worker_connections = 1024, active_connections = 100' do
      it '10%' do
        allow(status).to receive(:`).with('grep worker_connections /etc/nginx/nginx.conf').and_return('  worker_connections  1024;')
        allow(status).to receive(:`).with("curl -s http://127.0.0.1/nginx_status | grep 'Active connections'").and_return('Active connections: 100')
        expect(status.usage).to eq 10
      end
    end

    context 'command error' do
      it 'raise error' do
        process_status = double('Status')
        allow(process_status).to receive(:exitstatus).and_return(1)
        allow(Process).to receive(:last_status).and_return(process_status)

        allow(status).to receive(:`).with('grep worker_connections /etc/nginx/nginx.conf').and_return('')
        allow(status).to receive(:`).with("curl -s http://127.0.0.1/nginx_status | grep 'Active connections'").and_return('')

        expect { status.usage }.to raise_error(/command error/)
      end
    end
  end
end
