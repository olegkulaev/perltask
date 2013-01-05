use Test::More;
use form;
ok(form::spaceAvtomat('first   second') eq 'first second', 'first   second');
ok(form::spaceAvtomat('"firs  t"   "second"') eq '"firs  t" "second"', '"firs  t"   "second"'); # ������ ����� ""   "" -> "" ""
ok(form::spaceAvtomat("'firs  t'   'second'") eq "'firs  t' 'second'", "'firs  t'   'second'"); # ������ ����� ''   '' -> '' ''
ok(form::spaceAvtomat("\"firs  t\"   'second'") eq "\"firs  t\" 'second'", "\"firs  t\"   'second'"); # ������ ����� ""   '' -> "" ''
ok(form::spaceAvtomat("   'second'  \"firs  t\"   'second'") eq " 'second' \"firs  t\" 'second'", "   'second'  \"firs  t\"   'second'");# ������ ����� ''    ""   '' -> '' "" ''
ok(form::spaceAvtomat("\"firs  t\"   'se\"c   on\"d'") eq "\"firs  t\" 'se\"c   on\"d'", "\"firs  t\"   'se\"c   on\"d'"); # ������ ����� ""   '"   "' -> "" '"   "'
ok(form::spaceAvtomat("\"fi'r    s'  t\"   'second'") eq "\"fi'r    s'  t\" 'second'", "\"fi'r    s'  t\"   'second'"); # ������ ����� "'   '"   '' -> "'   '" ''
ok(form::spaceAvtomat("\"fi\\\"r    s\\\"  t\"   'second'") eq "\"fi\\\"r    s\\\"  t\" 'second'", "\"fi\\\"r    s\\\"  t\"   'second'"); # ������ ����� "\"   \""   '' -> "\"   \"" ''
ok(form::spaceAvtomat("'fi\\'r    s\\'  t'   'second'") eq "'fi\\'r    s\\'  t\' 'second'", "'fi\\'r    s\\'  t'   'second'"); # ������ ����� '\'   \''   '' -> '\'   \'' '
ok(form::spaceAvtomat('a   =   "B +    3+   dssd"') eq 'a = "B +    3+   dssd"', 'a   =   "B +    3+   dssd"'); # ������ ������
done_testing();