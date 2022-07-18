之前就有混用的情况



tree.c

		switch (fn(&entry.oid, base,
			   entry.path, entry.mode, context)) {
		case 0:
			continue;
		case READ_TREE_RECURSIVE:
			break;
		default:
			return -1;
		}


path:  相对于当前工作目录

   例如，当你在一个有目录dir的子目录下，你可以运行git ls-tree -r HEAD dir来列出树的内容(即HEAD中的sub/dir

   在这种情况下，你不想给出一个不在根级别的树(例如git ls-tree -r HEAD:sub dir)，因为这将导致在HEAD提交中请求sub/sub/dir

   但是，通过传递——full-tree选项可以忽略当前工作目录。

                        
if no path passed means retval = 0 (we need all the objects of <tree-ish>)

if path passed 



原来没有注意到这里， 测试用例， 其实这里的retval是有用的， 因为。。。决定了是continue还是break， 对逻辑实际上有影响，不管测试用例通过与否， 我希望做一些逻辑的简化和命名的修改。





$hyperfine --warmup=10 "/opt/git/master/bin/git ls-tree -r HEAD"
Benchmark 1: /opt/git/master/bin/git ls-tree -r HEAD
  Time (mean ± σ):     106.1 ms ±   2.4 ms    [User: 84.6 ms, System: 21.5 ms]
  Range (min … max):    99.5 ms … 109.9 ms    28 runs
 

[tenglong.tl@code-infra-dev-cbj.ea134 /home/tenglong.tl/test/linux]
$hyperfine --warmup=10 "/opt/git/ls-tree-oid-only/bin/git ls-tree -r HEAD"
Benchmark 1: /opt/git/ls-tree-oid-only/bin/git ls-tree -r HEAD
  Time (mean ± σ):     106.7 ms ±   2.3 ms    [User: 85.7 ms, System: 20.9 ms]
  Range (min … max):   102.0 ms … 110.7 ms    27 runs
 
[tenglong.tl@code-infra-dev-cbj.ea134 /home/tenglong.tl/test/linux]
$hyperfine --warmup=10 "/opt/git/master/bin/git ls-tree -r -l HEAD"
Benchmark 1: /opt/git/master/bin/git ls-tree -r -l HEAD
  Time (mean ± σ):     340.5 ms ±   9.8 ms    [User: 312.1 ms, System: 28.3 ms]
  Range (min … max):   325.5 ms … 351.5 ms    10 runs

[tenglong.tl@code-infra-dev-cbj.ea134 /home/tenglong.tl/test/linux]
$hyperfine --warmup=10 "/opt/git/ls-tree-oid-only/bin/git ls-tree -r -l HEAD"
Benchmark 1: /opt/git/ls-tree-oid-only/bin/git ls-tree -r -l HEAD
  Time (mean ± σ):     340.6 ms ±   8.5 ms    [User: 313.3 ms, System: 27.1 ms]
  Range (min … max):   328.2 ms … 355.0 ms    10 runs
 
