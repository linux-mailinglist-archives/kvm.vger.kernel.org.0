Return-Path: <kvm+bounces-61248-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E090C1228A
	for <lists+kvm@lfdr.de>; Tue, 28 Oct 2025 01:26:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id EA23F4E85D5
	for <lists+kvm@lfdr.de>; Tue, 28 Oct 2025 00:26:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F04E61E1A17;
	Tue, 28 Oct 2025 00:26:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HVHUBUje"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBF63149C41;
	Tue, 28 Oct 2025 00:26:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761611183; cv=none; b=egiuZ88ca1rUQNUhrKzHo8P+IZMGneM8QNe1WnuYQyfNVf7tDOndJnl88EmW+/fnU8WyAgDigHOb6+PBpL+HIjzt1IFfDOaUYj/V9l+/O1VuEKowb3ngAUW6B8RwKfb+JVvcBEbEqvU6sL8oO8x30AbLL57oFkzhZjUFq0lYZzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761611183; c=relaxed/simple;
	bh=03OjAGrl9Ce/K7jq0kNHfmZRLQY0iB8bbCx2CK6fD4s=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=EHFN9J3PaL1Lu2vavaYrpYH2z+v6W3FXkG2RyRkwH80/TwZ5uNtVjvHTAixp55IfIoE9ULgzvRxl6ZiMWiYBeD0upTlNSi3liBgeGY/CciWjoOvlmHfdvHF1yY2zKHRRwGYUEFfB9a2WBLFSomEpocXKyMlCcQT6e6mPME6ZW6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HVHUBUje; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CE4EC4CEF1;
	Tue, 28 Oct 2025 00:26:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761611182;
	bh=03OjAGrl9Ce/K7jq0kNHfmZRLQY0iB8bbCx2CK6fD4s=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=HVHUBUjezRvJcZmKT1mk7OhneauH29p/qrVO4e2mCpCeGowlb7n+7PIoWHCmgPwVp
	 cGWdtpvpmgPv8LCLCDA+/sQBYoVF8rwrHZBJUczjUqqrFJ3YEU94X0MniJ2Zuwlaod
	 uf2xiA/fC7qtULW2v3xM5g7PPCDVdKpuqd4Xx2qE=
Date: Mon, 27 Oct 2025 17:26:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: <ankita@nvidia.com>
Cc: <aniketa@nvidia.com>, <vsethi@nvidia.com>, <jgg@nvidia.com>,
 <mochs@nvidia.com>, <skolothumtho@nvidia.com>, <linmiaohe@huawei.com>,
 <nao.horiguchi@gmail.com>, <david@redhat.com>,
 <lorenzo.stoakes@oracle.com>, <Liam.Howlett@oracle.com>, <vbabka@suse.cz>,
 <rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>,
 <tony.luck@intel.com>, <bp@alien8.de>, <rafael@kernel.org>,
 <guohanjun@huawei.com>, <mchehab@kernel.org>, <lenb@kernel.org>,
 <kevin.tian@intel.com>, <alex@shazbot.org>, <cjia@nvidia.com>,
 <kwankhede@nvidia.com>, <targupta@nvidia.com>, <zhiw@nvidia.com>,
 <dnigam@nvidia.com>, <kjaju@nvidia.com>, <linux-kernel@vger.kernel.org>,
 <linux-mm@kvack.org>, <linux-edac@vger.kernel.org>,
 <Jonathan.Cameron@huawei.com>, <ira.weiny@intel.com>,
 <Smita.KoralahalliChannabasappa@amd.com>, <u.kleine-koenig@baylibre.com>,
 <peterz@infradead.org>, <linux-acpi@vger.kernel.org>, <kvm@vger.kernel.org>
Subject: Re: [PATCH v4 2/3] mm: handle poisoning of pfn without struct pages
Message-Id: <20251027172620.d764b8e0eab34abd427d7945@linux-foundation.org>
In-Reply-To: <20251026141919.2261-3-ankita@nvidia.com>
References: <20251026141919.2261-1-ankita@nvidia.com>
	<20251026141919.2261-3-ankita@nvidia.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sun, 26 Oct 2025 14:19:18 +0000 <ankita@nvidia.com> wrote:

> From: Ankit Agrawal <ankita@nvidia.com>
> 
> Poison (or ECC) errors can be very common on a large size cluster.
> The kernel MM currently does not handle ECC errors / poison on a memory
> region that is not backed by struct pages. If a memory region mapped
> using remap_pfn_range() for example, but not added to the kernel, MM
> will not have associated struct pages. Add a new mechanism to handle
> memory failure on such memory.
> 
> Make kernel MM expose a function to allow modules managing the device
> memory to register the device memory SPA and the address space associated
> it. MM maintains this information as an interval tree. On poison, MM can
> search for the range that the poisoned PFN belong and use the address_space
> to determine the mapping VMA.
> 
> In this implementation, kernel MM follows the following sequence that is
> largely similar to the memory_failure() handler for struct page backed
> memory:
> 1. memory_failure() is triggered on reception of a poison error. An
> absence of struct page is detected and consequently memory_failure_pfn()
> is executed.
> 2. memory_failure_pfn() collects the processes mapped to the PFN.
> 3. memory_failure_pfn() sends SIGBUS to all the processes mapping the
> faulty PFN using kill_procs().
> 
> Note that there is one primary difference versus the handling of the
> poison on struct pages, which is to skip unmapping to the faulty PFN.
> This is done to handle the huge PFNMAP support added recently [1] that
> enables VM_PFNMAP vmas to map at PMD or PUD level. A poison to a PFN
> mapped in such as way would need breaking the PMD/PUD mapping into PTEs
> that will get mirrored into the S2. This can greatly increase the cost
> of table walks and have a major performance impact.
> 
> ...
>
> @@ -2216,6 +2222,136 @@ static void kill_procs_now(struct page *p, unsigned long pfn, int flags,
>  	kill_procs(&tokill, true, pfn, flags);
>  }
>  
> +int register_pfn_address_space(struct pfn_address_space *pfn_space)
> +{
> +	if (!pfn_space)
> +		return -EINVAL;

I suggest this be removed - make register_pfn_address_space(NULL)
illegal and let the punishment be an oops.

> +	scoped_guard(mutex, &pfn_space_lock) {
> +		if (interval_tree_iter_first(&pfn_space_itree,
> +					     pfn_space->node.start,
> +					     pfn_space->node.last))
> +			return -EBUSY;
> +
> +		interval_tree_insert(&pfn_space->node, &pfn_space_itree);
> +	}
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(register_pfn_address_space);
> +
> +void unregister_pfn_address_space(struct pfn_address_space *pfn_space)
> +{
> +	guard(mutex)(&pfn_space_lock);
> +
> +	if (pfn_space &&
> +	    interval_tree_iter_first(&pfn_space_itree,
> +				     pfn_space->node.start,
> +				     pfn_space->node.last))
> +		interval_tree_remove(&pfn_space->node, &pfn_space_itree);
> +}
> +EXPORT_SYMBOL_GPL(unregister_pfn_address_space);
> +
> +static void add_to_kill_pfn(struct task_struct *tsk,
> +			    struct vm_area_struct *vma,
> +			    struct list_head *to_kill,
> +			    unsigned long pfn)
> +{
> +	struct to_kill *tk;
> +
> +	tk = kmalloc(sizeof(*tk), GFP_ATOMIC);
> +	if (!tk)
> +		return;

This is unfortunate.  GFP_ATOMIC is unreliable and we silently behave
as if it worked OK.

> +	/* Check for pgoff not backed by struct page */
> +	tk->addr = vma_address(vma, pfn, 1);
> +	tk->size_shift = PAGE_SHIFT;
> +
> +	if (tk->addr == -EFAULT)
> +		pr_info("Unable to find address %lx in %s\n",
> +			pfn, tsk->comm);
> +
> +	get_task_struct(tsk);
> +	tk->tsk = tsk;
> +	list_add_tail(&tk->nd, to_kill);
> +}
> +
> +/*
> + * Collect processes when the error hit a PFN not backed by struct page.
> + */
> +static void collect_procs_pfn(struct address_space *mapping,
> +			      unsigned long pfn, struct list_head *to_kill)
> +{
> +	struct vm_area_struct *vma;
> +	struct task_struct *tsk;
> +
> +	i_mmap_lock_read(mapping);
> +	rcu_read_lock();
> +	for_each_process(tsk) {
> +		struct task_struct *t = tsk;
> +
> +		t = task_early_kill(tsk, true);
> +		if (!t)
> +			continue;
> +		vma_interval_tree_foreach(vma, &mapping->i_mmap, pfn, pfn) {
> +			if (vma->vm_mm == t->mm)
> +				add_to_kill_pfn(t, vma, to_kill, pfn);
> +		}
> +	}
> +	rcu_read_unlock();

We could play games here to make the GFP_ATOMIC allocation unnecessary,
but nasty.  Allocate the to_kill* outside the rcu_read_lock, pass that
pointer into add_to_kill_pfn().  If add_to_kill_pfn()'s
kmalloc(GFP_ATOMIC) failed, add_to_kill_pfn() can then consume the
caller's to_kill*.  Then the caller can drop the lock, allocate a new
to_kill* then restart the scan.  And teach add_to_kill_pfn() to not
re-add tasks which are already on the list.  Ugh.

At the very very least we should tell the user that the kernel goofed
and that one of their processes won't be getting killed.

> +	i_mmap_unlock_read(mapping);
> +}
> +
> +/**
> + * memory_failure_pfn - Handle memory failure on a page not backed by
> + *                      struct page.
> + * @pfn: Page Number of the corrupted page
> + * @flags: fine tune action taken
> + *
> + * Return:
> + *   0             - success,
> + *   -EBUSY        - Page PFN does not belong to any address space mapping.
> + */
> +static int memory_failure_pfn(unsigned long pfn, int flags)
> +{
> +	struct interval_tree_node *node;
> +	LIST_HEAD(tokill);
> +
> +	scoped_guard(mutex, &pfn_space_lock) {
> +		bool mf_handled = false;
> +
> +		/*
> +		 * Modules registers with MM the address space mapping to the device memory they
> +		 * manage. Iterate to identify exactly which address space has mapped to this
> +		 * failing PFN.

We're quite lenient about >80 columns nowadays, but overflowing 80 for
a block comment is rather needless.

> +		for (node = interval_tree_iter_first(&pfn_space_itree, pfn, pfn); node;
> +		     node = interval_tree_iter_next(node, pfn, pfn)) {
> +			struct pfn_address_space *pfn_space =
> +				container_of(node, struct pfn_address_space, node);
>
> +			collect_procs_pfn(pfn_space->mapping, pfn, &tokill);
> +
> +			mf_handled = true;
> +		}
> +
> +		if (!mf_handled)
> +			return action_result(pfn, MF_MSG_PFN_MAP, MF_IGNORED);
> +	}
> +
> +	/*
> +	 * Unlike System-RAM there is no possibility to swap in a different
> +	 * physical page at a given virtual address, so all userspace
> +	 * consumption of direct PFN memory necessitates SIGBUS (i.e.
> +	 * MF_MUST_KILL)
> +	 */
> +	flags |= MF_ACTION_REQUIRED | MF_MUST_KILL;
> +
> +	kill_procs(&tokill, true, pfn, flags);
> +
> +	return action_result(pfn, MF_MSG_PFN_MAP, MF_RECOVERED);
> +}
> +


