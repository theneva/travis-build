shared_examples_for 'set ulimit' do
  it 'sets ulmits' do
    should include_sexp [:cmd, "ulimit -n 50000"]
  end
end
