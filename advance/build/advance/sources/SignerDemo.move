module chaos::SignerDemo {
    use std::signer;
    use std::debug::print;
    use std::string::{String, utf8};

    const NOT_OWNER: u64 = 0;
    const OWNER: address = @chaos;

    fun check_owner(account: signer) {
        let address_val = signer::borrow_address(&account);
        assert!(signer::address_of(&account) == OWNER, NOT_OWNER);
        print(&utf8(b"Owner confirmed"));
        print(address_val);
    }

    // #[test(account = @chaos)]
    fun test_function(account: signer){
        check_owner(account);
    }
}
