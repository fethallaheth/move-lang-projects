// & this is for olny read the value , you cant change it 
// &mut this is for modify the value , you  can change it 

module chaos::RefDemo {
      use std::debug::print;

      fun senario_1() {
        let value_a = 10;
        let imm_ref: &u64 = &value_a;
        print(imm_ref);
      }

      fun senario_2() {
        let value_a = 10;
        let mut_ref: &mut u64 = &mut value_a;
        print(mut_ref);
      }

      fun senario_3() {
        let value_a = 10;
        let mut_ref: &mut u64 = &mut value_a;
        mut_ref = &mut 20;
        print(mut_ref);
      }
    
    // #[test]
    fun test_senario_1() {
        senario_1();
    } 

    // #[test]
    fun test_senario_2() {
        senario_2();
    }

    // #[test]
    fun test_senario_3() {
        senario_3();
    }
}