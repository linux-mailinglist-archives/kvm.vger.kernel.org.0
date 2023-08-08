Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49D25774A70
	for <lists+kvm@lfdr.de>; Tue,  8 Aug 2023 22:29:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231343AbjHHU3G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Aug 2023 16:29:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230401AbjHHU2z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Aug 2023 16:28:55 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEB20157923
        for <kvm@vger.kernel.org>; Tue,  8 Aug 2023 10:07:37 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id 41be03b00d2f7-56385c43eaeso36595a12.1
        for <kvm@vger.kernel.org>; Tue, 08 Aug 2023 10:07:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691514457; x=1692119257;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=FYydZ/WC/X7PBz3rGSs121PfBH3fb5ehFOJQFZBx3p4=;
        b=GV0T5JGICTxBHQToBy1PfSyoy2i4bM1zH73FdGtuKSDbeUUFxy0mudpUdMA9EPwcN/
         j9JXJzSqXP5zsg/86aZbjj3WK6wE6yNNwTycSPQEiglcligbGzAAlM+yBOTID7rqdjfj
         6Aji/NflE6sHuE7Q7L0y/h/uyQwprnXyF7UHP7SQXMUAqy0cM5MagWJ74MsmFB9uNvz4
         Fhzeb/hC7QxHmzNY8sct7/oI+RxQxXyGdMlFt1HKVaf4LrBL8E5QrHqUnWUbGvMbH5N1
         orjBrAWkw9u53y0m5n5LsKUHYYdC/jL1/eWH2X30bvMRM3MC3nrYUuz3kYjwwZb6Kd5V
         fCJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691514457; x=1692119257;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FYydZ/WC/X7PBz3rGSs121PfBH3fb5ehFOJQFZBx3p4=;
        b=TnxMtC+tQOvcSPJr5TAqEKcjBEY5sO5mb8iWSDg4HCkuZSq/nub8zg2eaD9l6mjGCo
         1caFWeTH39P+tpw3qBOdStIoD3eniIHJ29djCxwHT2R3MtipVvU4THk7KmZP48QIdeRP
         0ZuXs8UJtHW1kbWc9WKxkQs4y9A3mjpjOH04SSbo2DbygteaMn7nhk5K/fIHjZIyZGwq
         +tVC+Taijre9NpDDcsjDJFy/NwgDDaNpCXuD+fwXkLUHl9D3OhU8ikOAbj21+yFulP5N
         2IpbigwOwx6keaEeialbIvjiaRjXqqkMhJCslt3K1uePQDQvzcQEz3G47tQ2OrHDITvp
         029Q==
X-Gm-Message-State: AOJu0YwqnnI7JiqxqBRaNxU/gussNMkGCfpm575DKayXlKxUGLl/8Z2D
        Y8mUxbhtagRkMCu5LU1/yV+IrxwUyrw=
X-Google-Smtp-Source: AGHT+IHKPz9NN9UwaUpEVU90XfLOlmfjcXFMG76C/HmVH7eT9tRDEVaJTacVs/21ngorplmfMSbyl1i9APo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:5264:0:b0:564:4a9e:1b80 with SMTP id
 s36-20020a635264000000b005644a9e1b80mr76736pgl.6.1691514457246; Tue, 08 Aug
 2023 10:07:37 -0700 (PDT)
Date:   Tue, 8 Aug 2023 10:07:35 -0700
In-Reply-To: <CAG+wEg1d7xViMt3HDusmd=a6NArt_iMbxHwJHBcjyc=GntGK2g@mail.gmail.com>
Mime-Version: 1.0
References: <ZHZCEUzr9Ak7rkjG@google.com> <20230721143407.2654728-1-amaan.cheval@gmail.com>
 <ZLrCUkwot/yiVC8T@google.com> <CAG+wEg21f6PPEnP2N7oE=48PBSd_2bHOcRsTy_ZuBpa2=dGuiA@mail.gmail.com>
 <ZMAGuic1viMLtV7h@google.com> <CAG+wEg3X1Tc_PW6E=pLHKFyAfJD0n2n25Fw2JYCuHrfDC_Ph0Q@mail.gmail.com>
 <ZMp3bR2YkK2QGIFH@google.com> <CAG+wEg2x-oGALCwKkHOxcrcdjP6ceU=K52UoQE2ht6ut1O46ug@mail.gmail.com>
 <ZMqX7TJavsx8WEY2@google.com> <CAG+wEg1d7xViMt3HDusmd=a6NArt_iMbxHwJHBcjyc=GntGK2g@mail.gmail.com>
Message-ID: <ZNJ2V2vRXckMwPX2@google.com>
Subject: Re: Deadlock due to EPT_VIOLATION
From:   Sean Christopherson <seanjc@google.com>
To:     Amaan Cheval <amaan.cheval@gmail.com>
Cc:     brak@gameservers.com, kvm@vger.kernel.org
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

On Tue, Aug 08, 2023, Amaan Cheval wrote:
> Hey Sean,
> 
> > If NUMA balancing is going nuclear and constantly zapping PTEs, the resulting
> > mmu_notifier events could theoretically stall a vCPU indefinitely.  The reason I
> > dislike NUMA balancing is that it's all too easy to end up with subtle bugs
> > and/or misconfigured setups where the NUMA balancing logic zaps PTEs/SPTEs without
> > actuablly being able to move the page in the end, i.e. it's (IMO) too easy for
> > NUMA balancing to get false positives when determining whether or not to try and
> > migrate a page.
> 
> What are some situations where it might not be able to move the page in the end?

There's a pretty big list, see the "failure" paths of do_numa_page() and
migrate_misplaced_page().

> > That said, it's definitely very unexpected that NUMA balancing would be zapping
> > SPTEs to the point where a vCPU can't make forward progress.   It's theoretically
> > possible that that's what's happening, but quite unlikely, especially since it
> > sounds like you're seeing issues even with NUMA balancing disabled.
> 
> Yep, we're definitely seeing the issue occur even with numa_balancing
> enabled, but the likelihood of it occurring has significantly dropped since
> we've disabled numa_balancing.

So the fact that this occurs with NUMA balancing disabled means the problem likely
isn't with NUMA balancing itself.  NUMA balancing probably exposes some underlying
issue due to it generating a near-constant stream of mmu_notifier invalidation.

> > More likely is that there is a bug somewhere that results in the mmu_notifier
> > event refcount staying incorrectly eleveated, but that type of bug shouldn't follow
> > the VM across a live migration...
> 
> Good news! We managed to live migrate a guest and that did "fix it".

...

> A colleague also modified a host kernel with KFI (Kernel Function
> Instrumentation) and wrote a kernel module to intercept the vmexit handler,
> handle_ept_violation, and does an EPT walk for each pfn, compared against
> /proc/iomem.
> 
> Assuming the EPT walking code is correct, we see this surprising result of a
> PDPTE's pfn=0:

Not surprising.  The entire EPTE is zero, i.e. has been zapped by KVM.  This is
exactly what is expected.

> Does this seem to indicate an mmu_notifier refcount issue to you, given that
> migration did fix it? Any way to verify?

It doesn't move the needle either way, it just confirms what we already know: the
vCPU is repeatedly taking !PRESENT faults.  The unexpected part is that KVM never
"fixes" the fault and never outright fails.

> We haven't found any guests with `softlockup_panic=1` yet, and since we can't
> reproduce the issue on command ourselves yet, we might have to wait a bit - but
> I imagine that the fact that live migration "fixed" the locked up guest confirms
> that the other guests that didn't get "fixed" were likely softlocked from the
> CPU stalling?

Yes.

> If you have any suggestions on how modifying the host kernel (and then migrating
> a locked up guest to it) or eBPF programs that might help illuminate the issue
> further, let me know!
> 
> Thanks for all your help so far!

Since it sounds like you can test with a custom kernel, try running with this
patch and then enable the kvm_page_fault tracepoint when a vCPU gets stuck.  The
below expands said tracepoint to capture information about mmu_notifiers and
memslots generation.  With luck, it will reveal a smoking gun.

---
 arch/x86/kvm/mmu/mmu.c          | 10 ----------
 arch/x86/kvm/mmu/mmu_internal.h |  2 ++
 arch/x86/kvm/mmu/tdp_mmu.h      | 10 ++++++++++
 arch/x86/kvm/trace.h            | 28 ++++++++++++++++++++++++++--
 4 files changed, 38 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 9e4cd8b4a202..122bfc884293 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2006,16 +2006,6 @@ static bool kvm_mmu_remote_flush_or_zap(struct kvm *kvm,
 	return true;
 }
 
-static bool is_obsolete_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
-{
-	if (sp->role.invalid)
-		return true;
-
-	/* TDP MMU pages do not use the MMU generation. */
-	return !is_tdp_mmu_page(sp) &&
-	       unlikely(sp->mmu_valid_gen != kvm->arch.mmu_valid_gen);
-}
-
 struct mmu_page_path {
 	struct kvm_mmu_page *parent[PT64_ROOT_MAX_LEVEL];
 	unsigned int idx[PT64_ROOT_MAX_LEVEL];
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index f1ef670058e5..cf7ba0abaa8f 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -6,6 +6,8 @@
 #include <linux/kvm_host.h>
 #include <asm/kvm_host.h>
 
+#include "mmu.h"
+
 #ifdef CONFIG_KVM_PROVE_MMU
 #define KVM_MMU_WARN_ON(x) WARN_ON_ONCE(x)
 #else
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index 0a63b1afabd3..a0d7c8acf78f 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -76,4 +76,14 @@ static inline bool is_tdp_mmu_page(struct kvm_mmu_page *sp) { return sp->tdp_mmu
 static inline bool is_tdp_mmu_page(struct kvm_mmu_page *sp) { return false; }
 #endif
 
+static inline bool is_obsolete_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
+{
+	if (sp->role.invalid)
+		return true;
+
+	/* TDP MMU pages do not use the MMU generation. */
+	return !is_tdp_mmu_page(sp) &&
+	       unlikely(sp->mmu_valid_gen != kvm->arch.mmu_valid_gen);
+}
+
 #endif /* __KVM_X86_MMU_TDP_MMU_H */
diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index 83843379813e..ff4a384ab03a 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -8,6 +8,8 @@
 #include <asm/clocksource.h>
 #include <asm/pvclock-abi.h>
 
+#include "mmu/tdp_mmu.h"
+
 #undef TRACE_SYSTEM
 #define TRACE_SYSTEM kvm
 
@@ -405,6 +407,13 @@ TRACE_EVENT(kvm_page_fault,
 		__field(	unsigned long,	guest_rip	)
 		__field(	u64,		fault_address	)
 		__field(	u64,		error_code	)
+		__field(	unsigned long,  mmu_invalidate_seq)
+		__field(	long,  mmu_invalidate_in_progress)
+		__field(	unsigned long,  mmu_invalidate_range_start)
+		__field(	unsigned long,  mmu_invalidate_range_end)
+		__field(	bool,		root_is_valid)
+		__field(	bool,		root_has_sp)
+		__field(	bool,		root_is_obsolete)
 	),
 
 	TP_fast_assign(
@@ -412,11 +421,26 @@ TRACE_EVENT(kvm_page_fault,
 		__entry->guest_rip	= kvm_rip_read(vcpu);
 		__entry->fault_address	= fault_address;
 		__entry->error_code	= error_code;
+		__entry->mmu_invalidate_seq		= vcpu->kvm->mmu_invalidate_seq;
+		__entry->mmu_invalidate_in_progress	= vcpu->kvm->mmu_invalidate_in_progress;
+		__entry->mmu_invalidate_range_start	= vcpu->kvm->mmu_invalidate_range_start;
+		__entry->mmu_invalidate_range_end	= vcpu->kvm->mmu_invalidate_range_end;
+		__entry->root_is_valid			= VALID_PAGE(vcpu->arch.mmu->root.hpa);
+		__entry->root_has_sp			= VALID_PAGE(vcpu->arch.mmu->root.hpa) &&
+							  to_shadow_page(vcpu->arch.mmu->root.hpa);
+		__entry->root_is_obsolete		= VALID_PAGE(vcpu->arch.mmu->root.hpa) &&
+							  to_shadow_page(vcpu->arch.mmu->root.hpa) &&
+							  is_obsolete_sp(vcpu->kvm, to_shadow_page(vcpu->arch.mmu->root.hpa));
 	),
 
-	TP_printk("vcpu %u rip 0x%lx address 0x%016llx error_code 0x%llx",
+	TP_printk("vcpu %u rip 0x%lx address 0x%016llx error_code 0x%llx, seq = 0x%lx, in_prog = 0x%lx, start = 0x%lx, end = 0x%lx, root = %s",
 		  __entry->vcpu_id, __entry->guest_rip,
-		  __entry->fault_address, __entry->error_code)
+		  __entry->fault_address, __entry->error_code,
+		  __entry->mmu_invalidate_seq, __entry->mmu_invalidate_in_progress,
+		  __entry->mmu_invalidate_range_start, __entry->mmu_invalidate_range_end,
+		  !__entry->root_is_valid ? "invalid" :
+		  !__entry->root_has_sp ? "no shadow page" :
+		  __entry->root_is_obsolete ? "obsolete" : "fresh")
 );
 
 /*

base-commit: 240f736891887939571854bd6d734b6c9291f22e
-- 

