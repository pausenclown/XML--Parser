use Test;
use XML::Parser;

# Test cases from http://www.zvon.org/xxl/NamespaceTutorial/
# which is GPL

my @cases =

# For the namespace declarations reserved attributes starting with xmlns are used.
# You can declare a namespace on each element you are using, but this approach is tiring
# and the resulting code is hard to read.

'<lower:aaa xmlns:lower = "http://zvon.org/lowercase">
    <lower:bbb xmlns:lower = "http://zvon.org/lowercase">
        <lower:ccc xmlns:lower = "http://zvon.org/lowercase" />
    </lower:bbb>
    <upper:BBB xmlns:upper = "http://zvon.org/uppercase">
        <upper:CCC xmlns:upper = "http://zvon.org/uppercase" />
    </upper:BBB>
    <xnumber:x111 xmlns:xnumber = "http://zvon.org/xnumber">
        <xnumber:x222 xmlns:xnumber = "http://zvon.org/xnumber" />
    </xnumber:x111>
</lower:aaa>',

-> $document {
    ok( $document.root.name eq 'aaa', 'aaa name' );
    ok( $document.root.prefix eq 'lower' ?? 1 !! 0, 'aaa prefix' );
    ok( $document.root.namespaces<lower>.name eq 'lower', 'aaa namespace name' );
    ok( $document.root.namespaces<lower>.uri eq 'http://zvon.org/lowercase', 'aaa namespace url' );

    ok( $document.root.child_nodes[0].name eq 'bbb', 'bbb name' );
    ok( $document.root.child_nodes[0].prefix eq 'lower', 'bbb prefix' );
    ok( $document.root.child_nodes[0].namespaces<lower>.name eq 'lower', 'bbb namespace name' );
    ok( $document.root.child_nodes[0].namespaces<lower>.uri eq 'http://zvon.org/lowercase', 'bbb namespace url' );

    ok( $document.root.child_nodes[0].child_nodes[0].name eq 'ccc', 'ccc name' );
    ok( $document.root.child_nodes[0].child_nodes[0].prefix eq 'lower', 'ccc prefix' );
    ok( $document.root.child_nodes[0].child_nodes[0].namespaces<lower>.name eq 'lower', 'ccc namespace name' );
    ok( $document.root.child_nodes[0].child_nodes[0].namespaces<lower>.uri eq 'http://zvon.org/lowercase', 'ccc namespace url' );

    ok( $document.root.child_nodes[1].name eq 'BBB', 'BBB name' );
    ok( $document.root.child_nodes[1].prefix eq 'upper', 'BBB prefix' );
    ok( $document.root.child_nodes[1].namespaces<upper>.name eq 'upper', 'BBB namespace name' );
    ok( $document.root.child_nodes[1].namespaces<upper>.uri eq 'http://zvon.org/uppercase', 'BBB namespace url' );

    ok( $document.root.child_nodes[1].child_nodes[0].name eq 'CCC', 'CCC name' );
    ok( $document.root.child_nodes[1].child_nodes[0].prefix eq 'upper', 'CCC prefix' );
    ok( $document.root.child_nodes[1].child_nodes[0].namespaces<upper>.name eq 'upper', 'CCC namespace name' );
    ok( $document.root.child_nodes[1].child_nodes[0].namespaces<upper>.uri eq 'http://zvon.org/uppercase', 'CCC namespace url' );

    ok( $document.root.child_nodes[2].name eq 'x111', 'x111 name' );
    ok( $document.root.child_nodes[2].prefix eq 'xnumber', 'x111 prefix' );
    ok( $document.root.child_nodes[2].namespaces<xnumber>.name eq 'xnumber', 'x111 namespace name' );
    ok( $document.root.child_nodes[2].namespaces<xnumber>.uri eq 'http://zvon.org/xnumber', 'x111 namespace url' );

    ok( $document.root.child_nodes[2].child_nodes[0].name eq 'x222', 'x222 name' );
    ok( $document.root.child_nodes[2].child_nodes[0].prefix eq 'xnumber', 'x222 prefix' );
    ok( $document.root.child_nodes[2].child_nodes[0].namespaces<xnumber>.name eq 'xnumber', 'x222 namespace name' );
    ok( $document.root.child_nodes[2].child_nodes[0].namespaces<xnumber>.uri eq 'http://zvon.org/xnumber', 'x222 namespace url' );
},


# Delaring namespaces with each element as in Example 2 would be very unconvenient and error prone.
# The standard provides several ways how to accomplish the task.
# The namespace declaration given for the current element is also valid for all elements occuring
# inside the current one (for all children and descendants).

'<lower:aaa xmlns:lower = "http://zvon.org/lowercase">
    <lower:bbb>
        <lower:ccc />
    </lower:bbb>
    <upper:BBB xmlns:upper = "http://zvon.org/uppercase">
        <upper:CCC />
    </upper:BBB>
    <xnumber:x111 xmlns:xnumber = "http://zvon.org/xnumber">
        <xnumber:x222 />
    </xnumber:x111>
</lower:aaa>',

-> $document {
    ok( $document.root.name eq 'aaa', 'aaa name' );
    ok( $document.root.prefix eq 'lower' ?? 1 !! 0, 'aaa prefix' );
    ok( $document.root.namespaces<lower>.name eq 'lower', 'aaa namespace name' );
    ok( $document.root.namespaces<lower>.uri eq 'http://zvon.org/lowercase', 'aaa namespace url' );

    ok( $document.root.child_nodes[0].name eq 'bbb', 'bbb name' );
    ok( $document.root.child_nodes[0].prefix eq 'lower', 'bbb prefix' );
    ok( $document.root.child_nodes[0].namespaces<lower>.name eq 'lower', 'bbb namespace name' );
    ok( $document.root.child_nodes[0].namespaces<lower>.uri eq 'http://zvon.org/lowercase', 'bbb namespace url' );

    ok( $document.root.child_nodes[0].child_nodes[0].name eq 'ccc', 'ccc name' );
    ok( $document.root.child_nodes[0].child_nodes[0].prefix eq 'lower', 'ccc prefix' );
    ok( $document.root.child_nodes[0].child_nodes[0].namespaces<lower>.name eq 'lower', 'ccc namespace name' );
    ok( $document.root.child_nodes[0].child_nodes[0].namespaces<lower>.uri eq 'http://zvon.org/lowercase', 'ccc namespace url' );

    ok( $document.root.child_nodes[1].name eq 'BBB', 'BBB name' );
    ok( $document.root.child_nodes[1].prefix eq 'upper', 'BBB prefix' );
    ok( $document.root.child_nodes[1].namespaces<upper>.name eq 'upper', 'BBB namespace name' );
    ok( $document.root.child_nodes[1].namespaces<upper>.uri eq 'http://zvon.org/uppercase', 'BBB namespace url' );

    ok( $document.root.child_nodes[1].child_nodes[0].name eq 'CCC', 'CCC name' );
    ok( $document.root.child_nodes[1].child_nodes[0].prefix eq 'upper', 'CCC prefix' );
    ok( $document.root.child_nodes[1].child_nodes[0].namespaces<upper>.name eq 'upper', 'CCC namespace name' );
    ok( $document.root.child_nodes[1].child_nodes[0].namespaces<upper>.uri eq 'http://zvon.org/uppercase', 'CCC namespace url' );

    ok( $document.root.child_nodes[2].name eq 'x111', 'x111 name' );
    ok( $document.root.child_nodes[2].prefix eq 'xnumber', 'x111 prefix' );
    ok( $document.root.child_nodes[2].namespaces<xnumber>.name eq 'xnumber', 'x111 namespace name' );
    ok( $document.root.child_nodes[2].namespaces<xnumber>.uri eq 'http://zvon.org/xnumber', 'x111 namespace url' );

    ok( $document.root.child_nodes[2].child_nodes[0].name eq 'x222', 'x222 name' );
    ok( $document.root.child_nodes[2].child_nodes[0].prefix eq 'xnumber', 'x222 prefix' );
    ok( $document.root.child_nodes[2].child_nodes[0].namespaces<xnumber>.name eq 'xnumber', 'x222 namespace name' );
    ok( $document.root.child_nodes[2].child_nodes[0].namespaces<xnumber>.uri eq 'http://zvon.org/xnumber', 'x222 namespace url' );
},

# It is a common practice to declare all namespaces within the root element.

'<lower:aaa xmlns:lower = "http://zvon.org/lowercase" xmlns:upper = "http://zvon.org/uppercase" xmlns:xnumber = "http://zvon.org/xnumber">
    <lower:bbb>
        <lower:ccc />
    </lower:bbb>
    <upper:BBB>
        <upper:CCC />
    </upper:BBB>
    <xnumber:x111>
        <xnumber:x222 />
    </xnumber:x111>
</lower:aaa>',

-> $document {
    ok( $document.root.name eq 'aaa', 'aaa name' );
    ok( $document.root.prefix eq 'lower' ?? 1 !! 0, 'aaa prefix' );
    ok( $document.root.namespaces<lower>.name eq 'lower', 'aaa namespace name' );
    ok( $document.root.namespaces<lower>.uri eq 'http://zvon.org/lowercase', 'aaa namespace url' );

    ok( $document.root.child_nodes[0].name eq 'bbb', 'bbb name' );
    ok( $document.root.child_nodes[0].prefix eq 'lower', 'bbb prefix' );
    ok( $document.root.child_nodes[0].namespaces<lower>.name eq 'lower', 'bbb namespace name' );
    ok( $document.root.child_nodes[0].namespaces<lower>.uri eq 'http://zvon.org/lowercase', 'bbb namespace url' );

    ok( $document.root.child_nodes[0].child_nodes[0].name eq 'ccc', 'ccc name' );
    ok( $document.root.child_nodes[0].child_nodes[0].prefix eq 'lower', 'ccc prefix' );
    ok( $document.root.child_nodes[0].child_nodes[0].namespaces<lower>.name eq 'lower', 'ccc namespace name' );
    ok( $document.root.child_nodes[0].child_nodes[0].namespaces<lower>.uri eq 'http://zvon.org/lowercase', 'ccc namespace url' );

    ok( $document.root.child_nodes[1].name eq 'BBB', 'BBB name' );
    ok( $document.root.child_nodes[1].prefix eq 'upper', 'BBB prefix' );
    ok( $document.root.child_nodes[1].namespaces<upper>.name eq 'upper', 'BBB namespace name' );
    ok( $document.root.child_nodes[1].namespaces<upper>.uri eq 'http://zvon.org/uppercase', 'BBB namespace url' );

    ok( $document.root.child_nodes[1].child_nodes[0].name eq 'CCC', 'CCC name' );
    ok( $document.root.child_nodes[1].child_nodes[0].prefix eq 'upper', 'CCC prefix' );
    ok( $document.root.child_nodes[1].child_nodes[0].namespaces<upper>.name eq 'upper', 'CCC namespace name' );
    ok( $document.root.child_nodes[1].child_nodes[0].namespaces<upper>.uri eq 'http://zvon.org/uppercase', 'CCC namespace url' );

    ok( $document.root.child_nodes[2].name eq 'x111', 'x111 name' );
    ok( $document.root.child_nodes[2].prefix eq 'xnumber', 'x111 prefix' );
    ok( $document.root.child_nodes[2].namespaces<xnumber>.name eq 'xnumber', 'x111 namespace name' );
    ok( $document.root.child_nodes[2].namespaces<xnumber>.uri eq 'http://zvon.org/xnumber', 'x111 namespace url' );

    ok( $document.root.child_nodes[2].child_nodes[0].name eq 'x222', 'x222 name' );
    ok( $document.root.child_nodes[2].child_nodes[0].prefix eq 'xnumber', 'x222 prefix' );
    ok( $document.root.child_nodes[2].child_nodes[0].namespaces<xnumber>.name eq 'xnumber', 'x222 namespace name' );
    ok( $document.root.child_nodes[2].child_nodes[0].namespaces<xnumber>.uri eq 'http://zvon.org/xnumber', 'x222 namespace url' );
},

# The value of the xmlns attribute identifies the namespace, not the prefix.
# In this example, all elements belongs to the same namespace although different prefixes are used.

'<lower:aaa xmlns:lower = "http://zvon.org/lowercase" xmlns:upper = "http://zvon.org/lowercase" xmlns:xnumber = "http://zvon.org/lowercase">
    <lower:bbb>
        <lower:ccc />
    </lower:bbb>
    <upper:BBB>
        <upper:CCC />
    </upper:BBB>
    <xnumber:x111>
        <xnumber:x222 />
    </xnumber:x111>
</lower:aaa>',

-> $document {
    ok( $document.root.name eq 'aaa', 'aaa name' );
    ok( $document.root.prefix eq 'lower' ?? 1 !! 0, 'aaa prefix' );
    ok( $document.root.namespaces<lower>.name eq 'lower', 'aaa namespace name' );
    ok( $document.root.namespaces<lower>.uri eq 'http://zvon.org/lowercase', 'aaa namespace url' );

    ok( $document.root.child_nodes[0].name eq 'bbb', 'bbb name' );
    ok( $document.root.child_nodes[0].prefix eq 'lower', 'bbb prefix' );
    ok( $document.root.child_nodes[0].namespaces<lower>.name eq 'lower', 'bbb namespace name' );
    ok( $document.root.child_nodes[0].namespaces<lower>.uri eq 'http://zvon.org/lowercase', 'bbb namespace url' );

    ok( $document.root.child_nodes[0].child_nodes[0].name eq 'ccc', 'ccc name' );
    ok( $document.root.child_nodes[0].child_nodes[0].prefix eq 'lower', 'ccc prefix' );
    ok( $document.root.child_nodes[0].child_nodes[0].namespaces<lower>.name eq 'lower', 'ccc namespace name' );
    ok( $document.root.child_nodes[0].child_nodes[0].namespaces<lower>.uri eq 'http://zvon.org/lowercase', 'ccc namespace url' );

    ok( $document.root.child_nodes[1].name eq 'BBB', 'BBB name' );
    ok( $document.root.child_nodes[1].prefix eq 'upper', 'BBB prefix' );
    ok( $document.root.child_nodes[1].namespaces<upper>.name eq 'upper', 'BBB namespace name' );
    ok( $document.root.child_nodes[1].namespaces<upper>.uri eq 'http://zvon.org/lowercase', 'BBB namespace url' );

    ok( $document.root.child_nodes[1].child_nodes[0].name eq 'CCC', 'CCC name' );
    ok( $document.root.child_nodes[1].child_nodes[0].prefix eq 'upper', 'CCC prefix' );
    ok( $document.root.child_nodes[1].child_nodes[0].namespaces<upper>.name eq 'upper', 'CCC namespace name' );
    ok( $document.root.child_nodes[1].child_nodes[0].namespaces<upper>.uri eq 'http://zvon.org/lowercase', 'CCC namespace url' );

    ok( $document.root.child_nodes[2].name eq 'x111', 'x111 name' );
    ok( $document.root.child_nodes[2].prefix eq 'xnumber', 'x111 prefix' );
    ok( $document.root.child_nodes[2].namespaces<xnumber>.name eq 'xnumber', 'x111 namespace name' );
    ok( $document.root.child_nodes[2].namespaces<xnumber>.uri eq 'http://zvon.org/lowercase', 'x111 namespace url' );

    ok( $document.root.child_nodes[2].child_nodes[0].name eq 'x222', 'x222 name' );
    ok( $document.root.child_nodes[2].child_nodes[0].prefix eq 'xnumber', 'x222 prefix' );
    ok( $document.root.child_nodes[2].child_nodes[0].namespaces<xnumber>.name eq 'xnumber', 'x222 namespace name' );
    ok( $document.root.child_nodes[2].child_nodes[0].namespaces<xnumber>.uri eq 'http://zvon.org/lowercase', 'x222 namespace url' );
},

# While in the Example 5 all elements belonged to the same namespace although they had different
# prefixes, in this case they belong to different namespaces although they have the same prefixes.

'<aaa>
    <lower:bbb xmlns:lower = "http://zvon.org/lowercase">
        <lower:ccc />
    </lower:bbb>
    <lower:BBB xmlns:lower = "http://zvon.org/uppercase">
        <lower:CCC />
    </lower:BBB>
    <lower:x111 xmlns:lower = "http://zvon.org/xnumber">
        <lower:x222 />
    </lower:x111>
</aaa>',

-> $document {
    ok( $document.root.name eq 'aaa', 'aaa name' );
    ok( $document.root.prefix eq '' ?? 1 !! 0, 'aaa prefix' );

    ok( $document.root.child_nodes[0].name eq 'bbb', 'bbb name' );
    ok( $document.root.child_nodes[0].prefix eq 'lower', 'bbb prefix' );
    ok( $document.root.child_nodes[0].namespaces<lower>.name eq 'lower', 'bbb namespace name' );
    ok( $document.root.child_nodes[0].namespaces<lower>.uri eq 'http://zvon.org/lowercase', 'bbb namespace url' );

    ok( $document.root.child_nodes[0].child_nodes[0].name eq 'ccc', 'ccc name' );
    ok( $document.root.child_nodes[0].child_nodes[0].prefix eq 'lower', 'ccc prefix' );
    ok( $document.root.child_nodes[0].child_nodes[0].namespaces<lower>.name eq 'lower', 'ccc namespace name' );
    ok( $document.root.child_nodes[0].child_nodes[0].namespaces<lower>.uri eq 'http://zvon.org/lowercase', 'ccc namespace url' );

    ok( $document.root.child_nodes[1].name eq 'BBB', 'BBB name' );
    ok( $document.root.child_nodes[1].prefix eq 'lower', 'BBB prefix' );
    ok( $document.root.child_nodes[1].namespaces<lower>.name eq 'lower', 'BBB namespace name' );
    ok( $document.root.child_nodes[1].namespaces<lower>.uri eq 'http://zvon.org/uppercase', 'BBB namespace url' );

    ok( $document.root.child_nodes[1].child_nodes[0].name eq 'CCC', 'CCC name' );
    ok( $document.root.child_nodes[1].child_nodes[0].prefix eq 'lower', 'CCC prefix' );
    ok( $document.root.child_nodes[1].child_nodes[0].namespaces<lower>.name eq 'lower', 'CCC namespace name' );
    ok( $document.root.child_nodes[1].child_nodes[0].namespaces<lower>.uri eq 'http://zvon.org/uppercase', 'CCC namespace url' );

    ok( $document.root.child_nodes[2].name eq 'x111', 'x111 name' );
    ok( $document.root.child_nodes[2].prefix eq 'lower', 'x111 prefix' );
    ok( $document.root.child_nodes[2].namespaces<lower>.name eq 'lower', 'x111 namespace name' );
    ok( $document.root.child_nodes[2].namespaces<lower>.uri eq 'http://zvon.org/xnumber', 'x111 namespace url' );

    ok( $document.root.child_nodes[2].child_nodes[0].name eq 'x222', 'x222 name' );
    ok( $document.root.child_nodes[2].child_nodes[0].prefix eq 'lower', 'x222 prefix' );
    ok( $document.root.child_nodes[2].child_nodes[0].namespaces<lower>.name eq 'lower', 'x222 namespace name' );
    ok( $document.root.child_nodes[2].child_nodes[0].namespaces<lower>.uri eq 'http://zvon.org/xnumber', 'x222 namespace url' );
},

# Namespaces do not have to be declared explicitly with prefixes.
# The attribute xmlns defines the default namespace which is used for the element where it
# occures and for its children and descendants.

'<aaa>
    <bbb xmlns = "http://zvon.org/lowercase">
        <ccc />
    </bbb>
    <BBB xmlns = "http://zvon.org/uppercase">
        <CCC />
    </BBB>
    <x111 xmlns = "http://zvon.org/xnumber">
        <x222 />
    </x111>
</aaa>',

-> $document {
    ok( $document.root.child_nodes[0].name eq 'bbb', 'bbb name' );
    ok( $document.root.child_nodes[0].prefix eq '', 'bbb prefix' );
    ok( $document.root.child_nodes[0].namespaces{''}.name eq '', 'bbb namespace name' );
    ok( $document.root.child_nodes[0].namespaces{''}.uri eq 'http://zvon.org/lowercase', 'bbb namespace url' );

    ok( $document.root.child_nodes[0].child_nodes[0].name eq 'ccc', 'ccc name' );
    ok( $document.root.child_nodes[0].child_nodes[0].prefix eq '', 'ccc prefix' );
    ok( $document.root.child_nodes[0].child_nodes[0].namespaces{''}.name eq '', 'ccc namespace name' );
    ok( $document.root.child_nodes[0].child_nodes[0].namespaces{''}.uri eq 'http://zvon.org/lowercase', 'ccc namespace url' );

    ok( $document.root.child_nodes[1].name eq 'BBB', 'BBB name' );
    ok( $document.root.child_nodes[1].prefix eq '', 'BBB prefix' );
    ok( $document.root.child_nodes[1].namespaces{''}.name eq '', 'BBB namespace name' );
    ok( $document.root.child_nodes[1].namespaces{''}.uri eq 'http://zvon.org/uppercase', 'BBB namespace url' );

    ok( $document.root.child_nodes[1].child_nodes[0].name eq 'CCC', 'CCC name' );
    ok( $document.root.child_nodes[1].child_nodes[0].prefix eq '', 'CCC prefix' );
    ok( $document.root.child_nodes[1].child_nodes[0].namespaces{''}.name eq '', 'CCC namespace name' );
    ok( $document.root.child_nodes[1].child_nodes[0].namespaces{''}.uri eq 'http://zvon.org/uppercase', 'CCC namespace url' );

    ok( $document.root.child_nodes[2].name eq 'x111', 'x111 name' );
    ok( $document.root.child_nodes[2].prefix eq '', 'x111 prefix?' );
    ok( $document.root.child_nodes[2].namespaces{''}.name eq '', 'x111 namespace name' );
    ok( $document.root.child_nodes[2].namespaces{''}.uri eq 'http://zvon.org/xnumber', 'x111 namespace url' );

    ok( $document.root.child_nodes[2].child_nodes[0].name eq 'x222', 'x222 name' );
    ok( $document.root.child_nodes[2].child_nodes[0].prefix eq '', 'x222 prefix' );
    ok( $document.root.child_nodes[2].child_nodes[0].namespaces{''}.name eq '', 'x222 namespace name' );
    ok( $document.root.child_nodes[2].child_nodes[0].namespaces{''}.uri eq 'http://zvon.org/xnumber', 'x222 namespace url' );

},

# Even if default namespaces are used, namespaces for chosen elements can still be explicitly stated.

'<aaa xmlns:upper = "http://zvon.org/uppercase" xmlns:xnumber = "http://zvon.org/xnumber">
    <bbb xmlns = "http://zvon.org/lowercase">
        <ccc />
        <upper:WWW />
        <xnumber:x666 />
    </bbb>
    <BBB xmlns = "http://zvon.org/uppercase">
        <upper:WWW />
        <xnumber:x666 />
        <CCC />
    </BBB>
    <x111 xmlns = "http://zvon.org/xnumber">
        <x222 />
        <upper:WWW />
        <xnumber:x666 />
    </x111>
</aaa>',

-> $document {
    ok( $document.root.name eq 'aaa', 'aaa name' );
    ok( $document.root.prefix eq '' ?? 1 !! 0, 'aaa prefix' );
    ok( $document.root.namespaces<upper>.name eq 'upper', 'aaa namespace name 1' );
    ok( $document.root.namespaces<upper>.uri eq 'http://zvon.org/uppercase', 'aaa namespace url 1' );
    ok( $document.root.namespaces<xnumber>.name eq 'xnumber', 'aaa namespace name 2' );
    ok( $document.root.namespaces<xnumber>.uri eq 'http://zvon.org/xnumber', 'aaa namespace url 2' );

    ok( $document.root.child_nodes[0].name eq 'bbb', 'bbb name' );
    ok( $document.root.child_nodes[0].prefix eq '', 'bbb prefix' );
    ok( $document.root.child_nodes[0].namespaces{''}.name eq '', 'bbb namespace name' );
    ok( $document.root.child_nodes[0].namespaces{''}.uri eq 'http://zvon.org/lowercase', 'bbb namespace url' );

    ok( $document.root.child_nodes[0].child_nodes[0].name eq 'ccc', 'ccc name' );
    ok( $document.root.child_nodes[0].child_nodes[0].prefix eq '', 'ccc prefix' );
    ok( $document.root.child_nodes[0].child_nodes[0].namespaces{''}.name eq '', 'ccc namespace name' );
    ok( $document.root.child_nodes[0].child_nodes[0].namespaces{''}.uri eq 'http://zvon.org/lowercase', 'ccc namespace url' );

    ok( $document.root.child_nodes[0].child_nodes[1].name eq 'WWW', 'WWW name' );
    ok( $document.root.child_nodes[0].child_nodes[1].prefix eq 'upper', 'WWW prefix' );
    ok( $document.root.child_nodes[0].child_nodes[1].namespaces<upper>.name eq 'upper', 'WWW namespace name' );
    ok( $document.root.child_nodes[0].child_nodes[1].namespaces<upper>.uri eq 'http://zvon.org/uppercase', 'WWW namespace url' );

    ok( $document.root.child_nodes[0].child_nodes[2].name eq 'x666', 'x666 name' );
    ok( $document.root.child_nodes[0].child_nodes[2].prefix eq 'xnumber', 'x666 prefix' );
    ok( $document.root.child_nodes[0].child_nodes[2].namespaces<xnumber>.name eq 'xnumber', 'x666 namespace name' );
    ok( $document.root.child_nodes[0].child_nodes[2].namespaces<xnumber>.uri eq 'http://zvon.org/xnumber', 'x666 namespace url' );
},

# Default namespaces can be undeclared if an empty string is used for its value.

'<aaa xmlns = "http://zvon.org/lowercase">
    <bbb>
        <ccc xmlns = "">
            <ddd />
        </ccc>
    </bbb>
</aaa>',

-> $document {
    ok( $document.root.name eq 'aaa', 'aaa name' );
    ok( $document.root.prefix eq '' ?? 1 !! 0, 'aaa prefix' );
    ok( $document.root.namespaces{''}.name eq '', 'aaa namespace name' );
    ok( $document.root.namespaces{''}.uri eq 'http://zvon.org/lowercase', 'aaa namespace url' );

    ok( $document.root.child_nodes[0].name eq 'bbb', 'bbb name' );
    ok( $document.root.child_nodes[0].prefix eq '', 'bbb prefix' );
    ok( $document.root.child_nodes[0].namespaces{''}.name eq '', 'bbb namespace name' );
    ok( $document.root.child_nodes[0].namespaces{''}.uri eq 'http://zvon.org/lowercase', 'bbb namespace url' );

    ok( $document.root.child_nodes[0].child_nodes[0].name eq 'ccc', 'ccc name' );
    ok( $document.root.child_nodes[0].child_nodes[0].prefix eq '', 'ccc prefix' );
    ok( $document.root.child_nodes[0].child_nodes[0].namespaces{''}.name eq '', 'ccc namespace name' );
    ok( $document.root.child_nodes[0].child_nodes[0].namespaces{''}.uri eq '', 'ccc namespace url' );

    ok( $document.root.child_nodes[0].child_nodes[0].child_nodes[0].name eq 'ddd', 'ddd name' );
    ok( $document.root.child_nodes[0].child_nodes[0].child_nodes[0].prefix eq '', 'ddd prefix' );
    ok( $document.root.child_nodes[0].child_nodes[0].child_nodes[0].namespaces{''}.name eq '', 'ddd namespace name' );
    ok( $document.root.child_nodes[0].child_nodes[0].child_nodes[0].namespaces{''}.uri eq '', 'ddd namespace url' );
},

# Attributes can be also explicitly assigned to the given namespace.

'<lower:aaa xmlns:lower = "http://zvon.org/lowercase" xmlns:upper = "http://zvon.org/uppercase"
            xmlns:xnumber = "http://zvon.org/xnumber">
    <lower:bbb lower:zz = "11">
        <lower:ccc upper:WW = "22" />
    </lower:bbb>
    <upper:BBB lower:sss = "***" xnumber:S111 = "???" />
    <xnumber:x111 />
</lower:aaa>',

-> $document {
    ok( $document.root.child_nodes[0].attributes[0].name   eq 'zz', 'bbb attribute namespace name' );
    ok( $document.root.child_nodes[0].attributes[0].prefix eq 'lower', 'bbb attribute namespace prefix' );
    ok( $document.root.child_nodes[0].attributes[0].namespace.uri eq 'http://zvon.org/lowercase' );

    ok( $document.root.child_nodes[0].child_nodes[0].attributes[0].name   eq 'WW', 'ccc attribute namespace name' );
    ok( $document.root.child_nodes[0].child_nodes[0].attributes[0].prefix eq 'upper', 'ccc attribute namespace prefix' );
    ok( $document.root.child_nodes[0].child_nodes[0].attributes[0].namespace.uri eq 'http://zvon.org/uppercase' );
},

# Attributes without a prefix never belongs to any namespace.

'<lower:aaa xmlns:lower = "http://zvon.org/lowercase" xmlns:upper = "http://zvon.org/uppercase"
            xmlns:xnumber = "http://zvon.org/xnumber">
    <lower:bbb zz = "11">
        <lower:ccc WW = "22" />
    </lower:bbb>
    <upper:BBB sss = "***" xnumber:S111 = "???" />
    <xnumber:x111 />
</lower:aaa>',

-> $document {
    ok( $document.root.child_nodes[0].attributes[0].name   eq 'zz', 'bbb attribute namespace name' );
    ok( $document.root.child_nodes[0].attributes[0].prefix eq '', 'bbb attribute namespace prefix' );
    ok( !$document.root.child_nodes[0].attributes[0].namespace, 'bbb no namespace' );
},

# The attributes do not belong to any namespace even if a default namespace is defined for the
# relevant element.

'<aaa xmlns = "http://zvon.org/lowercase" xmlns:upper = "http://zvon.org/uppercase"
      xmlns:xnumber = "http://zvon.org/xnumber">
    <bbb zz = "11">
        <ccc WW = "22" xmlns = "http://zvon.org/uppercase" />
    </bbb>
    <upper:BBB sss = "***" xnumber:S111 = "???" />
    <xnumber:x111 />
</aaa>',

-> $document {
    ok( $document.root.child_nodes[0].attributes[0].name   eq 'zz', 'bbb attribute namespace name' );
    ok( $document.root.child_nodes[0].attributes[0].prefix eq '', 'bbb attribute namespace prefix' );
    ok( !$document.root.child_nodes[0].attributes[0].namespace, 'bbb no namespace' );
},

# The namespace declaration is restricted to the scope of the element where it is declared.

'<aaa xmlns:lower = "http://zvon.org/lowercase">
    <lower:BBB xmlns:lower = "http://zvon.org/uppercase">
        <lower:x111 />
        <sss xmlns:lower = "http://zvon.org/xnumber">
            <lower:x111 />
        </sss>
    </lower:BBB>
    <lower:x111 />
</aaa>',

-> $document {
    ok( $document.root.name eq 'aaa', 'aaa name' );
    ok( $document.root.prefix eq '' ?? 1 !! 0, 'aaa prefix' );
    ok( $document.root.namespaces<lower>.name eq 'lower', 'aaa namespace name' );
    ok( $document.root.namespaces<lower>.uri eq 'http://zvon.org/lowercase', 'aaa namespace url' );

    ok( $document.root.first_child.name eq 'BBB', 'BBB name' );
    ok( $document.root.first_child.prefix eq 'lower', 'BBB prefix' );
    ok( $document.root.first_child.namespaces<lower>.name eq 'lower', 'BBB namespace name' );
    ok( $document.root.first_child.namespaces<lower>.uri eq 'http://zvon.org/uppercase', 'BBB namespace url' );

    ok( $document.root.first_child.child_nodes[1].name eq 'sss', 'sss name' );
    ok( $document.root.first_child.child_nodes[1].prefix eq '', 'sss prefix' );
    ok( $document.root.first_child.child_nodes[1].namespaces<lower>.name eq 'lower', 'sss namespace name' );
    ok( $document.root.first_child.child_nodes[1].namespaces<lower>.uri eq 'http://zvon.org/xnumber', 'BBB namespace url' );

    ok( $document.root.first_child.child_nodes[1].first_child.name eq 'x111', 'x111 name' );
    ok( $document.root.first_child.child_nodes[1].first_child.prefix eq 'lower', 'x111 prefix' );
    ok( $document.root.first_child.child_nodes[1].first_child.namespaces<lower>.name eq 'lower', 'x111 namespace name' );
    ok( $document.root.first_child.child_nodes[1].first_child.namespaces<lower>.uri eq 'http://zvon.org/xnumber', 'root namespace url');

    ok( $document.root.child_nodes[1].name eq 'x111', 'x111 name 2' );
    ok( $document.root.child_nodes[1].prefix eq 'lower', 'x111 prefix 2' );
    ok( $document.root.child_nodes[1].namespaces<lower>.name eq 'lower', 'BBB namespace name 2' );
    ok( $document.root.child_nodes[1].namespaces<lower>.uri eq 'http://zvon.org/lowercase', 'BBB namespace url 2' );
}

;

my $examples = 2;

for @cases -> $xml, $code {
    my $parser;

    ok( 1, 'example' ~ $examples++ );

    lives_ok( { $parser = XML::Parser.new }, 'instance' );

    $parser.parse( $xml, 'dom' );

    isa_ok( $parser.document, XML::Parser::Dom::Document, 'contains a document' );

    $code( $parser.document );
}