module chaos::MessageDemo {
    use std::string::{String,Self, utf8};
    use std::signer;
    use aptos_framework::account;
    use std::debug::print;

    struct Message has key
    {
        my_message : String
    }

    const ALREADY_EXISTS : u64 = 1;
    const NOT_EXISTS: u64 = 2;
    const BULLSHIT: u64 = 23;


    public entry fun create_message(account: &signer, msg: String) {
        let signer_address = signer::address_of(account);
        
        if(!exists<Message>(signer_address))  //If the resource does not exits corresponding to a given address
        {
            let message = Message {
                my_message : msg             //first create a resouce
            };
            move_to(account,message);        //move that resouce to the account
        }

        else                                 //If the resource exits corresponding to a given address
        {
            abort ALREADY_EXISTS                             //update the resouce
        }
        
    }

    public entry fun edite_message(account: &signer, msg: String) acquires Message {
        assert!(exists<Message>(signer::address_of(account)) == true, 2);

        let message=  borrow_global_mut<Message>(signer::address_of(account));
        message.my_message = msg;
    }

    public entry fun delete_message(account: &signer) acquires Message {
        assert!(exists<Message>(signer::address_of(account)) == true, 2);
        
        let message = move_from<Message>(signer::address_of(account));
        let Message {my_message} = message;
        print(&utf8(b"Message deleted successfully"));

    }
    
    public fun read_message(account: address): String acquires Message {
        let message = borrow_global<Message>(account);
        message.my_message
    } 


    #[test(admin = @0x123)]
    public entry fun test_create_msg(admin: signer) acquires Message
    {
        account::create_account_for_test(signer::address_of(&admin));
        create_message(&admin,string::utf8(b"This is my message"));
        let msg = read_message(signer::address_of(&admin));
        print(&msg);
        print(&utf8(b"Message created successfully"));
    }
    
    #[test(admin = @0123)]
    #[expected_failure(abort_code = ALREADY_EXISTS)]
    public entry fun test_create_msg_already_exists(admin: signer) 
    {
        account::create_account_for_test(signer::address_of(&admin));
        create_message(&admin, string::utf8(b"This is my message"));
        create_message(&admin, string::utf8(b"This is my 2nd message"));
    }


    #[test(admin = @0x123)]
    public entry fun test_edit_msg(admin: signer) acquires Message
    {
        account::create_account_for_test(signer::address_of(&admin));
        create_message(&admin,string::utf8(b"This is my message"));
        let msg = read_message(signer::address_of(&admin));
        print(&msg);
        print(&utf8(b"Message created successfully"));
        edite_message(&admin, string::utf8(b"This is an updated message"));
        let updated_msg = read_message(signer::address_of(&admin));
        print(&updated_msg);
        print(&utf8(b"Message updated successfully"));
    }
    
    #[test(admin = @0x123)]
    #[expected_failure(abort_code = NOT_EXISTS)]
    public entry fun test_edit_msg_not_exist_resource(admin: signer) acquires Message
    {
        account::create_account_for_test(signer::address_of(&admin));
        edite_message(&admin, string::utf8(b"This is an updated message"));
        let updated_msg = read_message(signer::address_of(&admin));
        print(&updated_msg);
        print(&utf8(b"Message updated successfully"));
    }

      #[test(admin = @0x123)]
    public entry fun test_delete_msg(admin: signer) acquires Message
    {
        account::create_account_for_test(signer::address_of(&admin));
        create_message(&admin,string::utf8(b"This is my message"));
        let msg = read_message(signer::address_of(&admin));
        print(&msg);
        print(&utf8(b"Message created successfully"));
        delete_message(&admin);
    }


    #[test(admin = @0x123)]
    #[expected_failure(abort_code = NOT_EXISTS)]
    public entry fun test_delete_msg_doesnt_exist(admin: signer) acquires Message
    {
        account::create_account_for_test(signer::address_of(&admin));
        delete_message(&admin);
    }
    
}