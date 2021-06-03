library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
package util_pckg is
    function log2c (n : integer) return integer;
end util_pckg;

package body util_pckg is
    function log2c(n : integer) return integer is
        variable m, p : integer;
    begin
        m := 0;
        p := 1;
        while p < n loop
            m := m + 1;
            p := p * 2;
        end loop;
        return m;
    end log2c;
end util_pckg;