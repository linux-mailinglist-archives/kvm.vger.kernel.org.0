Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80A6E5F9A4B
	for <lists+kvm@lfdr.de>; Mon, 10 Oct 2022 09:44:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231705AbiJJHoo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Oct 2022 03:44:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231512AbiJJHoZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Oct 2022 03:44:25 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4133F550B2;
        Mon, 10 Oct 2022 00:41:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1665387670; x=1696923670;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=+icS+dW+2xn4auXE6gZk9UVIXhwmFDJ7GHKfYMg8TS4=;
  b=Onzw5RCZCb+TnLNgFJXpL7jyIvhGcOYnGuDBRsKsR6OnysjRNXP0Ozmj
   KkwGEip2S1DeSkKkrUtBgllO800Csov2wz8CrFJcVSizftqTzhZbHsWqt
   ieGa8i1axSL3sxXtvtqEpoI5nnVSUeJbHDDBAQVEUtGuaKOwAjA5j+U9E
   mzU2URSTEh7s2VuZbAIQLXfG5FVtxNcm+MkHeEhoexmi5gz8FZBFNw71l
   F/km6uA85Ljvg0I8afwyrZ6URSxQxDTkEOvT8I28GqqwiRsY0v4xL4BG8
   ImzJK0XRnylVVmGjQ5MnLAn3ImZVEipVbfxmlLuekooEMxXRLvu17UF1X
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10495"; a="287403320"
X-IronPort-AV: E=Sophos;i="5.95,173,1661842800"; 
   d="scan'208";a="287403320"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Oct 2022 00:41:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10495"; a="688694901"
X-IronPort-AV: E=Sophos;i="5.95,173,1661842800"; 
   d="scan'208";a="688694901"
Received: from ubuntu.bj.intel.com ([10.238.155.108])
  by fmsmga008.fm.intel.com with ESMTP; 10 Oct 2022 00:41:02 -0700
From:   Jun Miao <jun.miao@intel.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jun Miao <jun.miao@intel.com>
Subject: [PATCH] KVM: Align two spacebar after period key in annotation
Date:   Mon, 10 Oct 2022 15:40:52 +0800
Message-Id: <20221010074052.72197-1-jun.miao@intel.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

After you hit the period key, you'd hit the spacebar twice in a line.
A little change in annotation does not affect code.

Signed-off-by: Jun Miao <jun.miao@intel.com>
---
 virt/kvm/kvm_main.c | 44 ++++++++++++++++++++++----------------------
 1 file changed, 22 insertions(+), 22 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index e30f1b4ecfa5..c81b973a3b02 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -285,10 +285,10 @@ static void kvm_make_vcpu_request(struct kvm_vcpu *vcpu, unsigned int req,
 	 * after kvm_request_needs_ipi(), which could result in sending an IPI
 	 * to the previous pCPU.  But, that's OK because the purpose of the IPI
 	 * is to ensure the vCPU returns to OUTSIDE_GUEST_MODE, which is
-	 * satisfied if the vCPU migrates. Entering READING_SHADOW_PAGE_TABLES
+	 * satisfied if the vCPU migrates.  Entering READING_SHADOW_PAGE_TABLES
 	 * after this point is also OK, as the requirement is only that KVM wait
 	 * for vCPUs that were reading SPTEs _before_ any changes were
-	 * finalized. See kvm_vcpu_kick() for more details on handling requests.
+	 * finalized.  See kvm_vcpu_kick() for more details on handling requests.
 	 */
 	if (kvm_request_needs_ipi(vcpu, req)) {
 		cpu = READ_ONCE(vcpu->cpu);
@@ -362,13 +362,13 @@ void kvm_flush_remote_tlbs(struct kvm *kvm)
 
 	/*
 	 * We want to publish modifications to the page tables before reading
-	 * mode. Pairs with a memory barrier in arch-specific code.
+	 * mode.  Pairs with a memory barrier in arch-specific code.
 	 * - x86: smp_mb__after_srcu_read_unlock in vcpu_enter_guest
 	 * and smp_mb in walk_shadow_page_lockless_begin/end.
 	 * - powerpc: smp_mb in kvmppc_prepare_to_enter.
 	 *
 	 * There is already an smp_mb__after_atomic() before
-	 * kvm_make_all_cpus_request() reads vcpu->mode. We reuse that
+	 * kvm_make_all_cpus_request() reads vcpu->mode.  We reuse that
 	 * barrier here.
 	 */
 	if (!kvm_arch_flush_remote_tlb(kvm)
@@ -730,8 +730,8 @@ void kvm_mmu_invalidate_begin(struct kvm *kvm, unsigned long start,
 	} else {
 		/*
 		 * Fully tracking multiple concurrent ranges has diminishing
-		 * returns. Keep things simple and just find the minimal range
-		 * which includes the current and new ranges. As there won't be
+		 * returns.  Keep things simple and just find the minimal range
+		 * which includes the current and new ranges.  As there won't be
 		 * enough information to subtract a range after its invalidate
 		 * completes, any ranges invalidated concurrently will
 		 * accumulate and persist until all outstanding invalidates
@@ -863,13 +863,13 @@ static int kvm_mmu_notifier_clear_young(struct mmu_notifier *mn,
 	 * Even though we do not flush TLB, this will still adversely
 	 * affect performance on pre-Haswell Intel EPT, where there is
 	 * no EPT Access Bit to clear so that we have to tear down EPT
-	 * tables instead. If we find this unacceptable, we can always
+	 * tables instead.  If we find this unacceptable, we can always
 	 * add a parameter to kvm_age_hva so that it effectively doesn't
 	 * do anything on clear_young.
 	 *
 	 * Also note that currently we never issue secondary TLB flushes
 	 * from clear_young, leaving this job up to the regular system
-	 * cadence. If we find this inaccurate, we might come up with a
+	 * cadence.  If we find this inaccurate, we might come up with a
 	 * more sophisticated heuristic later.
 	 */
 	return kvm_handle_hva_range_no_flush(mn, start, end, kvm_age_gfn);
@@ -1513,7 +1513,7 @@ static void kvm_replace_memslot(struct kvm *kvm,
 	/*
 	 * If the memslot gfn is unchanged, rb_replace_node() can be used to
 	 * switch the node in the gfn tree instead of removing the old and
-	 * inserting the new as two separate operations. Replacement is a
+	 * inserting the new as two separate operations.  Replacement is a
 	 * single O(1) operation versus two O(log(n)) operations for
 	 * remove+insert.
 	 */
@@ -1568,7 +1568,7 @@ static void kvm_swap_active_memslots(struct kvm *kvm, int as_id)
 	spin_unlock(&kvm->mn_invalidate_lock);
 
 	/*
-	 * Acquired in kvm_set_memslot. Must be released before synchronize
+	 * Acquired in kvm_set_memslot.  Must be released before synchronize
 	 * SRCU below in order to avoid deadlock with another thread
 	 * acquiring the slots_arch_lock in an srcu critical section.
 	 */
@@ -1730,7 +1730,7 @@ static void kvm_invalidate_memslot(struct kvm *kvm,
 
 	/*
 	 * Activate the slot that is now marked INVALID, but don't propagate
-	 * the slot to the now inactive slots. The slot is either going to be
+	 * the slot to the now inactive slots.  The slot is either going to be
 	 * deleted or recreated as a new slot.
 	 */
 	kvm_swap_active_memslots(kvm, old->as_id);
@@ -1796,7 +1796,7 @@ static void kvm_update_flags_memslot(struct kvm *kvm,
 {
 	/*
 	 * Similar to the MOVE case, but the slot doesn't need to be zapped as
-	 * an intermediate step. Instead, the old memslot is simply replaced
+	 * an intermediate step.  Instead, the old memslot is simply replaced
 	 * with a new, updated copy in both memslot sets.
 	 */
 	kvm_replace_memslot(kvm, old, new);
@@ -2192,13 +2192,13 @@ static int kvm_get_dirty_log_protect(struct kvm *kvm, struct kvm_dirty_log *log)
  * @kvm: kvm instance
  * @log: slot id and address to which we copy the log
  *
- * Steps 1-4 below provide general overview of dirty page logging. See
+ * Steps 1-4 below provide general overview of dirty page logging.  See
  * kvm_get_dirty_log_protect() function description for additional details.
  *
  * We call kvm_get_dirty_log_protect() to handle steps 1-3, upon return we
  * always flush the TLB (step 4) even if previous step failed  and the dirty
- * bitmap may be corrupt. Regardless of previous outcome the KVM logging API
- * does not preclude user space subsequent dirty log read. Flushing TLB ensures
+ * bitmap may be corrupt.  Regardless of previous outcome the KVM logging API
+ * does not preclude user space subsequent dirty log read.  Flushing TLB ensures
  * writes will be marked dirty for next log read.
  *
  *   1. Take a snapshot of the bit and clear it if needed.
@@ -2341,7 +2341,7 @@ struct kvm_memory_slot *kvm_vcpu_gfn_to_memslot(struct kvm_vcpu *vcpu, gfn_t gfn
 		return slot;
 
 	/*
-	 * Fall back to searching all memslots. We purposely use
+	 * Fall back to searching all memslots.  We purposely use
 	 * search_memslots() instead of __gfn_to_memslot() to avoid
 	 * thrashing the VM-wide last_used_slot in kvm_memslots.
 	 */
@@ -2622,7 +2622,7 @@ static int hva_to_pfn_remapped(struct vm_area_struct *vma,
 	 * struct pages, but be allocated without refcounting e.g.,
 	 * tail pages of non-compound higher order allocations, which
 	 * would then underflow the refcount when the caller does the
-	 * required put_page. Don't allow those pages here.
+	 * required put_page.  Don't allow those pages here.
 	 */ 
 	if (!kvm_try_get_pfn(pfn))
 		r = -EFAULT;
@@ -3641,16 +3641,16 @@ EXPORT_SYMBOL_GPL(kvm_vcpu_yield_to);
  *
  *  (b) VCPU which has done pl-exit/ cpu relax intercepted but did not get
  *  chance last time (mostly it has become eligible now since we have probably
- *  yielded to lockholder in last iteration. This is done by toggling
+ *  yielded to lockholder in last iteration.  This is done by toggling
  *  @dy_eligible each time a VCPU checked for eligibility.)
  *
  *  Yielding to a recently pl-exited/cpu relax intercepted VCPU before yielding
  *  to preempted lock-holder could result in wrong VCPU selection and CPU
- *  burning. Giving priority for a potential lock-holder increases lock
+ *  burning.  Giving priority for a potential lock-holder increases lock
  *  progress.
  *
  *  Since algorithm is based on heuristics, accessing another VCPU data without
- *  locking does not harm. It may result in trying to yield to  same VCPU, fail
+ *  locking does not harm.  It may result in trying to yield to same VCPU, fail
  *  and continue with next VCPU and so on.
  */
 static bool kvm_vcpu_eligible_for_directed_yield(struct kvm_vcpu *vcpu)
@@ -6010,9 +6010,9 @@ static int kvm_vm_worker_thread(void *context)
 	 * execution.
 	 *
 	 * kthread_stop() waits on the 'exited' completion condition which is
-	 * set in exit_mm(), via mm_release(), in do_exit(). However, the
+	 * set in exit_mm(), via mm_release(), in do_exit().  However, the
 	 * kthread is removed from the cgroup in the cgroup_exit() which is
-	 * called after the exit_mm(). This causes the kthread_stop() to return
+	 * called after the exit_mm().  This causes the kthread_stop() to return
 	 * before the kthread actually quits the cgroup.
 	 */
 	rcu_read_lock();
-- 
2.32.0

