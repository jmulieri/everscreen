require 'spec_helper'
RSpec.describe Everscreen do
  let(:mammogrammar_url) { 'http://localhost:3001' }
  let(:auth_token) { '11111111-1111-1111-1111-111111111111' }
  let(:headers) { { 'X-AUTH-TOKEN' => auth_token }
  }
  before do
    Everscreen.configure do |config|
      config.url = mammogrammar_url
      config.auth_token = auth_token
    end
  end

  it 'has a version number' do
    expect(Everscreen::VERSION).not_to be nil
  end

  describe '#configure' do
    it 'has Mammogrammar URL properly set' do
      expect(Everscreen.configuration.url).to eq(mammogrammar_url)
    end

    it 'has Mammogrammar API key properly set' do
      expect(Everscreen.configuration.auth_token).to eq(auth_token)
    end
  end

  describe '#search' do
    let(:zip_code) { '12345' }
    let(:url) { "#{mammogrammar_url}/search/#{zip_code}" }
    let(:params) { { headers: headers, query: {} } }
    let(:parsed_response) { [{ 'id' => 1, 'name' => 'Some Facility', 'address_1' => '123 Some Street' }] }

    context 'with OK response status' do
      let(:response) { double('response', ok?: true, parsed_response: parsed_response) }

      it "calls HTTParty with Mammogrammar 'search' URL" do
        expect(HTTParty).to receive(:get).with(url, params).and_return(response)
        Everscreen.search(zip_code)
      end

      it 'returns parsed response containing facilities' do
        expect(HTTParty).to receive(:get).with(url, params).and_return(response)
        result = Everscreen.search(zip_code)
        expect(result).to eq(parsed_response)
      end
    end

    context 'with non-OK response status' do
      let(:parsed_response) { { 'message' => 'invalid request' } }
      let(:response) { double('response', ok?: false, parsed_response: parsed_response) }

      it 'returns parsed response containing facilities' do
        expect(HTTParty).to receive(:get).with(url, params).and_return(response)
        expect {
          Everscreen.search(zip_code)
        }.to raise_error(Everscreen::Error, parsed_response['message'])
      end
    end
  end

  describe '#near' do
    let(:location) { '123 Some Street, Some City, CA 96001' }
    let(:radius) { 10 }
    let(:url) { "#{mammogrammar_url}/near" }
    let(:params) { { headers: headers, query: { location: location, radius: radius } } }
    let(:parsed_response) { [{ 'id' => 1, 'name' => 'Some Facility', 'address_1' => '123 Some Street' }] }

    context 'with OK response status' do
      let(:response) { double('response', ok?: true, parsed_response: parsed_response) }

      it "calls HTTParty with Mammogrammar 'near' URL" do
        expect(HTTParty).to receive(:get).with(url, params).and_return(response)
        Everscreen.near(location, radius)
      end

      it 'returns parsed response containing facilities' do
        expect(HTTParty).to receive(:get).with(url, params).and_return(response)
        result = Everscreen.near(location, radius)
        expect(result).to eq(parsed_response)
      end
    end

    context 'with non-OK response status' do
      let(:parsed_response) { { 'message' => 'invalid request' } }
      let(:response) { double('response', ok?: false, parsed_response: parsed_response) }

      it 'returns parsed response containing facilities' do
        expect(HTTParty).to receive(:get).with(url, params).and_return(response)
        expect {
          Everscreen.near(location, radius)
        }.to raise_error(Everscreen::Error, parsed_response['message'])
      end
    end
  end
end
