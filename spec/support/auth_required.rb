RSpec.shared_examples "requires authentication" do |verb, path, params: {}|
  it "#{verb.upcase} #{path} returns 403 when unauthenticated" do
    public_send(verb, path, params: params)
    expect(response).to have_http_status(:forbidden) 
  end
end
