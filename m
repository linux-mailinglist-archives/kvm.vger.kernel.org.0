Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E10A2909FD
	for <lists+kvm@lfdr.de>; Fri, 16 Oct 2020 18:50:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2410887AbgJPQun (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Oct 2020 12:50:43 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:20863 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2410877AbgJPQun (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 16 Oct 2020 12:50:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602867041;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=e/SbRCVepdQHgx0PPvFLUqgTx0YaGbhGi4UR5HEZ070=;
        b=XMLHLyin1ooLHb9U7Fg6Q78KSp1IyxNG8mbIMKmLq97SYFQ5HgCWABwCVcxhshkJV2GHc+
        xk1VrojQ2XA3n+1PhTy3KGov7GhVfUOvXH/eLF/gCSsUCyUmRSTCt1xnMnme0SjuCYN5gi
        FXj9ko+PVqDPn0bjxRscN0d8vcQ0YpI=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-290-ThR6W4LSOSyvIIKeBPb3gA-1; Fri, 16 Oct 2020 12:50:40 -0400
X-MC-Unique: ThR6W4LSOSyvIIKeBPb3gA-1
Received: by mail-wr1-f70.google.com with SMTP id i1so1719291wrb.18
        for <kvm@vger.kernel.org>; Fri, 16 Oct 2020 09:50:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=e/SbRCVepdQHgx0PPvFLUqgTx0YaGbhGi4UR5HEZ070=;
        b=lsksZ9FjnoMnh5jiT3lQVJSwSeBbiVs93cSWkeckv2n++wHjZrDnEi5lX8il/MmYzF
         nQ1ZIhta+U85Ao4NYz8TSkLp5W4v8UKTpBz78VQsYxSqXaaJKNeoWXLL7dalFNexnETu
         q7RuzlrtGbfUpWYgcdwvhrK7T6BDWsvWc1WrE6KLU1Jwq33U7/2LBRoZxmLmzCBJd8cD
         nP19NXIwQzi33ydQRgNTC4nPBR2OgIOX0q8Hea+md2BZe1DIYy7CJs1wQgMAQGskWa/I
         tH9oxv+yBbfAz+Fzd+a80y80Tcwqun21Jc9/gKAEqPjVDlgZgtgtyberBU+niFbJnADM
         jQIQ==
X-Gm-Message-State: AOAM531qNzn5KdkdIYZMl9aqnaUwHIndmaAUtuOMuScntXrXqrd49IP+
        qYkoLW+bODJ7DfkLzCP8V5pal23oRR6ug454dbNwAbnB02Xb3KzhmiiIuRYaFUdUCL9gepcmg8I
        iSS+kdMkZsaOQ
X-Received: by 2002:adf:8462:: with SMTP id 89mr4838900wrf.389.1602867037701;
        Fri, 16 Oct 2020 09:50:37 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyrAt699f8g95/iijAhCiVcXOtOL9umsqKsfBeEXJsqDEPn8bEBcJQ5gT700mMk8p7ycuhh3Q==
X-Received: by 2002:adf:8462:: with SMTP id 89mr4838872wrf.389.1602867037423;
        Fri, 16 Oct 2020 09:50:37 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:4e8a:ee8e:6ed5:4bc3? ([2001:b07:6468:f312:4e8a:ee8e:6ed5:4bc3])
        by smtp.gmail.com with ESMTPSA id y190sm3696534wmc.27.2020.10.16.09.50.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Oct 2020 09:50:36 -0700 (PDT)
Subject: Re: [PATCH v2 00/20] Introduce the TDP MMU
To:     Ben Gardon <bgardon@google.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Cannon Matthews <cannonmatthews@google.com>,
        Peter Xu <peterx@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Peter Shier <pshier@google.com>,
        Peter Feiner <pfeiner@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>
References: <20201014182700.2888246-1-bgardon@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <f19b7f9c-ff73-c2d2-19f9-173dc8a673c3@redhat.com>
Date:   Fri, 16 Oct 2020 18:50:35 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20201014182700.2888246-1-bgardon@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/10/20 20:26, Ben Gardon wrote:
>  arch/x86/include/asm/kvm_host.h |   14 +
>  arch/x86/kvm/Makefile           |    3 +-
>  arch/x86/kvm/mmu/mmu.c          |  487 +++++++------
>  arch/x86/kvm/mmu/mmu_internal.h |  242 +++++++
>  arch/x86/kvm/mmu/paging_tmpl.h  |    3 +-
>  arch/x86/kvm/mmu/tdp_iter.c     |  181 +++++
>  arch/x86/kvm/mmu/tdp_iter.h     |   60 ++
>  arch/x86/kvm/mmu/tdp_mmu.c      | 1154 +++++++++++++++++++++++++++++++
>  arch/x86/kvm/mmu/tdp_mmu.h      |   48 ++
>  include/linux/kvm_host.h        |    2 +
>  virt/kvm/kvm_main.c             |   12 +-
>  11 files changed, 1944 insertions(+), 262 deletions(-)
>  create mode 100644 arch/x86/kvm/mmu/tdp_iter.c
>  create mode 100644 arch/x86/kvm/mmu/tdp_iter.h
>  create mode 100644 arch/x86/kvm/mmu/tdp_mmu.c
>  create mode 100644 arch/x86/kvm/mmu/tdp_mmu.h
> 

My implementation of tdp_iter_set_spte was completely different, but
of course that's not an issue; I would still like to understand and
comment on why the bool arguments to __tdp_mmu_set_spte are needed.

Apart from splitting tdp_mmu_iter_flush_cond_resched from
tdp_mmu_iter_cond_resched, my remaining changes on top are pretty
small and mostly cosmetic.  I'll give it another go next week
and send it Linus's way if everything's all right.

Paolo

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index f8525c89fc95..baf260421a56 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -7,20 +7,15 @@
 #include "tdp_mmu.h"
 #include "spte.h"
 
+#ifdef CONFIG_X86_64
 static bool __read_mostly tdp_mmu_enabled = false;
+module_param_named(tdp_mmu, tdp_mmu_enabled, bool, 0644);
+#endif
 
 static bool is_tdp_mmu_enabled(void)
 {
 #ifdef CONFIG_X86_64
-	if (!READ_ONCE(tdp_mmu_enabled))
-		return false;
-
-	if (WARN_ONCE(!tdp_enabled,
-		      "Creating a VM with TDP MMU enabled requires TDP."))
-		return false;
-
-	return true;
-
+	return tdp_enabled && READ_ONCE(tdp_mmu_enabled);
 #else
 	return false;
 #endif /* CONFIG_X86_64 */
@@ -277,8 +277,8 @@ static void __handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
 			unaccount_huge_nx_page(kvm, sp);
 
 		for (i = 0; i < PT64_ENT_PER_PAGE; i++) {
-			old_child_spte = *(pt + i);
-			*(pt + i) = 0;
+			old_child_spte = READ_ONCE(*(pt + i));
+			WRITE_ONCE(*(pt + i), 0);
 			handle_changed_spte(kvm, as_id,
 				gfn + (i * KVM_PAGES_PER_HPAGE(level - 1)),
 				old_child_spte, 0, level - 1);
@@ -309,7 +309,7 @@ static inline void __tdp_mmu_set_spte(struct kvm *kvm, struct tdp_iter *iter,
 	struct kvm_mmu_page *root = sptep_to_sp(root_pt);
 	int as_id = kvm_mmu_page_as_id(root);
 
-	*iter->sptep = new_spte;
+	WRITE_ONCE(*iter->sptep, new_spte);
 
 	__handle_changed_spte(kvm, as_id, iter->gfn, iter->old_spte, new_spte,
 			      iter->level);
@@ -361,16 +361,28 @@ static inline void tdp_mmu_set_spte_no_dirty_log(struct kvm *kvm,
 	for_each_tdp_pte(_iter, __va(_mmu->root_hpa),		\
 			 _mmu->shadow_root_level, _start, _end)
 
-static bool tdp_mmu_iter_cond_resched(struct kvm *kvm, struct tdp_iter *iter)
+/*
+ * Flush the TLB if the process should drop kvm->mmu_lock.
+ * Return whether the caller still needs to flush the tlb.
+ */
+static bool tdp_mmu_iter_flush_cond_resched(struct kvm *kvm, struct tdp_iter *iter)
 {
 	if (need_resched() || spin_needbreak(&kvm->mmu_lock)) {
 		kvm_flush_remote_tlbs(kvm);
 		cond_resched_lock(&kvm->mmu_lock);
 		tdp_iter_refresh_walk(iter);
+		return false;
+	} else {
 		return true;
 	}
+}
 
-	return false;
+static void tdp_mmu_iter_cond_resched(struct kvm *kvm, struct tdp_iter *iter)
+{
+	if (need_resched() || spin_needbreak(&kvm->mmu_lock)) {
+		cond_resched_lock(&kvm->mmu_lock);
+		tdp_iter_refresh_walk(iter);
+	}
 }
 
 /*
@@ -407,7 +419,7 @@ static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 		tdp_mmu_set_spte(kvm, &iter, 0);
 
 		if (can_yield)
-			flush_needed = !tdp_mmu_iter_cond_resched(kvm, &iter);
+			flush_needed = tdp_mmu_iter_flush_cond_resched(kvm, &iter);
 		else
 			flush_needed = true;
 	}
@@ -479,7 +479,10 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu, int write,
 					 map_writable, !shadow_accessed_mask,
 					 &new_spte);
 
-	tdp_mmu_set_spte(vcpu->kvm, iter, new_spte);
+	if (new_spte == iter->old_spte)
+		ret = RET_PF_SPURIOUS;
+	else
+		tdp_mmu_set_spte(vcpu->kvm, iter, new_spte);
 
 	/*
 	 * If the page fault was caused by a write but the page is write
@@ -496,7 +496,7 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu, int write,
 	}
 
 	/* If a MMIO SPTE is installed, the MMIO will need to be emulated. */
-	if (unlikely(is_mmio_spte(new_spte)))
+	else if (unlikely(is_mmio_spte(new_spte)))
 		ret = RET_PF_EMULATE;
 
 	trace_kvm_mmu_set_spte(iter->level, iter->gfn, iter->sptep);
@@ -528,8 +528,10 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 	int level;
 	int req_level;
 
-	BUG_ON(!VALID_PAGE(vcpu->arch.mmu->root_hpa));
-	BUG_ON(!is_tdp_mmu_root(vcpu->kvm, vcpu->arch.mmu->root_hpa));
+	if (WARN_ON(!VALID_PAGE(vcpu->arch.mmu->root_hpa)))
+		return RET_PF_ENTRY;
+	if (WARN_ON(!is_tdp_mmu_root(vcpu->kvm, vcpu->arch.mmu->root_hpa)))
+		return RET_PF_ENTRY;
 
 	level = kvm_mmu_hugepage_adjust(vcpu, gfn, max_level, &pfn,
 					huge_page_disallowed, &req_level);
@@ -579,7 +581,8 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 		}
 	}
 
-	BUG_ON(iter.level != level);
+	if (WARN_ON(iter.level != level))
+		return RET_PF_RETRY;
 
 	ret = tdp_mmu_map_handle_target_level(vcpu, write, map_writable, &iter,
 					      pfn, prefault);
@@ -817,9 +829,8 @@ bool kvm_tdp_mmu_wrprot_slot(struct kvm *kvm, struct kvm_memory_slot *slot,
 		 */
 		kvm_mmu_get_root(kvm, root);
 
-		spte_set = wrprot_gfn_range(kvm, root, slot->base_gfn,
-				slot->base_gfn + slot->npages, min_level) ||
-			   spte_set;
+		spte_set |= wrprot_gfn_range(kvm, root, slot->base_gfn,
+			     slot->base_gfn + slot->npages, min_level);
 
 		kvm_mmu_put_root(kvm, root);
 	}
@@ -886,8 +897,8 @@ bool kvm_tdp_mmu_clear_dirty_slot(struct kvm *kvm, struct kvm_memory_slot *slot)
 		 */
 		kvm_mmu_get_root(kvm, root);
 
-		spte_set = clear_dirty_gfn_range(kvm, root, slot->base_gfn,
-				slot->base_gfn + slot->npages) || spte_set;
+		spte_set |= clear_dirty_gfn_range(kvm, root, slot->base_gfn,
+				slot->base_gfn + slot->npages);
 
 		kvm_mmu_put_root(kvm, root);
 	}
@@ -1009,8 +1020,8 @@ bool kvm_tdp_mmu_slot_set_dirty(struct kvm *kvm, struct kvm_memory_slot *slot)
 		 */
 		kvm_mmu_get_root(kvm, root);
 
-		spte_set = set_dirty_gfn_range(kvm, root, slot->base_gfn,
-				slot->base_gfn + slot->npages) || spte_set;
+		spte_set |= set_dirty_gfn_range(kvm, root, slot->base_gfn,
+				slot->base_gfn + slot->npages);
 
 		kvm_mmu_put_root(kvm, root);
 	}
@@ -1042,9 +1053,9 @@ static void zap_collapsible_spte_range(struct kvm *kvm,
 			continue;
 
 		tdp_mmu_set_spte(kvm, &iter, 0);
-		spte_set = true;
 
-		spte_set = !tdp_mmu_iter_cond_resched(kvm, &iter);
+		spte_set = tdp_mmu_iter_flush_cond_resched(kvm, &iter);
 	}
 
 	if (spte_set)

