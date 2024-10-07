// Storage 

module chaos::StorageDemo {
    
    use std::signer;


    struct StakePool has key {
        amount: u64,
    }

    fun add_user(account: &signer) {
        let amount: u64 = 0;
        move_to(account, StakePool {amount});
    }
    
    fun read_pool(account: address) : u64 acquires StakePool {
        borrow_global<StakePool>(account).amount
    }
    
    fun stake(account: address) acquires StakePool {
        let entry = &mut borrow_global_mut<StakePool>(account).amount;
        *entry = *entry + 100;
    }
    
    fun un_stake(account: address) acquires StakePool {
        let entry = &mut borrow_global_mut<StakePool>(account).amount;
        *entry = *entry - 50;
    }
    
    fun remove_user(account: &signer): u64 acquires StakePool {
        let entry = move_from<StakePool>(signer::address_of(account));
        let StakePool {amount} = entry;
        amount
    }

    fun confirm_user(account: address): bool {
        exists<StakePool>(account)
    }

    //               TEST
//     #[test_only]
//     use std::string::{Self, utf8};
//     #[test_only]
//     use std::debug::print;
   
//    // #[test(user = @0x123)]
//     fun test_function(user: signer) acquires StakePool {
//         add_user(&user);
//         assert!(read_pool(signer::address_of(&user)) == 0, 1);
//         print(&utf8(b"USer Added Successfully"));

//         stake(signer::address_of(&user));
//         assert!(read_pool(signer::address_of(&user)) == 100, 1);
//         print(&utf8(b"USer Staked a 100 tokens Successfully"));

//         un_stake(signer::address_of(&user));
//         assert!(read_pool(signer::address_of(&user)) == 50, 1);
//         print(&utf8(b"USer UnStaked a 50 tokens Successfully"));
        
//         remove_user(&user);
//         assert!(confirm_user(signer::address_of(&user)) == false, 1);
//         print(&utf8(b"User Removed"));

//     }
}