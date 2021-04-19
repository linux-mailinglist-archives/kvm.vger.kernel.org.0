Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14431364541
	for <lists+kvm@lfdr.de>; Mon, 19 Apr 2021 15:50:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239999AbhDSNvJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Apr 2021 09:51:09 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:52523 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238497AbhDSNvD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 19 Apr 2021 09:51:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618840232;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3mWWrs07VeyhsaVD9xqLJ/6yk16w935A3cPLp1luCFU=;
        b=TQg8BjeU2vk6nJry0VFpLp+Am/XdkDw7LRTgmH1InELs+3wCj96PVA3WE6Xzkq8O1pq2GJ
        8HvtLdsYKwIYqP5O8NMulRv3CQ9DyYF56oZfSiS82oIhpdxIRSpvAnnhkQJYXzE9dFEtfS
        ZXysa0Vyg/Ywgf/NnuNjowUfDLMXBOE=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-557-zZOgVYzgP5yjVO7wnAuTng-1; Mon, 19 Apr 2021 09:50:28 -0400
X-MC-Unique: zZOgVYzgP5yjVO7wnAuTng-1
Received: by mail-ed1-f72.google.com with SMTP id h13-20020a05640250cdb02903790a9c55acso11207858edb.4
        for <kvm@vger.kernel.org>; Mon, 19 Apr 2021 06:50:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3mWWrs07VeyhsaVD9xqLJ/6yk16w935A3cPLp1luCFU=;
        b=CrjfoAL+hc/HzmjrxpOfrPnUmvJSeuLCYg1OWN5UJlwaavtEP9lN6nrmW4is93rBwD
         vs7nvHrK5+gBVAYx35yDTdx75okDTkoU1GvlGdpaCWiY99+EzYfQ+MOcOf76fT7oaCvN
         wShRA57Kiol2TIJhr3gTbY1vG7mp9A8+NA01Ww4bmPcKWDPl8i8y8EdpDc8tHEGA/XqR
         2uc6WFZoUczL4qXkGsfTDHU22tS5p6syarARnz2cMq4/zOlhVD718XCVz5nwDu6cPuOJ
         3sbnXUfiap5kekZg2tZancaWMMAcntbV+waByqvEv66sZj8/rqP7NgVDZ4IWxIMR1DJg
         f27g==
X-Gm-Message-State: AOAM531BFkHyBZZa5ND0p1RGkeu13ciTItHy5lV0csuHzB5wSLOBbGDF
        Y0/Y6Rt+/KWd0F9s9O75xwDicELvlTIXW/Nt1lMVh6qpuTbmIJ3e+pDxf5A2HtTdCoCaVd9dpLU
        Vu/76jrWfi3s9
X-Received: by 2002:a05:6402:2794:: with SMTP id b20mr8093108ede.48.1618840227377;
        Mon, 19 Apr 2021 06:50:27 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxQCaelkV2XL8Vc+Z3L0QFp3k/2BYZeNmoNVKV3upxEGfeYl9ST9RLvoIxzfo1AcRAtj73fWA==
X-Received: by 2002:a05:6402:2794:: with SMTP id b20mr8093080ede.48.1618840227102;
        Mon, 19 Apr 2021 06:50:27 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id 16sm10597529ejw.0.2021.04.19.06.50.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Apr 2021 06:50:26 -0700 (PDT)
To:     Wanpeng Li <kernellwp@gmail.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Marc Zyngier <maz@kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ben Gardon <bgardon@google.com>
References: <20210402005658.3024832-1-seanjc@google.com>
 <20210402005658.3024832-10-seanjc@google.com>
 <CANRm+Cwt9Xs=13r9E4YWOhcE6oEJXmVrkKrv_wQ5jMUkY8+Stw@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2 09/10] KVM: Don't take mmu_lock for range invalidation
 unless necessary
Message-ID: <2a7670e4-94c0-9f35-74de-a7d5b1504ced@redhat.com>
Date:   Mon, 19 Apr 2021 15:50:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <CANRm+Cwt9Xs=13r9E4YWOhcE6oEJXmVrkKrv_wQ5jMUkY8+Stw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19/04/21 10:49, Wanpeng Li wrote:
> I saw this splatting:
> 
>   ======================================================
>   WARNING: possible circular locking dependency detected
>   5.12.0-rc3+ #6 Tainted: G           OE
>   ------------------------------------------------------
>   qemu-system-x86/3069 is trying to acquire lock:
>   ffffffff9c775ca0 (mmu_notifier_invalidate_range_start){+.+.}-{0:0},
> at: __mmu_notifier_invalidate_range_end+0x5/0x190
> 
>   but task is already holding lock:
>   ffffaff7410a9160 (&kvm->mmu_notifier_slots_lock){.+.+}-{3:3}, at:
> kvm_mmu_notifier_invalidate_range_start+0x36d/0x4f0 [kvm]

I guess it is possible to open-code the wait using a readers count and a
spinlock (see patch after signature).  This allows including the
rcu_assign_pointer in the same critical section that checks the number
of readers.  Also on the plus side, the init_rwsem() is replaced by
slightly nicer code.

IIUC this could be extended to non-sleeping invalidations too, but I
am not really sure about that.

There are some issues with the patch though:

- I am not sure if this should be a raw spin lock to avoid the same issue
on PREEMPT_RT kernel.  That said the critical section is so tiny that using
a raw spin lock may make sense anyway

- this loses the rwsem fairness.  On the other hand, mm/mmu_notifier.c's
own interval-tree-based filter is also using a similar mechanism that is
likewise not fair, so it should be okay.

Any opinions?  For now I placed the change below in kvm/queue, but I'm
leaning towards delaying this optimization to the next merge window.

Paolo

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
index 76b340dd6981..44a4a0c5148a 100644
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
@@ -662,7 +666,7 @@ static inline struct kvm_memslots *__kvm_memslots(struct kvm *kvm, int as_id)
  	as_id = array_index_nospec(as_id, KVM_ADDRESS_SPACE_NUM);
  	return srcu_dereference_check(kvm->memslots[as_id], &kvm->srcu,
  				      lockdep_is_held(&kvm->slots_lock) ||
-				      lockdep_is_held(&kvm->mmu_notifier_slots_lock) ||
+				      READ_ONCE(kvm->mn_active_invalidate_count) ||
  				      !refcount_read(&kvm->users_count));
  }
  
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index ff9e95eb6960..cdaa1841e725 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -624,7 +624,7 @@ static void kvm_mmu_notifier_change_pte(struct mmu_notifier *mn,
  	 * otherwise, mmu_notifier_count is incremented unconditionally.
  	 */
  	if (!kvm->mmu_notifier_count) {
-		lockdep_assert_held(&kvm->mmu_notifier_slots_lock);
+		WARN_ON(!READ_ONCE(kvm->mn_active_invalidate_count));
  		return;
  	}
  
@@ -689,10 +689,13 @@ static int kvm_mmu_notifier_invalidate_range_start(struct mmu_notifier *mn,
  	 * The complexity required to handle conditional locking for this case
  	 * is not worth the marginal benefits, the VM is likely doomed anyways.
  	 *
-	 * Pairs with the up_read in range_end().
+	 * Pairs with the decrement in range_end().
  	 */
-	if (blockable)
-		down_read(&kvm->mmu_notifier_slots_lock);
+	if (blockable) {
+		spin_lock(&kvm->mn_invalidate_lock);
+		kvm->mn_active_invalidate_count++;
+		spin_unlock(&kvm->mn_invalidate_lock);
+	}
  
  	__kvm_handle_hva_range(kvm, &hva_range);
  
@@ -735,9 +738,20 @@ static void kvm_mmu_notifier_invalidate_range_end(struct mmu_notifier *mn,
  
  	__kvm_handle_hva_range(kvm, &hva_range);
  
-	/* Pairs with the down_read in range_start(). */
-	if (blockable)
-		up_read(&kvm->mmu_notifier_slots_lock);
+	/* Pairs with the increment in range_start(). */
+	if (blockable) {
+		bool wake;
+		spin_lock(&kvm->mn_invalidate_lock);
+		wake = (--kvm->mn_active_invalidate_count == 0);
+		spin_unlock(&kvm->mn_invalidate_lock);
+
+		/*
+		 * There can only be one waiter, since the wait happens under
+		 * slots_lock.
+		 */
+		if (wake)
+			rcuwait_wake_up(&kvm->mn_memslots_update_rcuwait);
+	}
  
  	BUG_ON(kvm->mmu_notifier_count < 0);
  }
@@ -951,7 +965,9 @@ static struct kvm *kvm_create_vm(unsigned long type)
  	mutex_init(&kvm->lock);
  	mutex_init(&kvm->irq_lock);
  	mutex_init(&kvm->slots_lock);
-	init_rwsem(&kvm->mmu_notifier_slots_lock);
+	spin_lock_init(&kvm->mn_invalidate_lock);
+	rcuwait_init(&kvm->mn_memslots_update_rcuwait);
+
  	INIT_LIST_HEAD(&kvm->devices);
  
  	BUILD_BUG_ON(KVM_MEM_SLOTS_NUM > SHRT_MAX);
@@ -1073,15 +1089,17 @@ static void kvm_destroy_vm(struct kvm *kvm)
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
@@ -1333,9 +1351,22 @@ static struct kvm_memslots *install_new_memslots(struct kvm *kvm,
  	WARN_ON(gen & KVM_MEMSLOT_GEN_UPDATE_IN_PROGRESS);
  	slots->generation = gen | KVM_MEMSLOT_GEN_UPDATE_IN_PROGRESS;
  
-	down_write(&kvm->mmu_notifier_slots_lock);
+	/*
+	 * This cannot be an rwsem because the MMU notifier must not run
+	 * inside the critical section.  A sleeping rwsem cannot exclude
+	 * that.
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
  

