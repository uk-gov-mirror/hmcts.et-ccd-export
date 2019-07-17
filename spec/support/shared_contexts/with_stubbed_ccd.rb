shared_context 'with stubbed ccd' do
  before do
    stub_request(:any, /http:\/\/localhost:8080.*/).to_rack(EtFakeCcd::RootApp)
  end
end
