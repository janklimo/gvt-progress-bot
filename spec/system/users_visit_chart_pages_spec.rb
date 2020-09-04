# frozen_string_literal: true

describe 'Users visit chart pages' do
  before do
    @today = create(:entry,
                    programs: [
                      ["ARK Invest - FOREX", "8206.295928", "forex"],
                      ["Bitkolik", "7474.9889201856", "crypto"],
                      ["GMTrade II", "5952.4386406848", "crypto"],
                      ["Other #4", "5523.1571185472", "crypto"],
                      ["Other #5", "5423.9889201856", "crypto"],
                      ["Other #6", "4952.4386406848", "crypto"],
                      ["Other #7", "3523.1571185472", "crypto"],
                      ["Other #8", "2523.1571185472", "crypto"],
                      ["Other #9", "1523.1571185472", "crypto"],
                      ["Other #10", "523.1571185472", "crypto"],
                      ["Other #11", "23.1571185472", "crypto"],
                    ])
  end

  it 'renders adoption page' do
    visit root_path
    expect(page).to have_content 'GVT Adoption Progress'
  end

  it 'renders managers page' do
    visit charts_managers_path
    expect(page).to have_content 'Top programs by AUM'
  end
end
