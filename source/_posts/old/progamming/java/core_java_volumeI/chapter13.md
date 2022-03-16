---
title: 第十三章 集合
date: 2017-04-24 13:35
tags: Core Java Volume I
---

# 集合

+ 在实现方法时，选择不同的数据结构会导致其实现风格以及性能存在很大差异

## 集合接口

### 将集合的接口与实现分离

+ 队列接口指出可以在队列的尾部添加元素，在队列的头部删除元素，并且可以查找队列中元素的个数。当需要收集对象，并按照“先进先出”的规则检索对象时就应该使用队列

```Java
//一个队列接口的最小形式可能类似下面这样：
interface Queue<E> {
	void add(E element);
	E remove();
	int size();
}
```

+ 队列通常有两种实现方式：一种是使用循环数组；另一种是使用链表。

+ 如果需要一个循环数组队列，就可以使用ArrayDeque类。如果需要一个链表队列，就直接使用LinkedList类，这个类实现了Queue接口

+ 循环数组要比链表更加高效，因此多数人优先选择数组。然而，通常这样做也需要付出一定的代价。
	+ 循环数组是一个有界集合，即容量有限。如果程序中要收集数量没有上线，就最好使用链表来实现。
	+ 另外一组名字以Abstract开头的类，这些类视为类库实现者而设计的。（AbstractQuence）

### Java类库中的集合接口和迭代器接口

+ 在Java类库中，集合类的基本接口时Collection接口。

```Java
//Collection接口的两个基本方法。
public interface Collection<E> {
	boolean add(E element);
	//如果添加元素确实改变了集合就返回true，如果集合没有发生变化就返回false。
	//如果试图想集中添加一个已经存在的对象，这个添加请求就没有实效，因为集中不允许有重复的对象。

	Iterator<E> iterator();
	//iterator方法用于返回一个实现了Iterator接口的对象。可以使用这个迭代器对象依次返回集合中的元素。
	...
}
```

#### 迭代器

```Java
public interface Iterator<E> {
	E next();
	boolean hasNext();
	void remove();
}

Collection<String> c = ...;
Iterator<String> iter = c.iterator();
while (iter.hasNext()) {
	String element = iter.next();
	do something with element
}

//从Java SE 5.0起，这个循环可以采用一种更优雅的缩写方法。用" for each "循环可以更加简练地表示同样的循环操作：
for(String element : c) {
	do something with element
}
//编译器简单地将" for each "循环翻译为带有迭代器的循环。
//" for each "循环可以与实现了Iterable接口的对象一起工作，这个接口只包含一个方法：
public interface Iterable<E> {
	Iterator<E> iterator();
}
```

+ Collection接口扩展了Iterable接口。因此，对于标准类库中的任何集合都可以使用" for each "循环。

+ 元素被访问的顺序取决于集合类型。
	+ 如果对ArrayList进行迭代，迭代器将从索引0开始，每迭代一次，索引值加1
	+ 如果访问HashSet中的元素，每个元素将会按照某种随机的次序出现。虽然可以确定在迭代过程中能够遍历到集合中的所有元素，但却无法预知元素被访问的次序。

+ Iterator接口的next和hasNext方法于Enumeration接口的nextElement和hasMoreElements方法的作用一样。Java集合类库的设计者可以选择使用Enumeration接口。他们不喜欢这个接口累赘的方法名，于是引入了具有较短方法名的新接口。

+ Java集合类库中的迭代器与其他库中的迭代器在概念上有着重要的区别。
	+ C++的标准模板库，迭代器是根据数组索引建模的。如果给定这样一个迭代器，就可以查看指定位置上的元素。
	+ Java迭代器并不是这样操作的。查找操作和位置变更是紧密相连的。查找一个元素的唯一方法时调用next，而在执行查找操作的同时，迭代器的位置随之向前移动。
		+ 将Java迭代器认为是位于两个元素之间。当调用next时，迭代器就越过下一个元素，并返回刚刚越过的那个元素的引用。
		+ 类推：可以将Iterator.next与InputStream.read看作为等效的。从数据流中读取一个字节，就会自动地“消耗掉”这个字节。下一个调用read将会消耗并返回输入的下一个字节。同样的，反复地调用next就可以读取集合中的所有元素。

#### 删除元素

+ Iterator接口的remove方法将会删除上次调用next方法时返回的元素。

+ 如果想要删除指定位置上的元素，仍然需要越过这个元素。

	```Java
	//如何删除字符串集合中第一个元素的方法：
	Iterator<String> it = c.iterator();
	it.next(); // skip over the first element
	it.remove(); // now remove it

	//对next方法和remove方法的调用具有互相依赖性。如果调用remove之前没有调用next将是不合法的。会抛出一个IllegalStateException异常。

	//如果想直接删除两个相邻的元素，不能直接地这样调用：
	it.remove();
	it.remove();//Error

	//必须先调用next越过将要删除的元素
	it.remove();
	it.next();
	it.remove(); //OK
	```

#### 泛型实用方法

+ 由于Collection与Iterator都是泛型接口，可以编写操作任何集合类型的实用方法。

	```Java
	//检测任意集合是否包含指定元素的泛型方法：
    	public static <E> boolean contains(Collection<E> c, Object obj) {
    		for(E element : c)
    			if (element.equals(obj))
    				return true;
    		return false;
    	}
    ```

+ Java类库提供了一个类AbstractCollection，它将基础方法size和iterator抽象化了，但是在此提供了例行方法。

	```Java
	public abstract class AbstractCollection<E> implements Collection<E> {
		...
		public abstract Iterator<E> iterator();

		public boolean contains(Object obj) {
			for(E element : this)
				if(element.equals(obj))
					return true;
			return false;
		}
	}
	```

```Java
API java.util.Collection<E> 1.2
	Iterator<E> iterator()
	//返回一个用于访问集合中每个元素的迭代器

	int size()
	boolean isEmpty()
	boolean contains(Object obj)
	boolean containsAll(Collection<?> other)
	boolean add(Object element)
	boolean addAll(Collection<? extends E> other)
	//将other集合中的所有元素添加到这个集合。如果由于这个调用改变了集合，返回true。
	boolean remove(Object obj)
	boolean removeAll(Collection<?> other)
	//从这个集合中删除other集合中存在的所有元素。如果由于这个调用改变了集合，返回true。
	void clear()
	boolean retainAll(Collection<?> other)
	//从这个集合中删除所有与other集合中的元素不同的元素。如果由于这个调用改变了集合，返回true
	Object[] toArray()
	//返回这个集合的对象数组
	<T> T[] toArray(T[] arrayToFill)
	//返回这个集合的对象数组。如果arrayToFill足够大，就将集合中的元素填入这个数组中。
	//剩余空间填补null；否则，分配一个新数组，其成员类型与ArrayToFill的成员类型相同，其长度等于集合的大小，并添入集合元素。

	java.util.Iterator<E> 1.2
	boolean hasNext()
	//如果存在可访问的元素，返回true
	E next()
	//返回将要访问的下一个对象。如果已经到达了集合的尾部，将抛出一个NoSuchElement Exception
	void remove()
	//删除上次访问的对象。这个方法必须紧跟在访问一个元素之后执行。如果上次访问之后，集合已经发生了变化，这个方法将抛出一个IllegalStateException
```

## 具体的集合

+ 表13-1展示了Java类库中的集合，并简要描述了每个集合类的用途。在表13-1中，除了以Map结尾的类之外，其他类都实现了Collection接口。而以Map结尾的类实现了Map接口。

	+ ArrayList：一种可以动态增长和缩减的索引序列
	+ LinkedList：一种可以在任何位置进行高效地插入和删除操作的有序序列
	+ ArrayDeque：一种用循环数组实现的双端队列
	+ HashSet：一种没有重复元素的无序集合
	+ TreeSet：一种有序集
	+ EnumSet：一种包含枚举类型值的集
	+ LinkedHashList：一种可以记住元素插入次序的集
	+ PriorityQuene: 一种允许高效删除最小元素的集合。
	+ HashMap：一种存储键/值关联的数据结构
	+ TreeMap：一种键值有序排列的映射表
	+ EnumMap：一种键值属于枚举类型的映射表
	+ LinkedHashMap：一种可以记住键/值项添加次序的映射表
	+ WeakHashMap：一种其值无用武之地后可以被垃圾回收器回收的映射表
	+ IdentityHashMap：一种用 `==` 而不是用`equals`比较键值的映射表

### 链表

+ 数组和数组列表都有一个重大缺陷。这就是从数组中间位置删除一个元素要付出很大的代价，其原因是数组处于被删除元素之后的所有元素都要向数组的前端移动。在数组中插入元素也是。

+ 数组在连续的存储位置上存放对象引用，但链表却将每个对象存放在独立的节点中。
	+ 每个节点还存放着序列中哦下一个节点的引用。
	+ 在Java程序设计语言中，所有链表实际上都是双向链接的(doubly linked) 即每个节点还存放着指向前驱结点的引用。

+ 从链表中删除一个元素，需要对被删除元素附近的结点更新一下即可。

	```Java
	List<String> staff = new LinkedList<>();
	staff.add("Amy");
	staff.add("Bod");
	Iterator iter = staff.iterator();
	String first = iter.next();
	String second = iter.next();
	iter.remove();
	```

+ 链表与泛型集合之间有一个重要的区别。链表是一个有序集和(ordered collection),每个对象的位置十分重要。
	+ LinkedList.add方法将对象添加到链表的尾部。
	+ 常常需要将元素添加到链表的中间。由于迭代器是描述集合中位置的，所以这种依赖于位置的add方法将由迭代器负责。
	+ 只有对自然有序的集合使用迭代器添加元素才有实际意义。(Set元素无序，其中Iterator接口就没有add方法)
	+ 相反地，集合类库提供了子接口ListIterator，其中包含add方法：

	```Java
	interface ListIterator<E> extends Iterator<E> {
		void add(E element);
		...
	}

	//这个方法不返回boolean类型的值，它假定添加操作总会改变链表。
	//ListIterator接口有两个方法用来~~~~反响遍历链表
	E previous()
	boolean hasPrevious()

	//与next方法一样，previous方法返回越过的对象
	//LinkedList类的listIterator方法返回一个实现了ListIterator接口的迭代器对象。
	ListIterator<String> iter = staff.listIterator();
	```

	+ 如果多次调用add方法，将按照提供的元素添加到链表中。它们被依次添加到迭代器当前位置之前。

	+ 如果链表有n个元素，有n+1个位置可以添加新元素。

	+ 在用“光标”类比时要格外小心。remove操作与BACKSPACE键的工作方式不太一样。在调用next之后，remove方法确实与BACKSPACE键一样删除了迭代器左侧的元素。但是，如果调用previous就会将右侧的元素删除掉，并且不能在同一行中调用两次remove。

	+ add方法只依赖迭代器的位置，而remove方法依赖于迭代器的状态。

```Java
//set方法用一个新元素调用next或previous方法返回的上一个元素。
//将用一个新值取代链表的第一个元素
ListIteratorM<String> iter = list.listIterator();
String oldValue = iter.next();
iter.set(newValue);
```

+ 如果在某个迭代器修改集合时，另一个迭代器对其进行遍历，一定会出现混乱的状况。
	+ 如：一个迭代器指向另一个迭代器刚刚删除的元素前面，现在这个迭代器就是无效的，不能再使用。
	+ 链表迭代器的设计使它的集合被另一个迭代器修改了，或是被该集合自身的方法修改了就会抛出一个ConcurrentModificationException异常。

	```Java
	List<String> list = ...;
	ListIterator<String> iter1 = list.listIterator();
	ListIterator<String> iter2 = list.listIterator();
	iter1.next();
	iter1.remove();
	iter2.next(); //throws ConcurrentModificationException
	```

+ 为了避免发生并发修改的异常，请遵循下述简单规则：可以根据需要给容器附加许多的迭代器，但是这些迭代器只能读取列表。另外，再单独附加一个既能读又能写的迭代器。
	+ 检测到并发修改的问题。集合可以跟踪改写操作(如添加或删除)的次数。每个迭代器都维护一个独立的计数值。在每个迭代器方法的开始处检查自己改写操作的计数值是否与集合的改写操作计数值一致。如果不一致抛出一个ConcurrentModificationException异常

	+ 对于并发修改列表的检测有一个例外：链表只负责跟踪对列表的结构性修改，例如，添加元素，删除元素。set操作不被视为结构性修改。可以将多个迭代器附加给一个链表，所有的迭代器都调用set方法对现有节点的内容进行修改。

+ 链表不支持快速随机访问。如果要查看链表中第n个元素，就必须从头开始，越过n-1个元素。
	+ 在程序需要采用整数索引访问元素时，程序员通常不选用链表。
	+ 尽管如此，LinkedList类还是提供了一个用来访问某个特定元素的get方法：

	```Java
	LinkedList<String> list = ...;
	String obj = list.get(n);
	//这个方法效率并不太高。如果发现自己正在使用这个方法，说明有可能对于索要解决的问题使用了错误的数据结构。

	//绝对不应该使用这种让人误解的随机访问方法来遍历链表。下面这段效率极低：
	for(int i = 0; i < list.size(); i++) {
		do something with list.get(i);
	}

	//每次查找一个元素都要从列表的头部重新来时搜索。LinkedList对象根本不做任何缓存位置信息的操作。
	//get方法做了微小的优化：如果索引大于size()/2就列表尾端开始搜索开始。
	```

+ 列表迭代器接口还有一个方法，可以告之当前位置的索引。实际上，从概念上讲，由于Java迭代器指向两个元素之间的位置，所以可以同时产生两个索引:
	+ nextIndex方法返回下一次调用next方法时返回元素的整数索引；
	+ previousIndex方法返回下一次调用previous方法时返回元素的整数索引。

	+ 这两个方法的效率非常高，这是因为迭代器保持着当前的计数值。

	+ 如果有一个整数索引n，list.listIterator(n)将返回一个迭代器，这个迭代器指向索引为n的元素前面的位置。调用next与调用list.get(n)产生同一个元素。只是获得这个迭代器的效率比较低。

+ 使用链表的唯一理由是尽可能地减少在列表中间插入或删除元素所付出的代价。如果列表只有少数几个元素，就完全可以使用ArrayList。

+ 建议避免使用以整数索引表示链表中位置的所有方法。如果要对集合进行随机访问，就使用数组或ArrayList，而不要使用链表。

```Java
//linkedList/LinkedListTest.java
package linkedList;
import java.util.*;

public class LinkedListTest {
	public static void main(String[] args) {
		List<String> a = new LinkedList<>();
		a.add("Amy");
		a.add("Carl");
		a.add("Erica");

		List<String> b = new LinkedList<>();
		b.add("Bob");
		b.add("Dong");
		b.add("Frances");
		b.add("Gloria");

		// merge the words from b into a
		ListIterator<String> aIter = a.listIterator();
		Iterator<String> bIter = b.iterator();

		while (bIter.hasNext()) {
			if (aIter.hasNext()) aIter.next();
			aIter.add(bIter.next());
		}
		System.out.println(a);

		// remove every second word from b
		bIter = b.iterator();
		while (bIter.hasNext()) {
			bIter.next();
			if (bIter.hasNext()) {
				bIter.next();
				bIter.remove();
			}
		}
		System.out.println(b);

		// bulk operation: remove all words in b from a
		a.removeAll(b);

		System.out.println(a);// 通过调用AbstractCollection类中的toString方法打印出链表a中的所有元素。
	}
}

//绘制迭代器示意图
```

```Java
API java.util.List<E> 1.2
	ListIterator<E> listIterator()
	ListIterator<E> listIterator(int index)
	//返回一个列表迭代器，以便用来访问列表中的元素，这个元素时第一次调用next返回的给定索引的元素。
	void add(int i, E element)
	void addAll(int i, Collection<? extends E> elements)
	E remove(int i)
	//删除给定位置的元素并返回这个元素
	E get(int i)
	E set(int i, E element)
	//用新元素取代给定位置的元素，并返回原来那个元素
	int indexOf(Object element)
	//返回与指定元素相等的元素在列表中第一次出现的位置，如果没有这样的元素将返回-1
	int lastIndexOf(Object element)
	//返回最后一次出现的位置

	java.util.ListIterator<E> 1.2
	void add(E newElement)
	//在当前位置前添加已给元素
	void set(E newElement)
	//用新元素取代next或previous上次访问的元素。如果在next或previous上次调用之后列表结构被修改了，将抛出一个IllegalStateException异常。
	boolean hasPrevious()
	//当反向迭代列表时，还有可供访问的元素，返回true
	E previous()
	//返回前一个对象。如果已经到达了列表的头部，就抛出一个NoSuchElementException异常
	int nextIndex()
	//返回下一次调用next方法时将返回的元素索引。
	int previousIndex()

	java.util.LinkedList<E> 1.2
	LinkedList()
	//构造一个空链表
	LinkedList(Collection<? extends E> elements)
	//构造一个链表，并将集合中欧所有的元素添加到这个链表中
	void addFirst(E element)
	void addLast(E element)
	//将某个元素添加到列表的头部或尾部。
	E removeFirst()
	E removeLast()
	//删除并返回列表头部或尾部的元素 
```

### 数组列表

+ List接口用于描述一个有序集合，并且集合中的每个元素的位置十分重要。有两种访问元素的协议：
	+ 一种是用迭代器
	+ 另一种是用get和set方法随机地访问每个元素。不适用于链表，但对数组却很有效。

+ 集合类库提供了一种大家熟悉的 ArrayList 类，这个类也实现了 List 接口。ArrayList 封装了一个动态再分配的对象数组。

+ 有经验的Java程序员来说，在需要动态数组时，可能会使用 Vector 类。
	+ Vector类的所有方法都是同步的。可以由两个线程安全地访问一个 Vector 对象。
	+ 如果由一个线程访问 Vector，代码要在同步操作上耗费大量的时间。而 ArrayList 方法是不同步的，因此，建议在不需要同步时使用 ArrayList，而不要使用 Vector

### 散列集

+ 链表和数组可以按照人们的意愿排列元素的次序。但是，如果想要查看某个指定的元素，却又忘记了它的位置，就需要访问所有元素，直到找到为止。

+ 散列表，快速地查找所需要的对象。
	+ 散列表为每个对象计算一个整数，称为散列码。
	+ 散列码是由对象的实例域产生的一个整数。
	+ 如果是自定义类，就要负责实现这个类的 hashCode 方法。注意自己实现的 equals 方法兼容。即如果 a.equals(b) 为 true，a 和 b 必须具有相同的散列码。

+ 在 Java 中，散列表用链表数组实现。每个列表被称为桶。
	+ 要想查找表中对象的位置，就要先计算它的散列码，然后与桶的总数取余，所得到的结果就是保存这个元素的桶的索引。
	+ 在这个桶里没有其他的元素，此时将元素直接插入到桶里就可以了。
	+ 有时候会遇到桶被占满的情况。这种现象被称为散列冲突。
	+ 这时需要用新对象与桶中的所有对象进行比较，查看这个对象是否已经存在。如果散列码是合理且随机分布的，桶的数目也足够大，需要比较的次数就会很少。

+ 如果想更多地控制散列表的性能，就要指定一个初始的桶数。
	+ 桶数是指用于收集具有相同散列表的桶的数目。
	+ 如果要插入到散列表中的元素太多，就会增加冲突的可能性，降低运行性能。
	+ 如果大概知道最终会有多少个元素要插入到散列表中，就可以设置桶数。通常，将桶数设置为预计元素个数的 75%~150%
		+ 最好将桶数设置为一个素数，以防键的集聚。标准类库使用的桶数是 2 的幂，默认值是 16
	+ 有时不知道需要存储多少个元素的，也有可能最初的估计过低。如果散列表太满，需要再散列
		+ 如果要对散列表再散列，就需要对散列表再散列，就需要创建一个桶数更多的表，并将所有元素插入到这个新表中，然后丢弃原来的表。
		+ 装填因子(load factor)决定何时对散列表进行再散列。如果装填因子为 0.75 (默认值)，而表中超过 75% 的位置已经填入元素，这个表就会用双倍的桶数自动地进行再散列。对于大多数应用程序来说，装填因子为 0.75 是比较合理。

+ 散列表用于实现几个重要的数据结构。
	+ 其中最简单的是 set 类型。
		+ set 是没有重复元素集合。
		+ set 的add方法首先在集中查找要添加的对象，如果不存在，就将这个对象添加进去。
	+ Java 集合类库提供了一个 HashSet 类，它实现了基于散列表的集。可以用 add 添加元素。contains 方法已经被重新定义，用来快速地查看是否某个元素已经出现在集中。它只在某个桶中查找元素，而不必查看集合中的所有元素。
		+ 散列集迭代器将依次访问所有的桶。由于散列将元素分散在表的各个位置上。所以访问它们的顺序几乎是随机的。只是不关心集合中元素的顺序时才应该使用 HashSet

+ 在更改集中的元素时要格外小心。如果元素的散列码发生了改变，元素在数据结构中的位置也会发生改变。

```Java
set/SetTest.java

package set;
import java.util.*;

public class SetTest {
	public static void main(String[] args) {
		Set<String> words = new HashSet<>(); // HashSet implements Set
		long totalTime = 0;

		Scanner in = new Scanner(System.in);
		while(in.hasNext()) {
			String word = in.next();
			long callTime = System.currentTimeMillis();
			words.add(word);
			callTime = System.currentTimeMillis() - callTime;
			totalTime += callTime;
		}

		Iterator<String> iter = words.iterator();
		for(int i = 1; i <= 20 && iter.hasNext(); i++)
			System.out.println(iter.next());
		System.out.println("....")';
		System.out.println(words.size() + " distinct words. " + totalTime + " milliseconds. ");
	}
}
```

```Java
API	java.util.HashSet<E> 1.2

	HashSet()
	//构造一个空散列表
	HashSet(Collection<? extends E> elements)
	//构造一个散列集，并将集合中的所有元素添加到这个散列集中。

	HashSet(int initialCapacity)
	//构造一个空的具有指定容量(桶数)的散列集
	HashSet(int initialCapacity, float loadFactor)
	//构造一个具有指定容量和装填因子(一个0.0~1.0之间的数值，确定散列表填充的百分比，当大于这个百分比时，散列表进行再散列)的散列集。

	java.lang.Object 1.0

	int hashCode()
	//返回这个对象的散列码，散列码可以是任何整数，包括正数或负数。equals和hashCode的定义必须兼容，即如果x.equals(y)为true，x.hashCode()必须等于y.hashCode()
```

### 树集

+ 树集是一个有序集合(sorted collection)。可以以任意顺序将元素插入到集合中。在对集合进行遍历时，每个值将自动地按照排序后的顺序呈现。

	```Java
	SortedSet<String> sort = new TreeSet<>(); // TreeSet implements SortedSet
	sorter.add("Bob");
	sorter.add("Amy");
	sorter.add("Carl");
	for (String s : sorter) System.out.println(s); //Amy, Bob, Carl
	```

+ 排序是用树结构完成的(当前实现使用的是红黑树(red-black tree))
	+ 每次将一个元素添加到树中时，都被放置在正确的排序位置上。因此，迭代器总是以排好序的顺序访问每个元素。

+ 将一个元素添加到树中要比添加到散列表中慢，但是，与将元素添加到数组或链表的正确位置上相比还是快很多的。
	+ 将一个元素添加到TreeSet中要比添加到HashSet中慢，不过，TreeSet可以自动地对元素进行排序。

```Java
API java.util.TreeSet<E> 1.2
	
	TreeSet()
	//构造一个空数集
	TreeSet(Collection<? extends E) elements)
	//构造一个数集，并将集合中的所有元素添加到树集中
```

### 对象的比较

+ TreeSet，在默认情况时，数集假定插入的元素实现了Comparable接口。这个接口定义了一个方法：

	```Java
	public interface ComParable<T> {
		int compareTo(T other);
	}
	//关键是返回的符号
	```

+ 有些标准的Java平台类实现了Comparable接口，例如，String类。这个类的compareTo方法依据字典序(有时称为词典序)对字符串进行比较。

+ 如果要插入自定义的对象，就必须通过实现Comparable接口自定义排序顺序。在Object类中，没有提供任何compareTo接口的默认实现。

	```Java
	class Item implements Comparable<Item> {
		public int compareTo(Item other) {
			return partNumber - other.partNumber;
		}
		//对两个正整数进行比较
		...
	}
	//只有整数在一个足够小的范围内，才可以使用这个技巧。如果x是一个较大的正整数，y是一个较大的负整数，x-y有可能会溢出。
	```

+ 使用Comparable接口定义排列排序显然有其局限性。
	+ 对于给定的类，只能够实现这个接口一次。如果在一个集合中需要按照部件编号进行排序，在另一个集合中却要按照描述信息进行排序。
	+ 如果需要对一个类的对象进行排序，而这个类的创建者又没有费心实现Comparable接口。

+ 在这种情况下，可以通过将Comparator对象传递给TreeSet构造器来告诉树集使用不同的比较方法。Comparator接口声明了一个带有两个显示参数的compare方法：

	```Java
	public interface Comparator<T> {
		int compare(T a, T b);
	}

	//按照描述信息排序
	class ItemComparator implements Comparator<Item> {
		public int compare(Item a, Item b) {
			String descrA = a.getDescription();
			String descrB = b.getDescription();
			return descrA.compareTo(descrB);
		}
	}

	//然后将这个类的对象传递给树集的构造器
	ItemComparator comp = new ItemComparator();
	SortedSet<Item> sortByDescription = new TreeSet<>(comp);

	//如果构造了一颗比较器的树吗，就可以在需要比较两个元素时使用这个对象。
	//这个比较器没有任何数据。它只是比较方法的有器。有时将这种对象称为函数对象。
	//函数对象通常" 动态 "定义，即定义为匿名内部类的实例
	SortedSet<Item> sortByDescription = new TreeSet<>(new Comparator<Item>()) {
		public int compare(Item a, Item b) {
			String descrA = a.getDescription();
			String descrB = b.getDescription();
			return descrA.compareTo(descrB);
		}
	}
	```

+ 实际上，Comparator<T>接口声明了两个方法：compare和equals。当然每个类都有一个equals方法；因此，为这个接口声明再添加一个equals方法似乎没有太大好处。API文档解释说，不需要覆盖equals方法，但这样做可能在可能会在某些情况下提高性能。

+ 树的排序必须是全序。也就是说任意两个元素之间是可比的。并且只有两个元素相等时才为0。

+ Java SE 6起，TreeSet类实现了NavigableSet接口。这几个接口增加了几个便于定位元素以及反向遍历的方法。

```Java
//创建了两个Item对象的树集。
//第一个按照部件编号排序，这是Item对象的默认顺序。
//第二个通过使用一个定制的比较器来按照描述信息排序。
// treeSet/TreeSetTest.java

package treeSet;

public class TreeSetTest {
	public static void main(String[] args) {
		SortedSet<Item> parts = new TreeSet<>();
		parts.add(new Item("Toaster", 1234));
		parts.add(new Item("Widget", 4562));
		parts.add(new Item("Modem", 9912));
		System.out.println(parts);

		SortedSet<Item> sortByDescription = new TreeSet<>(new Comparetor<Item> {
			public int compare(Item a, Item b) {
				String descrA = a.getDescription();
				String descrB = b.getDescription();
				return descrA.compareTo(descrB);
			}
		});

		SortByDescription.addAll(parts);
		System.out.println(sortByDescription);
	}
}

//treeSet/Item.java

package treeSet;

import java.util.*;

public class Item implements Comparable<Item> {
	private String description;
	private int partNumber;

	public Item(String aDescription, int aPartNumber) {
		description = aDescription;
		partNumber = aPartNumber;
	}

	public String getDescription() {
		return description();
	}

	public String toString() {
		return "[description=" + description + ", partNumber=" + partNumber + "]";
	}

	public boolean equals(Object otherObject) {
		if(this == otherObject) return true;
		if(otherObject == null) return false;
		if(getClass() != otherObject.getClass()) return false;
		Item other = (Item) otherObject;
		return Object.equals(description, other.description) && partNumber == other.partNumber;
	}

	public int hashCode() {
		return Objects.hash(description, partNumber);
	}

	public int compareTo(Item other) {
		return Integer.compare(partNumber, other.partNumber);
	}
}
```

```Java
API java.lang.Comparable<T> 1.2
	int compareTo(T other)

	java.util.Comparator 1.2
	int compare(T a, T b)

	java.util.SortedSet<E> 1.2
	Comparator<? super E> comparator()
	//返回用于对元素进行排序的比较器。如果元素用Comparable接口的compareTo方法进行比较则返回null
	E first()
	E last()
	//返回有序集中的最小或最大元素

	java.util.NavigableSet<E> 6
	//返回大于value的最小元素或小于value的最大元素，如果没有这样的元素则返回null
	E ceiling(E value)
	E floor(E value)
	//返回大于等于value的最小元素或小于等于value的最大元素，如果没有这样的元素则返回null

	E pollFirst()
	E pollLast()
	//删除并返回这个集中的最大元素或最小元素，这个集为空时返回null。
	Iterator<E> descendingIterator()
	//返回一个按照递减顺序遍历集中元素的迭代器。

	java.util.TreeSet<E> 1.2
	TreeSet()
	//构造一个树集，并使用指定的比较器对其中的元素进行排序。
	TreeSet(Comparator<? super E> c)
	//构造一个树集，并使用指定的比较器对其中的元素进行排序
	TreeSet(SortedSet<? extends E> elements)
	//构造一个树集，将有序集中的所有元素添加到这个树集中，并使用与给定集相同的元素比较器。
```

### 对列与双端对列

+ 对列可以让人们有效地在尾部添加一个元素， 在头部删除一个元素。
+ 有两个端头的对列，即双端对列，可以让人们有效地在头部和尾部同时添加或删除元素。
+ 不支持在对列中间添加元素。
+ Java SE 6中引入了Deque接口，并由ArrayDeque和LinkedList类实现。这两个类都提供了双端对列，而且在必要时可以增加对列的长度。

```Java
API java.util.Quene<E> 5.0
	
	boolean add(E element)
	boolean offer(E element)
	//如果对列没有满，将给定的元素添加到这个双端对列的尾部并返回true。如果对列满了，第一个方法将抛出一个IllegalStateException，而第二个方法返回false。

	E remove()
	E poll()
	//假如对列不空，删除并返回这个对列头部的元素。如果对列是空的，第一个方法抛出NoSuchElementException，而第二个方法返回null。

	E element()
	E peek()
	//如果对列不空，返回这个对列头部的元素，但不删除。如果对列空，第一个方法将抛出一个NoSuchElementException，而第二个方法返回null

	java.util.Deque<E> 6
	void addFirst(E element)
	void addLast(E element)
	boolean offerFirst(E element)
	boolean offerLast(E element)
	//将给定的对象添加到双端对列的头部或尾部。如果对列满了，前面两个方法将抛出一个IllegalStageException，而后面两个方法返回false

	E removeFirst()
	E removeLast()
	E pollFirst()
	E pollLast()
	//如果对列不空，删除并返回对列头部的元素。

	E getFirst()
	E getLast()
	E peekFirst()
	E peekLast()
	//如果对列非空，返回对列头部的元素，但不删除。
```

### 优先级对列

+ 优先级对列中的元素可以按照任意的顺序插入，却总是按照排序的顺序进行检索。
	+ 也就是说无论何时调用remove方法，总会获得当前优先级对列中最小的元素。
	+ 然而，优先级对列并没有对所有元素进行排序。
	+ 如果用迭代的方式处理这些元素，并不需要对它们进行排序。

+ 优先级对列使用一个优雅且高效的数据结构，称为堆(heap)。
	+ 堆是一个可以自我调整的二叉树，对树执行添加(add)和删除(remove)操作，可以让最小的元素移动到根，而不必花费时间对元素进行排序。
	+ 与TreeSet一样，一个优先级对列即可以保存实现了Comparable接口的类对象，也可以保存在构造器中提供比较器的对象。

+ 使用优先级对列的典型示例是任务调度。
	+ 每一个任务有一个优先级，任务以随机顺序添加到对列中。每当启动一个新的任务时，都将优先级最高的任务从对列中删除(由于习惯上，将1设置设置为“最高”优先级，所以会将最小的元素删除。)

```Java
//显示一个正在运行的优先级对列。与TreeSet中的迭代不同，这里的迭代并不是按照元素的排列顺序访问的。而删除却总是删除剩余元素中优先级数最小的那个元素。
//priorityQueue/PriorityQueueTest.java

package priorityQueue;

public static void main(String[] args) {
	PriorityQueue<GregorianCalendar> pq = new PriorityQueue<>();
	pq.add(new GregorianCalendar(1906, Calendar.DECEMBER, 9));
	pq.add(new GregorianCalendar(1815, Calendar.DECEMBER, 10));
	pq.add(new GregorianCalendar(1903, Calendar.DECEMBER, 3));
	pq.add(new GregorianCalendar(1910, Calendar.DECEMBER, 22));

	System.out.println("Iterating over elements...");
	for(GregorianCalendar date : pq)
		System.out.println(date.get(Calendar.YEAR));
	System.out.println("Removing elements...");
	while(!pq.isEmpty())
		System.out.println(pq.remove().get(Calendar.YEAR));
}
```

```Java
API java.util.PriorityQueue 5.0
	
	PriorityQueue()
	PriorityQueue(int initialCapacity)
	//构造一个用于存放Comparable对象的优先级对列。

	PriorityQueue(int initialCapacity, Comparator<? super E> c)
	//构造一个优先级对列，并用指定的比较器对元素进行排序
```

### 映射表

+ Java类库为映射表提供两个通用的实现：HashMap和TreeMap。这两个类都实现了Map接口。
	+ 散列映射表对键进行散列，树映射表用键的整体顺序对元素排序，并将其组织成搜索树。
	+ 散列或比较函数只能作用于键。与键关联的值不能进行散列或比较。
	+ 与集一样，散列稍微快一点，如果不需要按照排列顺序访问键，就最好选择散列。

		```Java
		Map<String, Employee> staff = new HashMap<>(); // HashMap implements Map
		Employee harry = new Employee("Harry Hacker");
		staff.put("987-98-9996", harry);
		...
		//每当往映射表中添加对象时，必须同时提供一个键。
		//要想检索一个对象，必须提供一个键。

		String s = "987-98-9996";
		e = staff.get(s); //gets harry
		//如果在映射表中没有与给定键对应的信息，get将返回null
		```

+ 键必须是唯一的。不能对用一个键存放两个值。如果对同一个键调用两次put方法，第二个值就会取代第一个值。实际上，put将返回用这个键参数存储的上一个值。

+ 集合框架并没有将映射表本身视为一个集合(其他的数据结构框架则将映射表视为对(pairs)的集合，或者视为用键作为索引的值的集合)

+ 可以获得映射表的视图，这是一组实现了Collection接口对象，或者它的子接口的视图。
	+ 有3个视图，它们分别是：键集，值集合(不是集)和键/值对集。
	+ 键与键/值对形成了一个集，这是因为在映射表中一个键只能有一个副本。下列方法将返回这3个视图(条目集的元素时静态内部类Map.Entry的对象)

		```Java
		Set<K> keySet()
		// keySet既不是HashSet，也不是TreeSet，而是实现了Set接口的某个其他类的对象。
		//Set接口扩展了Collection接口。因此，可以与使用任何集合一样使用keySet

		Collection<k> values()
		Set<Map.Entry<K, V>> entrySet()


		//可以枚举映射表中的所有键
		Set<String> keys = map.keySet();
		for(String key : keys) {
			do something with key
		}

		//同时查看键与值，就可以通过枚举各个条目(entries)查看，以避免对值进行查找。
		for (Map.Entry<String, Employee> entry : staff.entrySet()) {
			String key = entry.getKey();
			Employee value = entry.getValue();
			do something with key value
		}

		//如果调用迭代器的remove方法，实际上就从映射表中删除了键以及对应的值。
		//不能将元素添加到键集的视图中。
		//如果只添加键而不添加值时毫无意义的。如果试图调用add方法，将会抛出一个UNsupportedOperationException异常。
		//条目集视图也有同样的限制，不过，从概念上讲，添加新的键/值是有意义的。
		```

```Java
//map/MapTest.java

package map;

import java.util.*;

public class MapTest {
	public static void main(String[] args) {
		Map<String, Employee> staff = new HashMap<>();
		staff.put("144-25-5464", new Employee("Amy Lee"));
		staff.put("567-24-2546", new Employee("Harry Hacker"));
		staff.put("157-62-7935", new Employee("Gary Cooper"));
		staff.put("456-62-5527", new Employee("Francesca Cruz"));

		// print all entries
		System.out.println(staff);

		// print all entries
		System.out.println(staff);

		// remove an entry
		staff.remove("567-24-2546");

		//replace an entry
		staff.put("456-62-5527", new Employee("Francesca Miller"));

		// look up a value
		System.out.println(staff.get("157-62-7935"));

		// iterate through all entries
		for (Map.Entry<String, Employee> entry : staff.entrySet()) {
			String key = entry.getKey();
			String value = entry.getValue();
			System.out.println("key=" + key + ", value=" + value);
		}
	}
}
```

```Java
API java.util.Map<K, V> 1.2

	V get(Object key)
	//获取与键对应的值；返回与键对应的对象，如果在映射表中没有这个对象则返回null。
	//键可以为null

	V put(K key, V value)
	//将键与对应的值关系插入到映射表中。
	//如果这个键已经存在，新的对象将取代与这个键对应的旧对象。
	//这个方法将返回键对应的旧值。如果这个键以前没有出现过则返回null。
	//键可以为null，但值不能为null

	void putAll(Map<? extends K, ? extends V> entries)
	boolean containsKey(Object key)
	boolean containsValue(Object value)
	Set<Map.Entry<K, V>> entrySet()
	//返回Map.Entry对象的集视图，即映射表中的键/值对。
	//可以从这个集中删除元素，同时也从映射表中删除了它们。
	//但是，不能添加任何元素

	Set<K> keySet()
	//返回映射表中所有键的集视图。
	//可以从这个集中删除元素，同时也从映射表中删除了它们。
	//但是，不能添加任何元素

	Collection<V> values()
	//返回映射表中所有值的集合视图。可以从这个集中删除元素，同时也从映射表中删除了它们。但是，不能添加任何元素

	java.util.Map.Entry<K, V> 1.2

	K getKey()
	V getValue()
	
	V setValue(V newValue)
	// 设置在映射表中与新值对应的值，并返回旧值。

	java.util.HashMap<K, V> 1.2
	HashMap()
	HashMap(int initialCapacity)
	HashMap(int initialCapacity, float loadFactor)
	//用给定的容量和装填因子构造一个空散列表映射表(装填因子是一个0.0~1.0之间的数值。这个数值决定散列表填充的百分比。一旦到了这个比例，就要将其再散列到更大的表中)。
	//默认装填因子是0.75

	java.util.TreeMap<K, V> 1.2
	TreeMap(Comparator<? super K> c)
	//构造一个树映射表，并使用一个指定的比较器对键进行排序

	TreeMap(Map<? extends K, ? extends V> entries)
	//构造一个树映射表，并将某个映射表中的所有条目添加到树映射表中

	TreeMap(SortedMap<? extends K, ? extends V> entries)
	//构造一个树映射表并将某个有序映射表中的所有条目添加到树映射表中，并使用与给定的有序映射表相同的比较器。

	java.util.SortedMap<K, V> 1.2
	Comparator<? super K> comparator()
	//返回对键进行排序的比较器。如果键是用Comparable接口的compareTo方法进行比较的，返回null

	K firstKey()
	K lastKey()
	//返回映射表中最小元素和最大元素
```

### 专用集与映射表类

+ 弱散列映射表(WeakHashMap)

+ 链接散列集和链接映射表

+ 枚举集与映射表

+ 标识散列映射表


```Java
API java.util.WeakHashMap<K, V> 1.2

```

## 集合框架

+ 框架(framework)是一个类的集，它奠定了创建高级功能的基础。框架包含很多超类，这些超类拥有非常有用的功能，策略和机制。框架使用者创建的子类可以扩展超类的功能，而不必重新创建这些基本的机制。

+ Java集合类库构成了集合类的框架。它为集合的实现者定义了大量的接口和抽象类，并对其中的某些机制给予了描述。

```graphBT
    Co[Collection] --> It[Iterable]
    L[List] --> Co
    S[Set] --> Co
    Q[Queue] --> Co
    So[SortedSet] --> S
    Na[NavigableSet] --> So
    D[Deque] --> Q
   
    Sor[SortedMap] --> M[Map]
    Nav[NavigableMap] --> Sor
```

+ 集合有两个基本的接口Collection和Map。

	```Java
	//向集合中插入元素：
	boolean add(E element)
	//映射表保存的是键/值对
	V put(K key, V value)

	//从集合中读取某个元素，就需要使用迭代器访问它们。
	//可以用get方法从映射表读取值
	V get(K key)
	```

+ List是一个有序集合(ordered collection)。
	+ 元素可以添加到容器中某个特定的位置。
	+ 将对象放置在某个位置上采用两种方式：使用整数索引或使用列表迭代器。

		```Java
		//List接口定义了几个用于随机访问的方法：
		void add(int index, E element)
		E get(int index)
		void remove(int index)
		```

+ List是一个有序集合(ordered collection)。
	+ 元素可以添加到容器中某个特定的位置。
	+ 将对象放置在某个位置上采用两种方式：使用整数索引或使用列表迭代器。

		```Java
		//List接口定义了几个用于随机访问的方法：
		void add(int index, E element)
		E get(int index)
		void remove(int index)
		```

	+ List接口在提供这些随机访问方法时，并不管它们对某种特定的实现是否高效。

	+ 为了避免执行成本较高的随机访问操作，Java SE 1.4 引入了一个标记接口RandomAccess。
		+ 这个接口没有任何方法，但可以用来检测一个特定的集合是否支持高效的随机访问：

			```Java
			if (c instanceof RandomAccess) {
				use random access algorithm
			} else {
				use sequential access algorithm
			}
			```

		+ ArrayList类和Vector类都实现了RandomAccess接口。

		```Java
		//ListIterator接口定义了一个方法，用于将一个元素添加到迭代器所处位置的前面：
		void add(E element)
		```

+ Set接口与Collection接口是一样的，只是其方法的行为有着更加严谨的定义。
	+ 集的add方法拒绝添加重复的元素。
	+ 集的equals方法定义两个集相等的条件是它们包含相同的元素但顺序不比相同。
	+ hashCode方法定义应该保证具有相同元素的集将会得到相同的散列码。
	+ 既然方法签名是相同的，为什么还要建立一个独立的接口呢？
		+ 从概念上讲，并不是所有集合都是集。建立Set接口后，可以让程序员编写仅接受集的方法。

+ SortedSet和SortedNMap接口暴露了用于排序的比较器对象，并且定义的方法可以获得集合的子集视图。

+ Java SE 6引入了接口NavigableSet和NavigableMap，其中包含了几个用于在有序集和映射集中查找和遍历的方法(从理论上讲，这几个方法已经包含在SortedSet和SortedMap的接口中)。
	+ TreeSet和TreeMap类实现了这几个接口。

+ 集合接口有大量的方法，这些方法可以通过更基本的方法加以实现。抽象类提供了许多这样的例行实现：

	```Java
	AbstractCollection
	AbstractList
	AbstractSequentialList
	AbstractSet
	AbstractQueue
	AbstractMap
	//扩展上面某个类实现自己的集合类。

	具体实现：
	LinkedList
	ArrayList
	ArrayDeque
	HashSet
	TreeSet
	PriorityQueue
	HashMap
	TreeMap

	//Java第一版“遗留”下来的容器类，在集合框架出现就有了：
	Vector
	Stack
	Hashtable
	Properties
	//这些类已经被集成到集合框架中
	```

### 视图与包装器

+ 通过视图(views)可以获得其他的实现了集合接口和映射表接口的对象。映射表类的keySet方法就是一个示例。
	+ 初看起来，好像这个方法创建了一个新集，并将映射表中的所有键都填进去，然后返回这个集。
	+ 但是，情况并非如此，取而代之的是：keySet方法返回一个实现Set接口的类对象，这个类的方法对原映射表进行操作。这种集合称为视图。

+ 视图技术在集框架中有许多非常有用的应用。

	+ 轻量级集包装器
		+ Array类的静态方法asList将返回一个包装了普通Java数组的List包装器。

			```Java
			//这个方法可以将数组传递给一起期望得到列表或集合变元的方法。
			Card[] cardDeck = new Card[52];
			...
			List<Card> cardList = Arrays.asList(cardDeck);
			
			//返回的对象不是ArrayList。它是一个视图对象，带有访问底层数组的get和set方法。
			//改变数组的大小的所有方法(例如，与迭代器相关的add和remove方法)都会抛出一个Unsupported OperationException异常
			```

		+ 从Java SE 5.0开始，asList方法声明为一个具有可变数量参数的方法。

			```Java
			//除了可以传递一个数组之外，还可以将 各个元素直接传递给这个方法。
			List<String> names = Arrays.asList("Amy", "Bob", "Carl");
			```

		```Java
		Collections.nCopies(n, anObject)
		//将返回一个实现了List接口的不可修改的对象，并给人一种包含n个元素，灭个元素都像是一个anObject的错觉。

		//创建一个包含100个字符串的List，每个串都被设置为"DEFAULT":
		List<String> setting = Collections.nCopies(100, "DEFAULT");
		//由于字符串对象只存储了一次，所以付出的存储代价很小。
		```

		+ Collections类包含很多实用方法，这些方法的参数和返回值都是集合。不要将它与Collection接口混淆起来。

			```Java
			Collections.singleton(anObject)
			//则将返回一个视图对象。这个对象实现了Set接口(与产生List的ncopies方法不同)
			//返回的对象实现了一个不可修改的单元素集，而不需要付出建立数据结构的开销。
			//singletonList方法于singletonMap方法类似
			```

	+ 子范围

		+ 可以为很多集合建立子范围(subrange)视图。

			```Java
			//假设有一个列表staff，想从中取出第10个~第19个元素 。可以使用subList方法来获得一个列表的自范围视图：
			List group2 = staff.subList(10, 20);

			//第一个索引包含在内，第二个索引则不包含在内。这与String类的substring操作中的参数情况相同。

			//可以将如何操作应用于子范围，并且能够自动地反映整个列表的情况。
			group2.clear(); // staff reduction(还原)
			```

		+ 对于有序集和映射表，可以使用排序顺序而不是元素位置建立子范围。

			```Java
			//SortedSet接口声明3个方法：
			SortedSet<E> subSet(E from, E to)
			SortedSet<E> headSet(E to)
			SortedSet<E> tailSet(E from)
			//这些方法将返回大于等于from且小于to的所有元素子集。

			//有序映射表也有类似的方法：
			SortedMap<K, V> subMap(K from, K to)
			SortedMap<K, V> headMap(K to)
			SortedMap<K, V> tailMap(K from)
			//返回映射表视图，该映射表包含键落在指定范围内的所有元素

			//Java SE 6引入的NavigableSet接口赋予子范围操作更多的控制能力。可以指定是否包括边界：
			NavigableSet<E> subSet(E from, boolean fromInclusive, E to, boolean toInclusive)
			NavigableSet<E> headSet(E to, boolean toInclusive)
			NavigableSet<E> tailSet(E from, boolean fromInclusive)
			```

	+ 不可修改的视图

		+ Collections还有几个方法，用于产生集合的不可修改视图(unmodifiable views)。
			+ 这些视图对现有集合增加了一个运行时的检查。如果发现试图对集合进行修改，就抛出一个异常，同时这个集合将保持未修改的状态。

			```Java
			//使用下面6种方法获得不可修改视图：
			Collections.unmodifiableCollection
			Collections.unmodifiableList
			Collections.unmodifiableSet
			Collections.unmodifiableSortedSet
			Collections.unmodifiableMap
			Collections.unmodifiableSortedMap
			```

		+ 每个方法都定义于一个接口。例如：Collections.unmodifiableList与ArrayList，LinkedList或者任何实现了List接口的其他类一起协同工作。

			```Java
			//假设想要查看某部分代码，但又不触及某个集合的内容，就可以进行下列操作：
			List<String> staff = new LinkedList();
			...
			lookAt(Collections.unmodifiableList(staff));

			// Collections.unmodifiableList方法将返回一个实现List接口的类对象。其访问器方法将staff集合中获取值。
			// lookAt方法可以调用List接口中的所有方法，而不只是访问器。
			//但是所有的更改器方法(如：add)已经被重新定义为抛出一个UnsupportedOperationException异常，而不是将调用传递给底层集合
			```

		+ 不可修改视图并不是集合本身不可修改。仍然可以通过集合的原始引用(在这里是staff)对集合进行修改。并且仍然可以让集合的元素调用更改器方法。

		+ 由于视图只是包装了接口而不是实际的集合对象，所以只能访问接口中定义的方法。
			+ 例如：LinkedList类有一些非常方便的方法，addFirst和addLast，它们都不是List接口的方法，不能通过不可修改视图进行访问。

		+ unmodifiableCollection方法(与本节稍后讨论的synchronizedCollection和checkedCollection方法一样)将返回一个集合，它的equals方法不调用底层集合的equals方法。相反，它继承了Object类的equals方法，这个方法只是检测两个对象是否同一个对象。

			+ 如果将集或列表转换成集合，就再也无法检测其内容是否相同了。视图就是以这种方法运行的，因为内容是否相等的检测在分层结构的这一层上没有定义妥当。视图将以同样的方式处理hashCode方法。

			+ 然而，unmodifiableSet类和unmodifiableList类却使用底层集合的equals方法和hashCode方法。

	+ 同步视图

		+ 如果有多个线程访问集合，就必须确保集不会被意外地破坏。
			+ 例如：如果一个线程视图将元素添加到散列表中，同时另一个线程正在对散列表进行再散列，其结果将是灾难性的。
			+ 类库的设计者使用视图机制来确保常规集合的线程安全，而不是实现线程安全的集合类。例如，Collection类的静态synchronizedMap方法可以将任何一个映射表转换成具有同步访问方法的Map：

			```Java
			Map<String, Employee> map = Collections.synchronizedMap(new HashMap<String, Employee>());

			//现在可以由多线程访问map对象了。像get和put这类方法都是串行操作的，即在另一个线程调用另一个方法之前，刚才的方法调用必须彻底完成。
			```

	+ 检查视图

		+ Java SE 5.0增加了一组"检查"视图，用来对泛型类型发生问题时提供调试支持。

			```Java
			//实际上将错误类型的元素私自带到泛型集合中的问题极有可能发生。
			ArrayList<String> strings = new ArrayList<String>();
			ArrayList rawList = strings; // get warning only, not an error, for compatibility with legacy code
			rawLists.add(new Date()); // now strings contains a Date object!

			//这个错误的add命令在运行时加查不到。相反，只是在稍后的另一部分代码中调用get方法，并将结果转化为String时，这个类才会抛出异常。

			//检查视图可以探测到这类问题。定义了一个安全列表：
			List<String> safeStrings = Collections.checkedList(strings, String.class);

			//视图的add方法将检测插入的对象是否属于给定的类。如果不属于给定的类，就立即抛出一个ClassCastException。
			ArrayList rawList = safeStrings;
			rawList.add(new Date()); // checked list throws a ClassCastException
			```

		+ 被检测视图受限于虚拟机可以运行的运行时检查。
			+ 例如：对于ArrayList<Pair<String>>，由于虚拟机有一个单独的"原始"Pair类，所以，无法阻止插入Pair<Date>

	+ 关于可选操作的说明

		+ 通常，视图有一些局限性，即可能只可以读，无法改变大小，只支持删除而不支持插入，这些与映射表的键视图情况相同。如果试图进行不恰当的操作，受限制的视图就会抛出一个UnsupportedOperationException

		+ 在集合和迭代器接口的API文档中，许多方法描述为“可选操作”。这看起来与接口的概念有所抵触。毕竟，接口的设计目的难道不是负责给出一个类必须实现的方法吗？

		+ 一个更好的解决方案是为每个只读视图和不能改变集合大小的视图建立各自独立的两个接口。不过，这将会使接口的数量成倍增长，这让类库设计者无法接受。

```Java
API java.util.Collections 1.2

	static <E> Collection unmodifiableCollection(Collection<E> c)
	static <E> List unmodifiableList(List<E> c)
	static <E> Set unmodifiableSet(Set<E> c)
	static <E> SortedSet unmodifiableSortedSet(SortedSet<E> c)
	static <K, V> Map unmodifiableMap(Map<K, V> c)
	static <K, V> SortedMap unmodifiableSortedMap(SortedMap<K, V> c)
	// 构造一个集合视图，其更改器方法将抛出一个UnsupportedOperationException

	static <E> Collection<E> synchronizedCollection(Collection<E> c)
	static <E> List synchronizedList(List<E> c)
	static <E> Set synchronizedSet(Set<E> c)
	static <E> SortedSet synchronizedSortedSet(SortedSet<E> c)
	static <K, V> Map<K, V> synchronizedMap(Map<K, V> c)
	static <K, V> SortedMap<K, V> synchronizedSortedMap(SortedMap<K, V> c)
	// 构造一个集合视图，其方法都是同步的

	static <E> Collection checkedCollection(Collection<E> c, Class<E> elementType)
	static <E> List checkedList(List<E> c, Class<E> elementType)
	static <E> Set checkedSet(Set<E> c, Class<E> elementType)
	static <E> SortedSet checkedSortedSet(SortedSet<E> c, Class<E> elementType)
	static <K, V> Map checkedMap(Map<K, V> c, Class<K> keyType, Class<V> valueType)
	static <K, V> SortedMap checkedSortedMap(SortedMap<K, V> c, Class<K> keyType, Class<K> valueType)
	// 构造一个集合视图。如果插入一个错误类型的元素，将抛出一个ClassCastException

	static <E> List<E> nCopies(int n, E value)
	static <E> Set<E> singleton(E value)
	//构造一个对象视图，它即可以作为一个拥有n个相同元素的不可修改列表，又可以作为一个拥有单个元素的集

	java.util.Arrays 1.2

	static <E> List<E> asList(E... array)
	//返回一个数组元素的列表视图。这个数组时可修改的，但其大小不可变

	java.util.ListM<E> 1.2

	List<E> subList(int firstIncluded, int firstExcluded)
	//返回给定位置范围内的所有元素的列表视图

	java.util.SortedSet<E> 1.2

	SortedSet<E> subSet(E firstIncluded, E firstExcluded)
	SortedSet<E> headSet(E firstExcluded)
	SortedSet<E> tailSet(E firstIncluded)
	//返回给定范围内的元素视图

	java.util.NavigableSet<E> 6
	NavigableSet<E> subSet(E from, boolean fromIncluded, E to, boolean toIncluded)
	NavigableSet<E> headSet(E to, boolean toIncluded)
	NavigableSet<E> tailSet(E from, boolean fromIncluded)
	//返回给定范围内的元素视图。boolean标志决定视图是否包含边界

	java.util.SortedMap<K, V> 1.2
	SortedMap<K, V> subMap(K firstIncluded, K firstExcluded)
	SortedMap<K, V> headMap(K firstExcluded)
	SortedMap<K, V> tailMap(K firstIncluded)
	//返回在给定范围内的键条目的映射表视图。

	java.util.NavigableMap<K, V> 6
	NavigableMap<K, V> subMap(K from, boolean fromIncluded, K to, boolean toIncluded)
	NavigableMap<K, V> headMap(K from, boolean fromIncluded)
	NavigableMap<K, V> tailMap(K to, boolean toIncluded)
	//返回在给定 范围内的键条目的映射表视图。boolean标志决定视图是否包含边界。
```

### 批操作

+ 到现在为止，列举的绝大多数示例都采用迭代器遍历集合，一个遍历一次元素。然而，可以使用类库中的批操作(bulk operation) 避免频繁地使用迭代器。

	```Java
	//假设希望找出两个集的交(intersection)，即两个集中共有的元素。

	//建立新集，存放结果
	Set<String> result = new HashSet<>(a);
	//这里利用了一个事实：每个集合中有一个构造器，其参数是保存初始值的另一个集合。

	result.retainAll(b);
	//result中保存了即在a中出现，也在b中出现的元素。这时已经构成了交集，没有使用循环。
	```

+ 将批操作应用于视图。

	```Java
	//假设有映射表，将员工的ID映射为员工对象，并且建立了一个将要结束聘用期的所有员工的ID集

	Map<String, Employee> staffMap = ...;
	Set<String> terminatedIDs = ... ;

	//直接建立一个键集，并删除终止聘用关系的所有员工的ID即可
	staffMap.keySet().removeAll(terminatedIDs);

	//由于键集是映射表的一个视图，所以，键与对应的员工名将会从映射表中自动地删除。
	```

+ 通过使用一个子范围视图，可以将批操作限制于子列表和子集的操作上。

	```Java
	//假设希望将一个列表的前10个元素添加到另一个容器中，可以建立一个子列表用于选择前10个元素。
	relocated.addAll(staff.subList(0, 10));

	//这个子范围也可以成为更改操作的对象
	staff.subList(0, 10).clear();
	```

### 集合与数组之间的转换

+ 由于Java平台API中大部分内容都是在集合框架创建之前设计的，所以，有时候需要在传统的数组与现代的集合之前进行转换。

	```Java
	//数组转换成集合 Arrays.asList()
	String[] values = ...;
	HashSet<String> staff = new HashSet<>(Arrays.asList(values));

	// 将集合转换成为数组。toArray方法
	Object[] values = staff.toArray();

	//但是这样做的结果是产生一个对象数组。即使知道集合中欧包含一个特定类型的对象，也不能使用类型转换：
	String[] values = (String[]) staff.toArray(); //Error!
	//由toArray方法返回的数组时一个Object[]数组，无法改变其类型。
	//相反，必须使用另一个toArray方法，并将其设计为所希望的元素类型且长度为0的数组。随后返回的数组将与所创建的数组一样：
	String[] values = staff.toArray(new String[0]);

	//可以指定大小的数组：
	staff.toArray(new String[staff.size()]);
	//在这种情况下，没有创建任何新数组。
 	```

 + 为什么不直接将一个Class对象(例如:String.class) 传递给toArray方法。其原因是这个方法具有“双重职责”，不仅要填充填充已有的数组(如果足够长)，还要创建一个新数组。

## 算法

+ 泛型集合接口有一个很大的优点。即算法只需要实现一次。

	```Java
	//找出数组中最大元素的代码
	if(a.length == 0) throw new NoSuchElementException();
	T largest = a[0];
	for(int i = 1; i < a.length; i++)
		if(largest.compareTo(a[i]) < 0)
			largest = a[i];

	//数组列表中最大元素
	if(v.size() == 0) throw new NoSuchElementException
	T largest = v.get(0);
	for(int i = 1l i < v.size(); i++)
		if(largest.compareTo(v.get(i)) < 0)
			largest = v.get(i);

	//链表，无法高效随机访问，却可以使用迭代器
	if(l.isEmpty()) throw new NoSuchElementException
	Iterator<T> iter = l.iterator();
	T largest = iter.next();
	while (iter.hasNext()) {
		T next = iter.next();
		if(largest.compareTo(next) < 0)
			largest = next;
	}

	static <T extends Comparable> T max(T[] a)
	static <T extends Comparable> T max(ArrayList<T> v)
	static <T extends Comparable> T max(LinkedList<T> l)

	//采用get和set方法进行随机访问要比直接迭代层次高。
	//在计算链表中欧最大元素的过程看到，这项任务不需要进行随机访问
	//直接用迭代器遍历每个元素就可以计算最大元素
	//因此将max方法实现为能够接受任何实现了Collection接口的对象。

	public static <T extends Comparable> T max(Collection<T> c) {
		if(c.isEmpty()) throw new NoSuchElementException
		Iterator<T> iter = c.iterator();
		T largest = iter.next();
		while(iter.hasNext()) {
			T next= iter.next();
			if(largest.comnpareTo(next) < 0)
				largest = next;
		}
		return largest;
	}

	//现在可以使用一个方法计算链表，数组列表或数组中最大元素了
	```

### 排序与混排

+ Collections类中的sort方法可以对实现了List接口的集合进行排序。

	```Java
	List<String> staff = new LinkedList<>();
	fill collection
	Collections.sort(staff);

	//这个方法假定列表元素实现了Comparable接口。
	//如果想采用其他方式对列表进行排序，可以将Comparable对象作为第二个参数传递给sort方法。

	Comparable<Item> itemComparator = new Comparable<Iterm>() {
		public int compare(Item a, Item b) {
			return a.partNumber - b.partNumber;
		}
	}
	Collections.sort(items, itemComparator);
	```

+ 如果将按照降序对列表进行排序，可以使用一种非常方法的静态方法Collections.reverseOrder()。

	```Java
	//这个方法返回一个比较器，比较器返回
	b.compareTo(a)

	Collections.sort(staff, Collections.reverseOrder());
	//这个方法将按照元素类型的compareTo方法给定排序顺序，按照逆序对列表staff进行排序。

	Collections.sort(items, Collections.reverseOrder(itemComparator))
	//将逆置itemComparator的次序
	```

+ 书籍中发现有关数组的排序算法，而且使用的是随机访问方式。但对列表进行随机访问的效率很低。实际上可以使用归并排序对列表进行高效的排序。
	+ Java程序设计语言不一样的实现，它直接将所有元素转入一个是数组，并使用一种归并排序的变体对数组进行排序，然后，再将排序后的序列复制回列表。
	+ 集合类库中使用的归并排序要比快速排序慢一些，快速排序是通用排序算法的传统选择。
		+ 但是，归并排序有一个主要的优点：稳定，即不需要交换相同的元素。(相同的语速按照先前的排序)

	+ 因为集合是不需要实现所有的“可选”方法，因此，所有接受集合参数的方法必须描述什么时候可以安全地将集合传递给算法。
		+ 根据文档说明，列表必须是可以修改的，但不必是可以改变大小的。
			+ 如果列表支持set方法，即使可修改的。
			+ 如果列表支持add和remove方法，则是可改变大小的。

+ Collections类有一个算法shuffle，其功能与排序刚好相反，即随机地混排列表中元素的顺序。

	```Java
	ArrayList<Card> cards = ...;
	Collections.shuffle(cards);

	//如果提供的列表没有实现RandomAccess接口，shuffle方法将元素复制到数组中，然后打乱数组元素的顺序，最后再将打乱顺序后的元素复制回列表。
	```

```Java
//shuffle/ShuffleTest.java

package shuffle;

import java.util.*;

public class ShuffleTest {
	public static void main(String[] args) {
		List<Integer> numbers = new ArrrayList<>();
		for(int i = 1; i <= 49; i++)
			numbers.add(i);
		Collections.shuffle(numbers);
		List<Integer> winningCombination = numbers.subList(0, 6);
		Collections.sort(winningCombination);
		System.out.println(winningCombination);
	}
}
```

```Java
API java.util.Collections 1.2

	static <T extends Comparable<? super T>> void sort(List<T> elements)
	static <T> void sort(List<T> elements, Comparator<? super T> C)
	//使用稳定的排序算法，对列表中的元素进行排序。这个算法的时间复杂度是O(n logn)，其中n为列表的长度

	static void shuffle(List<?> elements)
	static void shuffle(List<?> elements, Random r)
	//随机地打乱列表中的元素。这个算法的时间复杂度是O(n a(n))，n是列表的长度，a(n)是访问元素的平均时间

	static <T> Comparator<T> reverseOrder()
	//返回一个比较器，它用与Comparable接口的compareTo方法规定的顺序的逆序对元素进行排序。

	static <T> Comparator<T> reverseOrder(Comparator<T> comp)
	//返回一个比较器，它用与comp给定的顺序的逆序对元素进行排序
```

### 二分查找

+ 要想在数组中查找一个对象，通常要依次访问数组中的每个元素，直到找到匹配的元素为止。然而，如果数组是有序的，就可以直接查看位于数组中间的元素，看看是否大于要查找的元素。

+ Collections类的binarySearch方法实现了这个算法。
	+ 集合必须是排好序的，否则将返回错误的答案。
	+ 要想查找某个元素，必须提供集合(这个集合要实现List接口)以及要查找的元素。
	+ 如果集合没有采用Comparable接口的compareTo方法进行排序，就还要提供一个比较器对象。

		```Java
		i = Collections.binarySearch(c, element);
		i = Collections.binarySearch(c, element, comparator);

		//如果binarySearch方法返回的数值大于等于0，则表示匹配对象的索引。c.get(i)等于在这个比较顺序下的element
		//如果返回负值，则表示没有匹配的元素。
		//但是可以利用返回值计算应该将element插入到结合的哪个位置，以保持集合的有序性。插入的位置是
		insertionPoint = -i - 1;

		if(i < 0)
			c.add(-i - 1, element);
		```

+ 只有采用随机访问，二分查找才有意义。如果必须利用迭代方式一次次地遍历链表的一半元素来找到中间位置的元素，二分查找就完全失去了优势。
	+ 因此，如果为binarySearch算法提供一个链表，它将自动地变为线性查找。

	+ Java SE 1.3中，没有为有序集合提供专门的接口，以进行高效地随机访问，而binarySearch方法使用的是一种拙劣的策略，即检查列表参数是否扩展了AbstractSequentialList类。
	+ 这个问题在Java SE 1.4中得到解决。现在binarySearch方法检查列表参数是否实现了RandomAccess接口。如果实现了这个接口，这个方法将采用二分查找；否则，将采用线性查找。

```Java
API java.util.Collections 1.2

	static <T extends Comparator<? super T>> int binarySearch(List<T> elements, T key)
	static <T> int binarySearch(List<T> elements, T key, Comparator<? super T> c)
	//从有序列表中搜索一个键，如果元素扩展了AbstractSequentialList类，则采用线性查找，否则将采用二分查找。这个方法的时间复杂度为O(a(n) logn), n是列表的长度，a(n)是访问一个元素的平均时间。
	//这个方法将返回这个键在列表中的索引，如果在列表中不存在这个键将返回负值i。
	//在这种情况下，应该将这个键插入到列表索引-i-1的位置上，以保持列表的有序性。
```

### 简单算法

+ API注释描述了Collections类的一些简单算法

	```Java
	API java.util.Collections 1.2

		static <T extends Comparable<? super T>> T min(Collection<T> elements)
		static <T extends Comparable<? super T>> T max(Collection<T> elements)
		static <T> min(Collection<T> elements, Comparable<? super T> c)
		static <T> max(Collection<T> elements, Comparable<? super T> c)
		// 返回集合中最小的或最大的元素(为清楚起见，参数的边界被简化了)

		static <T> void copy(List<? super T> to, List<T> from)
		//将原列表中的所有元素复制到目标列表的相应位置上。目标列表的长度至少与原列表一样

		static <T> void fill(List<? super T> l, T value)
		//将列表中所有位置设置为相同的值

		static <T> boolean addAll(Collections<? super T> c, T... values) 5.0
		//将所有值添加到集合中。如果集合改变了，则返回true。

		static <T> boolean replaceAll(List<T> l, T oldValue, T newValue) 1.4
		//用newValue取代所有值为oldValue的元素

		static int indexOfSubList(List<?> l, List<?> s) 1.4
		static int lastIndexOfSubList(List<?> l, List<?> s) 1.4
		//返回l中第一个或最后一个等于s子列表的索引。如果l中不存在等于s的子列表，则返回-1。
		//例如l为[s, t, a, r]，s为[t, a, r]，两个方法都将返回索引1

		static void swap(ListM<?> l, int i, int j) 1.4
		//交换给定偏移量的两个元素

		static void reverse(List<?> l)
		//逆置列表中元素的顺序。这个方法复杂度为O(n)，n是列表的长度。

		static void rotate(List<?> l, int d) 1.4
		//旋转列表中的元素，将索引i的条目移动到位置(i + d)%l.size()
		//例如，将列表[t, a, r]旋转移2个位置得到[a, r, t]
		//这个方法的时间复杂度为O(n)，n为列表的长度

		static int frequency(Collection<?> c, Object o) 5.0
		//返回c中与对象o相同的元素个数

		boolean disjoint(Collection<?> cl, Collections<?> c2) 5.0
		//两个集合没有共同的元素，则返回true
	```

### 编写自己的算法

+ 如果编写自己的算法(实际上，是以集合作为参数的任何方法)，应该尽可能地使用接口，而不要使用具体的实现。

	```Java
	void fillMenu(Jmenu menu, Collection<JMenuItem> items) {
		for(JMenuItem item : items)
			menu.add(item);
	}
	//fillMenu接受任意类型的集合
	//现在任何人都可以用ArrayList或LinkedList，甚至用Array.asList包装器包装的数组调用这个方法。
	```

+ 如果编写了一个返回集合的方法，可能还想要一个返回接口，而不是返回类的方法，因为这样做可以在日后改变想法，并用另一个集合重新实现这个方法。

	```Java
	//编写一个返回所有菜单项的方法getAllItems
	List<JMenuItem> getAllItems(JMenu menu) {
		List<JMenuItem> getAllItems(JMenu menu) {
			List<JMenuItem> items = new ArrayList<>();
			for(int i = 0; i < menu.getItemCount(); i++)
				items.add(menu.getItem(i));
			return items;
		}
	}

	//不复制所有的菜单项，而仅仅提供这些菜单项的视图。要做到这一点，只需要返回AbstractList的匿名子类
	List<JMenuItem> getAllItems(final JMenu menu) {
		return new AbstractList<>() {
			public JMenuItem get(int i) {
				return menu.getItem(i);
			}
			public int size() {
			 return menu.getItemCount();
			}
		}
	}
	```

+ 这是一项高级技术。如果使用它，就应该将它支持的那些“可选”操作准确地记录在文档中。在这种情况下，必须提醒调用者返回的对象是一个不可修改的列表。

## 遗留的集合

+ Java程序设计语言自问世以来就存在的集合类：Hashtable类和非常有用的子类Properties，Vector的子类Stack以及BitSet类

### Hashtable类

+ Hashtable类与HashMap类的作用一样，实际上，它们拥有相同的接口。
	+ 与Vector类的方法一样，Hashtable的方法也是同步的。如果对同步性或与遗留代码的兼容性没有任何要求，就应该使用HashMap
	+ 这个类的名字是Hashtable。带有一个小写的t。在Windows操作系统下，如果使用HashTable会看到一个很奇怪的错误信息，这是因为Windows文件系统对大小写不敏感，而Java编译器却对大小写敏感。

### 枚举

+ 遗留集合使用Enumeration接口对元素序列进行遍历。Enumeration接口有两个方法，即hasMoreElements和nextElement。这两个方法于Iterator接口的hasNext方法和next方法十分相似

	```Java
	//Hashtable类的elements方法将产生一个用于描述表中各个枚举值的对象：

	Enumeration<Employee> e = staff.elements();
	while(e.hasMoreElements()) {
		Employee e = e.nextElement();
		...
	}
	```

+ 有时还会遇到遗留的方法，其参数是枚举类型的。静态方法Collections.enumeration将产生一个枚举对象，枚举集合中的元素。

	```Java
	List<InputStream> streams = ...;
	SequenceInputStream in = new SequenceInputStream(Collectons.enumeration(streams));
		// the SequenceInputStream constructor expects an enumeration
	```

+ 在C++中，用迭代器作为参数十分普遍。在Java编程平台中，只有少数程序员沿用这种习惯。传递集合要比传递迭代器更为明智。集合对象的用途更大。
	+ 当接受方需要时，总是可以从集合中获得迭代器，而且，还可以随时地使用集合的所有方法。
	+ 不过，可能会在某些遗留代码中发现枚举接口。

```Java
API java.util.Enumeration<E> 1.0

	boolean hasMoreElements()
	E nextElement()

	java.util.Hashtable<K, V> 1.0

	Enumeration<K> keys()
	//返回一个遍历散列表中键的枚举对象
	Enumeration<V> elements()
	// 返回一个遍历散列表中元素的枚举对象

	java.util.Vector<E> 1.0
	Enumeration<E> elements()
	//返回遍历向量中元素的枚举对象
```

### 属性映射表

+ 属性映射表(property map)是一个类型非常特殊的映射表结构。3个特性：
	+ 键与值都是字符串
	+ 表可以保存一个文件中，也可以从文件中加载
	+ 使用一个默认的辅助表

+ 实现属性映射表的Java平台类称为Properties。属性映射表通常泳衣程序的特殊配置选项。

```Java
API java.util.Propertier 1.0

	Propertier()
	//创建一个空的属性映射表
	Propertier(Propertier defaults)
	// 创建一个带有一组默认值的空的属性映射表
	String getProperty(String key)
	// 获得属性的对于关系；返回与键对应的字符串。如果映射表不存在，返回默认表中与这个键对应的字符串

	String getProperty(String key, String defaultValue)
	//获得在键没有找到时具有的默认值属性；它将返回与键对应的字符串，如果在映射表中不存在，就返回默认的字符串
	void load(InputStream in)
	//从InputStream加载属性映射表
	void store(OutputStream out, String commentString)
	//把属性映射表存储到OutputStream
```

### 栈

+ 从1.0版开始，标准版库中包含了Stack类，其中有大家熟悉的push方法和pop方法。
	> Stack类扩展为Vector类，从理论上角度看，Vector类并不太令人满意，它可以让栈使用不属于栈操作的insert和remove方法，即可以在任何地方进行插入或删除操作，而不仅仅是在栈顶

```Java
API java.util.Stacl<E> 1.0

	E push(E item)
	//将item压入栈并返回item
	E pop()
	//弹出并返回栈顶的item。如果栈为空，请不要使用这个方法。
	E peek()
	//返回栈顶元素，但不弹出。如果栈为空，请不要使用这个方法。
```

### 位集

+ Java平台的BitSet类用于存放一个位序列(它不是数学上的集，称为位向量或位数组更为合适)
	> 如果需要高效地存储位序列(例如，标志)就可以使用位集。由于位集将位包装在字节里，所以，使用位集要比使用Boolean对象的ArrayList更加高效。

+ BitSet类提供了一个便于读取，设置或清除各个位的接口。使用这个接口可以避免屏蔽和其他麻烦的位操作。如果将这些位存储在int或long变量中就必须进行这些繁琐的操作。

	```Java
	//对于一个名为bucketOfBit的BitSet
	bucketIfBits.get(i)
	//如果第i位处于“开”状态，就返回true；否则返回false。
	bucketIfBits.set(i)
	//将第i位置为“开”状态
	bucketIfBits.clear(i)
	//将第i位置为“关”状态
	```

```Java
API java.util.BitSet 1.0

	BitSet(int initialCapacity)
	//创建一个位集
	int length()
	//返回位集的“逻辑长度”，即1加上位集的最高设置位的索引
	boolean get(int bit)
	//获得一个位
	void set(int bit)
	//设置一个位
	void clear(int bit)
	//清除一个位
	void and(BitSet set)
	//这个位集与另一个位集进行逻辑“AND”
	void or(BitSet set)
	void xor(BitSet set)

	void andNot(BitSet set)
	//清除这个位集中对应另一个位集设置的所有位
```

+ “Eratosthenes筛子”基准测试。
	> “Eratosthenes筛子”算法查找素数的实现。主要用于测试位操作。

```Java
package sieve;

import java.util.*;

public class Sieve {
	public static void main(String[] s) {
		int n = 2000000;
		long start = System.currentTimeMillis();
		BitSet b = new BitSet(n + 1);
		int count = 0;
		int i;
		for(i = 2; i <= n; i++)
			b.set(i);
		i = 2;
		while(i * i <= n) {
			if(b.get(i)) {
				count++;
				int k = 2*i;
				while(k <= n) {
					b.clear(k);
					k += i;
				}
			}
			i++;
		}
		while(i <= n) {
			if(b.get(i)) count++;
			i++;
		}
		long end = System.currentTimeMillis();
		System.out.println(count + " primes");
		System.out.println((end - start) + " milliseconds"); 
	}
}
```



