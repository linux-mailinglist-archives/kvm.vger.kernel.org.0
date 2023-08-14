Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9B5777BE3F
	for <lists+kvm@lfdr.de>; Mon, 14 Aug 2023 18:41:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231565AbjHNQlA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Aug 2023 12:41:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231963AbjHNQks (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Aug 2023 12:40:48 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B90EDE5E
        for <kvm@vger.kernel.org>; Mon, 14 Aug 2023 09:40:46 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-589db0ba2e1so40066577b3.1
        for <kvm@vger.kernel.org>; Mon, 14 Aug 2023 09:40:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692031246; x=1692636046;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=18eSGteYoLkyosrx8mcSXl9eX0Cj5k3Faeo0ftcxa3M=;
        b=PnNWNWZPQNLxsHhtc0+zEr09G6H9C/HERS6qtLgT73fEB88EQu44k6yDsRrn9YyIo2
         1p18J3CSE9NKdW2DctKUkw1wuerFPw18aKwiA3gQBDc824vuz8/MFTs5/bLZzIV0/MEm
         G6rJJKhfAUxdNW9SrlRrEEwzxSZI3z0Ci69vg9DzhFamaoND4AVvLRFVzk+Q1U3Dc0u3
         c7U6d8lISHa5rRSbmWmBdm5YyjxSgvjcLPICu0XChIx+GiAT6kuViIr1vC+hWgHtN/YO
         aHrTeIK8L+npTK6EI5a1rychfpwpAaCjeq7yWcQl1vguEQ9Sfdlcnn3EiBlimhV8ycgJ
         lgaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692031246; x=1692636046;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=18eSGteYoLkyosrx8mcSXl9eX0Cj5k3Faeo0ftcxa3M=;
        b=YHdk3TebjTUfByjP/f1cVvOXP7PBNUf/bouSDQyqkLXQHI7qT1AffinFai949FhzJ2
         6UlhHq6djLbvPUvHgjeMm/nBeVzeBSQUI9XZK4cZICenqDsXfDOrcKwzUlCS7hPjAlZ2
         VuaGNqHUb6JSEY0AzDZEgO/ZafdXFpPICNo2qud/dqyuO+HT7Iqsegj9fYb8mPvC+UZM
         Ermt4UZF3zKde+UxDoXg1KzsiKVrTVcvJsoBujsSAVtXU6pyE0UE1iPlfKpj6vZNerl2
         0fzKum7EJGwpGHFea2BysUn7GVQrqUpQGX3S9xgxPSrNM1KLSmpQJ66J11Uo9JWTLCuv
         fqXw==
X-Gm-Message-State: AOJu0YwbCBWny1siCHXn9oiorJbRTna7/e7/ip9FWbjLGMb8U+lxsmV0
        haAikXwFd0KP+VMLILBWmFgaB8mgUZM=
X-Google-Smtp-Source: AGHT+IHSPudkdVy5bvSRS0u3YMjW3SExfnMDPL4M58fPcPp0gzMZc3zGkdB/ZbyJB7vah1TUxWYMrOYrDx4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:72c:b0:589:a3d6:2e02 with SMTP id
 bt12-20020a05690c072c00b00589a3d62e02mr210147ywb.3.1692031246045; Mon, 14 Aug
 2023 09:40:46 -0700 (PDT)
Date:   Mon, 14 Aug 2023 09:40:44 -0700
In-Reply-To: <ZNnPF4W26ZbAyGto@yzhao56-desk.sh.intel.com>
Mime-Version: 1.0
References: <20230810085636.25914-1-yan.y.zhao@intel.com> <20230810090218.26244-1-yan.y.zhao@intel.com>
 <277ee023-dc94-6c23-20b2-7deba641f1b1@loongson.cn> <ZNWu2YCxy2FQBl4z@yzhao56-desk.sh.intel.com>
 <e7032573-9717-b1b9-7335-cbb0da12cd2a@loongson.cn> <ZNXq9M/WqjEkfi3x@yzhao56-desk.sh.intel.com>
 <ZNZshVZI5bRq4mZQ@google.com> <ZNnPF4W26ZbAyGto@yzhao56-desk.sh.intel.com>
Message-ID: <ZNpZDH9//vk8Rqvo@google.com>
Subject: Re: [RFC PATCH v2 5/5] KVM: Unmap pages only when it's indeed
 protected for NUMA migration
From:   Sean Christopherson <seanjc@google.com>
To:     Yan Zhao <yan.y.zhao@intel.com>
Cc:     bibo mao <maobibo@loongson.cn>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        pbonzini@redhat.com, mike.kravetz@oracle.com, apopple@nvidia.com,
        jgg@nvidia.com, rppt@kernel.org, akpm@linux-foundation.org,
        kevin.tian@intel.com, david@redhat.com
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 14, 2023, Yan Zhao wrote:
> On Fri, Aug 11, 2023 at 10:14:45AM -0700, Sean Christopherson wrote:
> > > > > After this series, kvm_unmap_gfn_range() is called for once if the 2M is
> > > > > mapped to a huge page in primary MMU, and called for at most 512 times
> > > > > if mapped to 4K pages in primary MMU.
> > > > > 
> > > > > 
> > > > > Though kvm_unmap_gfn_range() is only called once before this series,
> > > > > as the range is blockable, when there're contentions, remote tlb IPIs
> > > > > can be sent page by page in 4K granularity (in tdp_mmu_iter_cond_resched())
> > > > I do not know much about x86, does this happen always or only need reschedule
> > > Ah, sorry, I missed platforms other than x86.
> > > Maybe there will be a big difference in other platforms.
> > > 
> > > > from code?  so that there will be many times of tlb IPIs in only once function
> > > Only when MMU lock is contended. But it's not seldom because of the contention in
> > > TDP page fault.
> > 
> > No?  I don't see how mmu_lock contention would affect the number of calls to 
> > kvm_flush_remote_tlbs().  If vCPUs are running and not generating faults, i.e.
> > not trying to access the range in question, then ever zap will generate a remote
> > TLB flush and thus send IPIs to all running vCPUs.
> In tdp_mmu_zap_leafs() for kvm_unmap_gfn_range(), the flow is like this:
> 
> 1. Check necessity of mmu_lock reschedule

Ah, you're running a preemptible kernel.

> 1.a -- if yes,
>        1.a.1 do kvm_flush_remote_tlbs() if flush is true.
>        1.a.2 reschedule of mmu_lock
>        1.a.3 goto 2.
> 1.b -- if no, goto 2
> 2. Zap present leaf entry, and set flush to be true
> 3. Get next gfn and go to to 1
> 
> With a wide range to .invalidate_range_start()/end(), it's easy to find
> rwlock_needbreak(&kvm->mmu_lock) to be true (goes to 1.a and 1.a.1)
> And in tdp_mmu_zap_leafs(), before rescheduling of mmu_lock, tlb flush
> request is performed. (1.a.1)
> 
> 
> Take a real case for example,
> NUMA balancing requests KVM to zap GFN range from 0xb4000 to 0xb9800.
> Then when KVM zaps GFN 0xb807b, it will finds mmu_lock needs break
> because vCPU is faulting GFN 0xb804c.
> And vCPUs fill constantly retry faulting 0xb804c for 3298 times until
> .invalidate_range_end().
> Then for this zap of GFN range from 0xb4000 - 0xb9800,
> vCPUs retry fault of
> GFN 0xb804c for 3298 times,
> GFN 0xb8074 for 3161 times,
> GFN 0xb81ce for 15190 times,
> and the accesses of the 3 GFNs cause 3209 times of kvm_flush_remote_tlbs()
> for one kvm_unmap_gfn_range() because flush requests are not batched.
> (this range is mapped in both 2M and 4K in secondary MMU).
> 
> Without the contending of mmu_lock, tdp_mmu_zap_leafs() just combines
> all flush requests and leaves 1 kvm_flush_remote_tlbs() to be called
> after it returns.
> 
> 
> In my test scenario, which is VM boot-up, this kind of contention is
> frequent.

Hmm, I think your test scenario is a bit of an outlier.  Running a preemptible
kernel on a multi-socket system (presumably your system is multi-socket if you
have NUMA) is a bit odd.

Not that that invalidates the test result, but I would be quite surprised if there
are production use cases for NUMA+KVM+preemptible.  Though maybe I'm underestimating
how much KVM is used on workstations?

> Here's the 10 times data for a VM boot-up collected previously.
>        |      count of       |       count of          |
>        | kvm_unmap_gfn_range | kvm_flush_remote_tlbs() |
> -------|---------------------|-------------------------|
>    1   |         38          |           14            |
>    2   |         28          |         5191            |
>    3   |         36          |        13398            |
>    4   |         44          |        43920            |
>    5   |         28          |           14            |
>    6   |         36          |        10803            |
>    7   |         38          |          892            |
>    8   |         32          |         5905            |
>    9   |         32          |           13            |
>   10   |         38          |         6096            |
> -------|---------------------|-------------------------|
> average|         35          |         8625            |
> 
> 
> I wonder if we could loose the frequency to check for rescheduling in
> tdp_mmu_iter_cond_resched() if the zap range is wide, e.g.
> 
> if (iter->next_last_level_gfn ==
>     iter->yielded_gfn + KVM_PAGES_PER_HPAGE(PG_LEVEL_2M))
> 	return false;

Hrm, no.  We'd want to repeat that logic for the shadow MMU, and it could regress
other scenarios, e.g. if a vCPU is trying to fault-in an address that isn't part
of the invalidation, then yielding asap is desirable.

Unless I'm missing something, the easiest solution is to check for an invalidation
*before* acquiring mmu_lock.  The check would be prone to false negatives and false
positives, so KVM would need to recheck after acquiring mmu_lock, but the check
itself is super cheap relative to the overall cost of the page fault.

Compile tested patch at the bottom.  I'll test and post formally (probably with
similar treatment for other architectures).

> > > > call about kvm_unmap_gfn_range.
> > > > 
> > > > > if the pages are mapped in 4K in secondary MMU.
> > > > > 
> > > > > With this series, on the other hand, .numa_protect() sets range to be
> > > > > unblockable. So there could be less remote tlb IPIs when a 2M range is
> > > > > mapped into small PTEs in secondary MMU.
> > > > > Besides, .numa_protect() is not sent for all pages in a given 2M range.
> > > > No, .numa_protect() is not sent for all pages. It depends on the workload,
> > > > whether the page is accessed for different cpu threads cross-nodes.
> > > The .numa_protect() is called in patch 4 only when PROT_NONE is set to
> > > the page.
> > 
> > I'm strongly opposed to adding MMU_NOTIFIER_RANGE_NUMA.  It's too much of a one-off,
> > and losing the batching of invalidations makes me nervous.  As Bibo points out,
> > the behavior will vary based on the workload, VM configuration, etc.
> > 
> > There's also a *very* subtle change, in that the notification will be sent while
> > holding the PMD/PTE lock.  Taking KVM's mmu_lock under that is *probably* ok, but
> > I'm not exactly 100% confident on that.  And the only reason there isn't a more
> MMU lock is a rwlock, which is a variant of spinlock.
> So, I think taking it within PMD/PTE lock is ok.
> Actually we have already done that during the .change_pte() notification, where
> 
> kvm_mmu_notifier_change_pte() takes KVM mmu_lock for write,
> while PTE lock is held while sending set_pte_at_notify() --> .change_pte() handlers

.change_pte() gets away with running under PMD/PTE lock because (a) it's not allowed
to fail and (b) KVM is the only secondary MMU that hooks .change_pte() and KVM
doesn't use a sleepable lock.

As Jason pointed out, mmu_notifier_invalidate_range_start_nonblock() can fail
because some secondary MMUs use mutexes or r/w semaphores to handle mmu_notifier
events.  For NUMA balancing, canceling the protection change might be ok, but for
everything else, failure is not an option.  So unfortunately, my idea won't work
as-is.

We might get away with deferring just the change_prot_numa() case, but I don't
think that's worth the mess/complexity.

I would much rather tell userspace to disable migrate-on-fault for KVM guest
mappings (mbind() should work?) for these types of setups, or to disable NUMA
balancing entirely.  If the user really cares about performance of their VM(s),
vCPUs should be affined to a single NUMA node (or core, or pinned 1:1), and if
the VM spans multiple nodes, a virtual NUMA topology should be given to the guest.
At that point, NUMA balancing is likely to do more harm than good.

> > obvious bug is because kvm_handle_hva_range() sets may_block to false, e.g. KVM
> > won't yield if there's mmu_lock contention.
> Yes, KVM won't yield and reschedule of KVM mmu_lock, so it's fine.
> 
> > However, *if* it's ok to invoke MMU notifiers while holding PMD/PTE locks, then
> > I think we can achieve what you want without losing batching, and without changing
> > secondary MMUs.
> > 
> > Rather than muck with the notification types and add a one-off for NUMA, just
> > defer the notification until a present PMD/PTE is actually going to be modified.
> > It's not the prettiest, but other than the locking, I don't think has any chance
> > of regressing other workloads/configurations.
> > 
> > Note, I'm assuming secondary MMUs aren't allowed to map swap entries...
> > 
> > Compile tested only.
> 
> I don't find a matching end to each
> mmu_notifier_invalidate_range_start_nonblock().

It pairs with existing call to mmu_notifier_invalidate_range_end() in change_pmd_range():

	if (range.start)
		mmu_notifier_invalidate_range_end(&range);

--
From: Sean Christopherson <seanjc@google.com>
Date: Mon, 14 Aug 2023 08:59:12 -0700
Subject: [PATCH] KVM: x86/mmu: Retry fault before acquiring mmu_lock if
 mapping is changing

Retry page faults without acquiring mmu_lock if the resolve hva is covered
by an active invalidation.  Contending for mmu_lock is especially
problematic on preemptible kernels as the invalidation task will yield the
lock (see rwlock_needbreak()), delay the in-progress invalidation, and
ultimately increase the latency of resolving the page fault.  And in the
worst case scenario, yielding will be accompanied by a remote TLB flush,
e.g. if the invalidation covers a large range of memory and vCPUs are
accessing addresses that were already zapped.

Alternatively, the yielding issue could be mitigated by teaching KVM's MMU
iterators to perform more work before yielding, but that wouldn't solve
the lock contention and would negatively affect scenarios where a vCPU is
trying to fault in an address that is NOT covered by the in-progress
invalidation.

Reported-by: Yan Zhao <yan.y.zhao@intel.com>
Closes: https://lore.kernel.org/all/ZNnPF4W26ZbAyGto@yzhao56-desk.sh.intel.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c   | 3 +++
 include/linux/kvm_host.h | 8 +++++++-
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 9e4cd8b4a202..f29718a16211 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4345,6 +4345,9 @@ static int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
 	if (unlikely(!fault->slot))
 		return kvm_handle_noslot_fault(vcpu, fault, access);
 
+	if (mmu_invalidate_retry_hva(vcpu->kvm, fault->mmu_seq, fault->hva))
+		return RET_PF_RETRY;
+
 	return RET_PF_CONTINUE;
 }
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index cb86108c624d..f41d4fe61a06 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1960,7 +1960,6 @@ static inline int mmu_invalidate_retry_hva(struct kvm *kvm,
 					   unsigned long mmu_seq,
 					   unsigned long hva)
 {
-	lockdep_assert_held(&kvm->mmu_lock);
 	/*
 	 * If mmu_invalidate_in_progress is non-zero, then the range maintained
 	 * by kvm_mmu_notifier_invalidate_range_start contains all addresses
@@ -1971,6 +1970,13 @@ static inline int mmu_invalidate_retry_hva(struct kvm *kvm,
 	    hva >= kvm->mmu_invalidate_range_start &&
 	    hva < kvm->mmu_invalidate_range_end)
 		return 1;
+
+	/*
+	 * Note the lack of a memory barrier!  The caller *must* hold mmu_lock
+	 * to avoid false negatives and/or false positives (less concerning).
+	 * Holding mmu_lock is not mandatory though, e.g. to allow pre-checking
+	 * for an in-progress invalidation to avoiding contending mmu_lock.
+	 */
 	if (kvm->mmu_invalidate_seq != mmu_seq)
 		return 1;
 	return 0;

base-commit: 5bc7f472423f95a3f5c73b0b56c47e57d8833efc
-- 

