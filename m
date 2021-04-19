Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4262C364D80
	for <lists+kvm@lfdr.de>; Tue, 20 Apr 2021 00:09:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230011AbhDSWKL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Apr 2021 18:10:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229683AbhDSWKK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Apr 2021 18:10:10 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65897C06174A;
        Mon, 19 Apr 2021 15:09:40 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id d21so22511007edv.9;
        Mon, 19 Apr 2021 15:09:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=kEWt7qrw63QDLerFF7Mc05J/Rjx3eO2DI80nXa7Y28w=;
        b=sk6hBP8eYqimqgxK2TfmwROjJGmY4ZIQEMcCLdiMp1+8DOS+yudOmCLpK/qvKkN37w
         PFj3KXU+VJiMKPatD1cu1GKb9XAT0dJneYEBaGYG3xEa+DAhQd7G7LeZthMaPfLJaxH8
         LO44fJDUFSSMFkKrkgEY13Q0dSUk6LwBUn5m6YLtzTaeNC0x0gK103UfUpc8vsmAzR3/
         LX88cxYSkG0L4dowat4Xc0xmqg9cYll03BkEXlvmQQmqfGherw2bxybb3ILx9ueMrX6O
         hJzkA9+OxQ1jMeR70oBjuajelUcj3rhxmswdrjeAjn/UdgmnEPjmS9rHhBLXWZyRmrsS
         SKJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:to:cc:references:from:subject:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kEWt7qrw63QDLerFF7Mc05J/Rjx3eO2DI80nXa7Y28w=;
        b=qYZOGs7eFDbbNGWipvYLW3e1oHMWvsaUvaN7eDXpQjEz3fKXWoMRZR+24c7Xft7LKB
         v/GP/bsf4cTF6GoAtzIf/Gif2dFp0lMWSWv8MLGaInf2QXT1b0LD8BkICJ/xqDq23Cja
         +iERAI3eBZNe2MUxgR+SfDwq086aHIVvnMDy3vu4WUpaT6rUGp5kn/xVw8IpLV+hW+rT
         VgXyspOIDAIqRYKNEM3SUrrC/AOUmCmDWSpYt57hAgsA+ouZnxrTgE/upu5HCgGg5Bl8
         soIk6Oo644tbqERnsSTKFmLp7E+byg3H/Xz5GNhEOo1LmEvagEHwrxE3vhP/MlhfMFCO
         WNew==
X-Gm-Message-State: AOAM530DmP3FwfAlhl8BrnsRrU5qLEnolzXUL9g7gPEiGu36bulF/FKY
        KLEzOhoXWPoIaXkCL44ij6I=
X-Google-Smtp-Source: ABdhPJxqTq27BOhYsREbsWDoXf8d6X20wdeimSLgH9BZEoRv5UGuRovufAifz/YZHXmXUF3539Cb8Q==
X-Received: by 2002:aa7:d14f:: with SMTP id r15mr28344958edo.130.1618870178855;
        Mon, 19 Apr 2021 15:09:38 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.googlemail.com with ESMTPSA id bu26sm11132565ejb.30.2021.04.19.15.09.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Apr 2021 15:09:38 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Wanpeng Li <kernellwp@gmail.com>, Marc Zyngier <maz@kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ben Gardon <bgardon@google.com>
References: <20210402005658.3024832-1-seanjc@google.com>
 <20210402005658.3024832-10-seanjc@google.com>
 <CANRm+Cwt9Xs=13r9E4YWOhcE6oEJXmVrkKrv_wQ5jMUkY8+Stw@mail.gmail.com>
 <2a7670e4-94c0-9f35-74de-a7d5b1504ced@redhat.com>
 <YH2dDRBXJcbUcbLi@google.com>
From:   Paolo Bonzini <bonzini@gnu.org>
Subject: Re: [PATCH v2 09/10] KVM: Don't take mmu_lock for range invalidation
 unless necessary
Message-ID: <051f78aa-7bf8-0832-aee6-b4157a1853a0@gnu.org>
Date:   Tue, 20 Apr 2021 00:09:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <YH2dDRBXJcbUcbLi@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19/04/21 17:09, Sean Christopherson wrote:
>> - this loses the rwsem fairness.  On the other hand, mm/mmu_notifier.c's
>> own interval-tree-based filter is also using a similar mechanism that is
>> likewise not fair, so it should be okay.
> 
> The one concern I had with an unfair mechanism of this nature is that, in theory,
> the memslot update could be blocked indefinitely.

Yep, that's why I mentioned it.

>> @@ -1333,9 +1351,22 @@ static struct kvm_memslots *install_new_memslots(struct kvm *kvm,
>>   	WARN_ON(gen & KVM_MEMSLOT_GEN_UPDATE_IN_PROGRESS);
>>   	slots->generation = gen | KVM_MEMSLOT_GEN_UPDATE_IN_PROGRESS;
>> -	down_write(&kvm->mmu_notifier_slots_lock);
>> +	/*
>> +	 * This cannot be an rwsem because the MMU notifier must not run
>> +	 * inside the critical section.  A sleeping rwsem cannot exclude
>> +	 * that.
> 
> How on earth did you decipher that from the splat?  I stared at it for a good
> five minutes and was completely befuddled.

Just scratch that, it makes no sense.  It's much simpler, but you have
to look at include/linux/mmu_notifier.h to figure it out:

     invalidate_range_start
       take pseudo lock
       down_read()           (*)
       release pseudo lock
     invalidate_range_end
       take pseudo lock      (**)
       up_read()
       release pseudo lock

At point (*) we take the mmu_notifiers_slots_lock inside the pseudo lock;
at point (**) we take the pseudo lock inside the mmu_notifiers_slots_lock.

This could cause a deadlock (ignoring for a second that the pseudo lock
is not a lock):

- invalidate_range_start waits on down_read(), because the rwsem is
held by install_new_memslots

- install_new_memslots waits on down_write(), because the rwsem is
held till (another) invalidate_range_end finishes

- invalidate_range_end sits waits on the pseudo lock, held by
invalidate_range_start.

Removing the fairness of the rwsem breaks the cycle (in lockdep terms,
it would change the *shared* rwsem readers into *shared recursive*
readers).  This also means that there's no need for a raw spinlock.

Given this simple explanation, I think it's okay to include this
patch in the merge window pull request, with the fix after my
signature squashed in.  The fix actually undoes a lot of the
changes to __kvm_handle_hva_range that this patch made, so the
result is relatively simple.  You can already find the result
in kvm/queue.

Paolo

 From daefeeb229ba8be5bd819a51875bc1fd5e74fc85 Mon Sep 17 00:00:00 2001
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Mon, 19 Apr 2021 09:01:46 -0400
Subject: [PATCH] KVM: avoid "deadlock" between install_new_memslots and MMU
  notifier

Wanpeng Li is reporting this splat:

  ======================================================
  WARNING: possible circular locking dependency detected
  5.12.0-rc3+ #6 Tainted: G           OE
  ------------------------------------------------------
  qemu-system-x86/3069 is trying to acquire lock:
  ffffffff9c775ca0 (mmu_notifier_invalidate_range_start){+.+.}-{0:0}, at: __mmu_notifier_invalidate_range_end+0x5/0x190

  but task is already holding lock:
  ffffaff7410a9160 (&kvm->mmu_notifier_slots_lock){.+.+}-{3:3}, at: kvm_mmu_notifier_invalidate_range_start+0x36d/0x4f0 [kvm]

  which lock already depends on the new lock.

This corresponds to the following MMU notifier logic:

     invalidate_range_start
       take pseudo lock
       down_read()           (*)
       release pseudo lock
     invalidate_range_end
       take pseudo lock      (**)
       up_read()
       release pseudo lock

At point (*) we take the mmu_notifiers_slots_lock inside the pseudo lock;
at point (**) we take the pseudo lock inside the mmu_notifiers_slots_lock.

This could cause a deadlock (ignoring for a second that the pseudo lock
is not a lock):

- invalidate_range_start waits on down_read(), because the rwsem is
held by install_new_memslots

- install_new_memslots waits on down_write(), because the rwsem is
held till (another) invalidate_range_end finishes

- invalidate_range_end sits waits on the pseudo lock, held by
invalidate_range_start.

Removing the fairness of the rwsem breaks the cycle (in lockdep terms,
it would change the *shared* rwsem readers into *shared recursive*
readers), so open-code the wait using a readers count and a
spinlock.  This also allows handling blockable and non-blockable
critical section in the same way.

Losing the rwsem fairness does theoretically allow MMU notifiers to
block install_new_memslots forever.  Note that mm/mmu_notifier.c's own
retry scheme in mmu_interval_read_begin also uses wait/wake_up
and is likewise not fair.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
  Documentation/virt/kvm/locking.rst |   9 +--
  include/linux/kvm_host.h           |   8 +-
  virt/kvm/kvm_main.c                | 119 ++++++++++++++---------------
  3 files changed, 67 insertions(+), 69 deletions(-)

diff --git a/Documentation/virt/kvm/locking.rst b/Documentation/virt/kvm/locking.rst
index 8f5d5bcf5689..e628f48dfdda 100644
--- a/Documentation/virt/kvm/locking.rst
+++ b/Documentation/virt/kvm/locking.rst
@@ -16,12 +16,11 @@ The acquisition orders for mutexes are as follows:
  - kvm->slots_lock is taken outside kvm->irq_lock, though acquiring
    them together is quite rare.
  
-- The kvm->mmu_notifier_slots_lock rwsem ensures that pairs of
+- kvm->mn_active_invalidate_count ensures that pairs of
    invalidate_range_start() and invalidate_range_end() callbacks
-  use the same memslots array.  kvm->slots_lock is taken outside the
-  write-side critical section of kvm->mmu_notifier_slots_lock, so
-  MMU notifiers must not take kvm->slots_lock.  No other write-side
-  critical sections should be added.
+  use the same memslots array.  kvm->slots_lock is taken on the
+  waiting side in install_new_memslots, so MMU notifiers must not
+  take kvm->slots_lock.
  
  On x86:
  
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 5808c259b92b..5ef09a4bc9c9 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -472,11 +472,15 @@ struct kvm {
  #endif /* KVM_HAVE_MMU_RWLOCK */
  
  	struct mutex slots_lock;
-	struct rw_semaphore mmu_notifier_slots_lock;
  	struct mm_struct *mm; /* userspace tied to this vm */
  	struct kvm_memslots __rcu *memslots[KVM_ADDRESS_SPACE_NUM];
  	struct kvm_vcpu *vcpus[KVM_MAX_VCPUS];
  
+	/* Used to wait for completion of MMU notifiers.  */
+	spinlock_t mn_invalidate_lock;
+	unsigned long mn_active_invalidate_count;
+	struct rcuwait mn_memslots_update_rcuwait;
+
  	/*
  	 * created_vcpus is protected by kvm->lock, and is incremented
  	 * at the beginning of KVM_CREATE_VCPU.  online_vcpus is only
@@ -663,7 +667,7 @@ static inline struct kvm_memslots *__kvm_memslots(struct kvm *kvm, int as_id)
  	as_id = array_index_nospec(as_id, KVM_ADDRESS_SPACE_NUM);
  	return srcu_dereference_check(kvm->memslots[as_id], &kvm->srcu,
  				      lockdep_is_held(&kvm->slots_lock) ||
-				      lockdep_is_held(&kvm->mmu_notifier_slots_lock) ||
+				      READ_ONCE(kvm->mn_active_invalidate_count) ||
  				      !refcount_read(&kvm->users_count));
  }
  
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 90f579e996e5..6a94ce073690 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -462,7 +462,6 @@ struct kvm_hva_range {
  	pte_t pte;
  	hva_handler_t handler;
  	on_lock_fn_t on_lock;
-	bool must_lock;
  	bool flush_on_ret;
  	bool may_block;
  };
@@ -480,25 +479,6 @@ static void kvm_null_fn(void)
  }
  #define IS_KVM_NULL_FN(fn) ((fn) == (void *)kvm_null_fn)
  
-
-/* Acquire mmu_lock if necessary.  Returns %true if @handler is "null" */
-static __always_inline bool kvm_mmu_lock_and_check_handler(struct kvm *kvm,
-							   const struct kvm_hva_range *range,
-							   bool *locked)
-{
-	if (*locked)
-		return false;
-
-	*locked = true;
-
-	KVM_MMU_LOCK(kvm);
-
-	if (!IS_KVM_NULL_FN(range->on_lock))
-		range->on_lock(kvm, range->start, range->end);
-
-	return IS_KVM_NULL_FN(range->handler);
-}
-
  static __always_inline int __kvm_handle_hva_range(struct kvm *kvm,
  						  const struct kvm_hva_range *range)
  {
@@ -515,10 +495,6 @@ static __always_inline int __kvm_handle_hva_range(struct kvm *kvm,
  
  	idx = srcu_read_lock(&kvm->srcu);
  
-	if (range->must_lock &&
-	    kvm_mmu_lock_and_check_handler(kvm, range, &locked))
-		goto out_unlock;
-
  	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
  		slots = __kvm_memslots(kvm, i);
  		kvm_for_each_memslot(slot, slots) {
@@ -547,8 +523,14 @@ static __always_inline int __kvm_handle_hva_range(struct kvm *kvm,
  			gfn_range.end = hva_to_gfn_memslot(hva_end + PAGE_SIZE - 1, slot);
  			gfn_range.slot = slot;
  
-			if (kvm_mmu_lock_and_check_handler(kvm, range, &locked))
-				goto out_unlock;
+			if (!locked) {
+				locked = true;
+				KVM_MMU_LOCK(kvm);
+				if (!IS_KVM_NULL_FN(range->on_lock))
+					range->on_lock(kvm, range->start, range->end);
+				if (IS_KVM_NULL_FN(range->handler))
+					break;
+			}
  
  			ret |= range->handler(kvm, &gfn_range);
  		}
@@ -557,7 +539,6 @@ static __always_inline int __kvm_handle_hva_range(struct kvm *kvm,
  	if (range->flush_on_ret && (ret || kvm->tlbs_dirty))
  		kvm_flush_remote_tlbs(kvm);
  
-out_unlock:
  	if (locked)
  		KVM_MMU_UNLOCK(kvm);
  
@@ -580,7 +561,6 @@ static __always_inline int kvm_handle_hva_range(struct mmu_notifier *mn,
  		.pte		= pte,
  		.handler	= handler,
  		.on_lock	= (void *)kvm_null_fn,
-		.must_lock	= false,
  		.flush_on_ret	= true,
  		.may_block	= false,
  	};
@@ -600,7 +580,6 @@ static __always_inline int kvm_handle_hva_range_no_flush(struct mmu_notifier *mn
  		.pte		= __pte(0),
  		.handler	= handler,
  		.on_lock	= (void *)kvm_null_fn,
-		.must_lock	= false,
  		.flush_on_ret	= false,
  		.may_block	= false,
  	};
@@ -620,13 +599,11 @@ static void kvm_mmu_notifier_change_pte(struct mmu_notifier *mn,
  	 * .change_pte() must be surrounded by .invalidate_range_{start,end}(),
  	 * If mmu_notifier_count is zero, then start() didn't find a relevant
  	 * memslot and wasn't forced down the slow path; rechecking here is
-	 * unnecessary.  This can only occur if memslot updates are blocked;
-	 * otherwise, mmu_notifier_count is incremented unconditionally.
+	 * unnecessary.
  	 */
-	if (!kvm->mmu_notifier_count) {
-		lockdep_assert_held(&kvm->mmu_notifier_slots_lock);
+	WARN_ON_ONCE(!READ_ONCE(kvm->mn_active_invalidate_count));
+	if (!kvm->mmu_notifier_count)
  		return;
-	}
  
  	kvm_handle_hva_range(mn, address, address + 1, pte, kvm_set_spte_gfn);
  }
@@ -663,7 +640,6 @@ static void kvm_inc_notifier_count(struct kvm *kvm, unsigned long start,
  static int kvm_mmu_notifier_invalidate_range_start(struct mmu_notifier *mn,
  					const struct mmu_notifier_range *range)
  {
-	bool blockable = mmu_notifier_range_blockable(range);
  	struct kvm *kvm = mmu_notifier_to_kvm(mn);
  	const struct kvm_hva_range hva_range = {
  		.start		= range->start,
@@ -671,9 +647,8 @@ static int kvm_mmu_notifier_invalidate_range_start(struct mmu_notifier *mn,
  		.pte		= __pte(0),
  		.handler	= kvm_unmap_gfn_range,
  		.on_lock	= kvm_inc_notifier_count,
-		.must_lock	= !blockable,
  		.flush_on_ret	= true,
-		.may_block	= blockable,
+		.may_block	= mmu_notifier_range_blockable(range),
  	};
  
  	trace_kvm_unmap_hva_range(range->start, range->end);
@@ -684,15 +659,11 @@ static int kvm_mmu_notifier_invalidate_range_start(struct mmu_notifier *mn,
  	 * functions.  Without that guarantee, the mmu_notifier_count
  	 * adjustments will be imbalanced.
  	 *
-	 * Skip the memslot-lookup lock elision (set @must_lock above) to avoid
-	 * having to take the semaphore on non-blockable calls, e.g. OOM kill.
-	 * The complexity required to handle conditional locking for this case
-	 * is not worth the marginal benefits, the VM is likely doomed anyways.
-	 *
-	 * Pairs with the up_read in range_end().
+	 * Pairs with the decrement in range_end().
  	 */
-	if (blockable)
-		down_read(&kvm->mmu_notifier_slots_lock);
+	spin_lock(&kvm->mn_invalidate_lock);
+	kvm->mn_active_invalidate_count++;
+	spin_unlock(&kvm->mn_invalidate_lock);
  
  	__kvm_handle_hva_range(kvm, &hva_range);
  
@@ -720,7 +691,6 @@ static void kvm_dec_notifier_count(struct kvm *kvm, unsigned long start,
  static void kvm_mmu_notifier_invalidate_range_end(struct mmu_notifier *mn,
  					const struct mmu_notifier_range *range)
  {
-	bool blockable = mmu_notifier_range_blockable(range);
  	struct kvm *kvm = mmu_notifier_to_kvm(mn);
  	const struct kvm_hva_range hva_range = {
  		.start		= range->start,
@@ -728,16 +698,24 @@ static void kvm_mmu_notifier_invalidate_range_end(struct mmu_notifier *mn,
  		.pte		= __pte(0),
  		.handler	= (void *)kvm_null_fn,
  		.on_lock	= kvm_dec_notifier_count,
-		.must_lock	= !blockable,
  		.flush_on_ret	= false,
-		.may_block	= blockable,
+		.may_block	= mmu_notifier_range_blockable(range),
  	};
+	bool wake;
  
  	__kvm_handle_hva_range(kvm, &hva_range);
  
-	/* Pairs with the down_read in range_start(). */
-	if (blockable)
-		up_read(&kvm->mmu_notifier_slots_lock);
+	/* Pairs with the increment in range_start(). */
+	spin_lock(&kvm->mn_invalidate_lock);
+	wake = (--kvm->mn_active_invalidate_count == 0);
+	spin_unlock(&kvm->mn_invalidate_lock);
+
+	/*
+	 * There can only be one waiter, since the wait happens under
+	 * slots_lock.
+	 */
+	if (wake)
+		rcuwait_wake_up(&kvm->mn_memslots_update_rcuwait);
  
  	BUG_ON(kvm->mmu_notifier_count < 0);
  }
@@ -951,7 +929,9 @@ static struct kvm *kvm_create_vm(unsigned long type)
  	mutex_init(&kvm->lock);
  	mutex_init(&kvm->irq_lock);
  	mutex_init(&kvm->slots_lock);
-	init_rwsem(&kvm->mmu_notifier_slots_lock);
+	spin_lock_init(&kvm->mn_invalidate_lock);
+	rcuwait_init(&kvm->mn_memslots_update_rcuwait);
+
  	INIT_LIST_HEAD(&kvm->devices);
  
  	BUILD_BUG_ON(KVM_MEM_SLOTS_NUM > SHRT_MAX);
@@ -1073,15 +1053,17 @@ static void kvm_destroy_vm(struct kvm *kvm)
  #if defined(CONFIG_MMU_NOTIFIER) && defined(KVM_ARCH_WANT_MMU_NOTIFIER)
  	mmu_notifier_unregister(&kvm->mmu_notifier, kvm->mm);
  	/*
-	 * Reset the lock used to prevent memslot updates between MMU notifier
-	 * invalidate_range_start() and invalidate_range_end().  At this point,
-	 * no more MMU notifiers will run and pending calls to ...start() have
-	 * completed.  But, the lock could still be held if KVM's notifier was
-	 * removed between ...start() and ...end().  No threads can be waiting
-	 * on the lock as the last reference on KVM has been dropped.  If the
-	 * lock is still held, freeing memslots will deadlock.
+	 * At this point, pending calls to invalidate_range_start()
+	 * have completed but no more MMU notifiers will run, so
+	 * mn_active_invalidate_count may remain unbalanced.
+	 * No threads can be waiting in install_new_memslots as the
+	 * last reference on KVM has been dropped, but freeing
+	 * memslots will deadlock without manual intervention.
  	 */
-	init_rwsem(&kvm->mmu_notifier_slots_lock);
+	spin_lock(&kvm->mn_invalidate_lock);
+	kvm->mn_active_invalidate_count = 0;
+	WARN_ON(rcuwait_active(&kvm->mn_memslots_update_rcuwait));
+	spin_unlock(&kvm->mn_invalidate_lock);
  #else
  	kvm_arch_flush_shadow_all(kvm);
  #endif
@@ -1333,9 +1315,22 @@ static struct kvm_memslots *install_new_memslots(struct kvm *kvm,
  	WARN_ON(gen & KVM_MEMSLOT_GEN_UPDATE_IN_PROGRESS);
  	slots->generation = gen | KVM_MEMSLOT_GEN_UPDATE_IN_PROGRESS;
  
-	down_write(&kvm->mmu_notifier_slots_lock);
+	/*
+	 * This cannot be an rwsem because the MMU notifier must not run
+	 * inside the critical section, which cannot be excluded with a
+	 * sleeping rwsem.
+	 */
+	spin_lock(&kvm->mn_invalidate_lock);
+	prepare_to_rcuwait(&kvm->mn_memslots_update_rcuwait);
+	while (kvm->mn_active_invalidate_count) {
+		set_current_state(TASK_UNINTERRUPTIBLE);
+		spin_unlock(&kvm->mn_invalidate_lock);
+		schedule();
+		spin_lock(&kvm->mn_invalidate_lock);
+	}
+	finish_rcuwait(&kvm->mn_memslots_update_rcuwait);
  	rcu_assign_pointer(kvm->memslots[as_id], slots);
-	up_write(&kvm->mmu_notifier_slots_lock);
+	spin_unlock(&kvm->mn_invalidate_lock);
  
  	synchronize_srcu_expedited(&kvm->srcu);
  
-- 
2.26.2

