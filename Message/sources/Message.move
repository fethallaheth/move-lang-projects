module chaos::MessageDemo {

    use aptos_framework::event;

    use std::string::{String, Self, utf8};
    use std::debug::print;
    use std::signer;

    const ALREADY_EXISTS: u64 = 1;
    const NOT_EXISTS: u64 = 2;

    struct Message has key {
        my_message: String
    }

    //////////////////////////////////////////////////////////////////////////////////////        EVENTS       /////////////////////////////////////////////////////////////////////////////////////////////
    #[event]
    struct MessageCreatedEvent has drop, store {
        account: address,
        message: string::String
    }

    #[event]
    struct MessageEditedEvent has drop, store {
        account: address,
        message: string::String
    }

    #[event]
    struct MessageDeletedEvent has drop, store {
        account: address,
        isDeleted: bool
    }

    ////////////////////////////////////////////////////////////////////////////////////   FUNCTION   ////////////////////////////////////////////////////////////////////////////////////////

    public entry fun create_message(account: &signer, msg: String) {
        let signer_address = signer::address_of(account);

        if (!exists<Message>(signer_address)) {
            let message = Message { my_message: msg };
            move_to(account, message);
        }
        else {
            abort ALREADY_EXISTS
        };

        let create_message_event = MessageCreatedEvent {
            account: signer_address,
            message: msg
        };
        event::emit(create_message_event);

    }

    public fun edit_message(account: &signer, msg: String) acquires Message {
        assert!(exists<Message>(signer::address_of(account)) == true, 2);

        let message = borrow_global_mut<Message>(signer::address_of(account));
        message.my_message = msg;

        let edit_message_event = MessageEditedEvent {
            account: signer::address_of(account),
            message: msg
        };
        event::emit(edit_message_event);
    }

    public fun delete_message(account: &signer) acquires Message {
        assert!(exists<Message>(signer::address_of(account)) == true, 2);

        let message = move_from<Message>(signer::address_of(account));
        let Message { my_message : _ } = message;
        print(&utf8(b"Message deleted successfully"));

        let delete_message_event = MessageDeletedEvent {
            account: signer::address_of(account),
            isDeleted: true
        };
        event::emit(delete_message_event);

    }

    /////////////////////////////////////////////////////////////////////////////////////       VIEW FUNCTIONS      ////////////////////////////////////////////////////////////////////////////////////////

    #[view]
    public fun read_message(account: address): String acquires Message {
        let message = borrow_global<Message>(account);
        message.my_message
    }

    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////      UNIT TEST      /////////////////////////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
     
    #[test_only]
    use aptos_framework::account;

    #[test(admin = @0x123)]
    fun test_create_msg(admin: signer) acquires Message {
        account::create_account_for_test(signer::address_of(&admin));
        create_message(&admin, string::utf8(b"This is my message"));
        let msg = read_message(signer::address_of(&admin));
        print(&msg);
        print(&utf8(b"Message created successfully"));
    }

    #[test(admin = @0123)]
    #[expected_failure(abort_code = ALREADY_EXISTS)]
    fun test_create_msg_already_exists(admin: signer) {
        account::create_account_for_test(signer::address_of(&admin));
        create_message(&admin, string::utf8(b"This is my message"));
        create_message(&admin, string::utf8(b"This is my 2nd message"));
    }

    #[test(admin = @0x123)]
    fun test_edit_msg(admin: signer) acquires Message {
        account::create_account_for_test(signer::address_of(&admin));
        create_message(&admin, string::utf8(b"This is my message"));
        let msg = read_message(signer::address_of(&admin));
        print(&msg);
        print(&utf8(b"Message created successfully"));
        edit_message(&admin, string::utf8(b"This is an updated message"));
        let updated_msg = read_message(signer::address_of(&admin));
        print(&updated_msg);
        print(&utf8(b"Message updated successfully"));
    }

    #[test(admin = @0x123)]
    #[expected_failure(abort_code = NOT_EXISTS)]
    fun test_edit_msg_not_exist_resource(admin: signer) acquires Message {
        account::create_account_for_test(signer::address_of(&admin));
        edit_message(&admin, string::utf8(b"This is an updated message"));
        let updated_msg = read_message(signer::address_of(&admin));
        print(&updated_msg);
        print(&utf8(b"Message updated successfully"));
    }

    #[test(admin = @0x123)]
    fun test_delete_msg(admin: signer) acquires Message {
        account::create_account_for_test(signer::address_of(&admin));
        create_message(&admin, string::utf8(b"This is my message"));
        let msg = read_message(signer::address_of(&admin));
        print(&msg);
        print(&utf8(b"Message created successfully"));
        delete_message(&admin);
    }

    #[test(admin = @0x123)]
    #[expected_failure(abort_code = NOT_EXISTS)]
    fun test_delete_msg_doesnt_exist(admin: signer) acquires Message {
        account::create_account_for_test(signer::address_of(&admin));
        delete_message(&admin);
    }
}
