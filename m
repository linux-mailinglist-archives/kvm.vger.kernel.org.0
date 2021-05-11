Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0479637B0D7
	for <lists+kvm@lfdr.de>; Tue, 11 May 2021 23:35:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229784AbhEKVgy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 May 2021 17:36:54 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:39562 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229637AbhEKVgx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 11 May 2021 17:36:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620768946;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wh0uuXh5WzZ6XG2NOmnpR3yyPPHJ30noZH9tq5MHmPs=;
        b=e9RdzbOHuGMxEPcqWiNnO5bF+4W7z3ZdHupPjhUakNAoEwlnyrGHwPa2JXnv95qq5mcK7K
        G+S94CqUJfjmU6hlQ8Hd6uCJLVMLvRAx7pnxgX1AnrULTY1wIyywzRRY5JsDJu0qt3j8ho
        hKO9rHQIvVIisd/UtPB42LFvqkoyKXQ=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-499-U2rqLAXJO1KtUcVoLRKGnw-1; Tue, 11 May 2021 17:35:44 -0400
X-MC-Unique: U2rqLAXJO1KtUcVoLRKGnw-1
Received: by mail-qt1-f200.google.com with SMTP id s4-20020ac85cc40000b02901b59d9c0986so13927977qta.19
        for <kvm@vger.kernel.org>; Tue, 11 May 2021 14:35:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wh0uuXh5WzZ6XG2NOmnpR3yyPPHJ30noZH9tq5MHmPs=;
        b=uXWSDFndpEZGss8JzwHw3yv1H/cNH6NUYnC+rLRs/gKmRkaYc9yJvkrB0RpdTsct5J
         ZkpFUdfCO1gcjXS9mgZCtXd2aeJbafZLWq6gWPjH7wjgC2bHW9nTFzV4zJNl4gxzgtoS
         K6KNiReEzsQe2QwSWPP7TK6Y2X4QDwVXl768UXOTl/qnUpQgTZU+EBnxVzvXcSmqO4FI
         GgPeQMHfQbqDUoGIS7m5NDZwM9gJmDidh7yOgY0QZIg2NgHEUmnbmAlG4wu3w54AWhPp
         i0S3Y8cauIweq1+jMez7GjzmuvIklJqYf4LtLQK5X1G5hksA4gRjaI32xCAuezZu02HH
         FduQ==
X-Gm-Message-State: AOAM530oRT33OAQ9h2aRHxwwmgLQ8Sl6g8QE61MGReWGdAzOqHpVHPdh
        eLMB4B5iFZUhWNMLjcRSI2kwjjd90YFs8Tl/MG28wsYQGfvMU9Ic17U/qekPRT+YEtNWEthL6hK
        z185DPnTpX79Q
X-Received: by 2002:ac8:7f41:: with SMTP id g1mr30855797qtk.72.1620768944030;
        Tue, 11 May 2021 14:35:44 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzVgDOGhmBHWZtDuCmNsdzgRoKfsjBpNvKGdExaLkG4tYAwhvEJANjHJ3Eevh/xtGsXw2bAIg==
X-Received: by 2002:ac8:7f41:: with SMTP id g1mr30855777qtk.72.1620768943730;
        Tue, 11 May 2021 14:35:43 -0700 (PDT)
Received: from t490s (bras-base-toroon474qw-grc-72-184-145-4-219.dsl.bell.ca. [184.145.4.219])
        by smtp.gmail.com with ESMTPSA id t5sm14673691qtr.19.2021.05.11.14.35.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 May 2021 14:35:42 -0700 (PDT)
Date:   Tue, 11 May 2021 17:35:41 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Marcelo Tosatti <mtosatti@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>,
        Pei Zhang <pezhang@redhat.com>
Subject: Re: [patch 4/4] KVM: VMX: update vcpu posted-interrupt descriptor
 when assigning device
Message-ID: <YJr4ravpCjz2M4bp@t490s>
References: <20210507130609.269153197@redhat.com>
 <20210507130923.528132061@redhat.com>
 <YJV3P4mFA7pITziM@google.com>
 <YJWVAcIsvCaD7U0C@t490s>
 <20210507220831.GA449495@fuller.cnet>
 <YJqXD5gQCfzO4rT5@t490s>
 <20210511145157.GC124427@fuller.cnet>
 <YJqurM+LiyAY+MPO@t490s>
 <20210511171810.GA162107@fuller.cnet>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="xz9gvtFbz3Pk7/7A"
Content-Disposition: inline
In-Reply-To: <20210511171810.GA162107@fuller.cnet>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--xz9gvtFbz3Pk7/7A
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

On Tue, May 11, 2021 at 02:18:10PM -0300, Marcelo Tosatti wrote:
> On Tue, May 11, 2021 at 12:19:56PM -0400, Peter Xu wrote:
> > On Tue, May 11, 2021 at 11:51:57AM -0300, Marcelo Tosatti wrote:
> > > On Tue, May 11, 2021 at 10:39:11AM -0400, Peter Xu wrote:
> > > > On Fri, May 07, 2021 at 07:08:31PM -0300, Marcelo Tosatti wrote:
> > > > > > Wondering whether we should add a pi_test_on() check in kvm_vcpu_has_events()
> > > > > > somehow, so that even without customized ->vcpu_check_block we should be able
> > > > > > to break the block loop (as kvm_arch_vcpu_runnable will return true properly)?
> > > > > 
> > > > > static int kvm_vcpu_check_block(struct kvm_vcpu *vcpu)
> > > > > {
> > > > >         int ret = -EINTR;
> > > > >         int idx = srcu_read_lock(&vcpu->kvm->srcu);
> > > > > 
> > > > >         if (kvm_arch_vcpu_runnable(vcpu)) {
> > > > >                 kvm_make_request(KVM_REQ_UNHALT, vcpu); <---
> > > > >                 goto out;
> > > > >         }
> > > > > 
> > > > > Don't want to unhalt the vcpu.
> > > > 
> > > > Could you elaborate?  It's not obvious to me why we can't do that if
> > > > pi_test_on() returns true..  we have pending post interrupts anyways, so
> > > > shouldn't we stop halting?  Thanks!
> > > 
> > > pi_test_on() only returns true when an interrupt is signalled by the
> > > device. But the sequence of events is:
> > > 
> > > 
> > > 1. pCPU idles without notification vector configured to wakeup vector.
> > > 
> > > 2. PCI device is hotplugged, assigned device count increases from 0 to 1.
> > > 
> > > <arbitrary amount of time>
> > > 
> > > 3. device generates interrupt, sets ON bit to true in the posted
> > > interrupt descriptor.
> > > 
> > > We want to exit kvm_vcpu_block after 2, but before 3 (where ON bit
> > > is not set).
> > 
> > Ah yes.. thanks.
> > 
> > Besides the current approach, I'm thinking maybe it'll be cleaner/less LOC to
> > define a KVM_REQ_UNBLOCK to replace the pre_block hook (in x86's kvm_host.h):
> > 
> > #define KVM_REQ_UNBLOCK			KVM_ARCH_REQ(31)
> > 
> > We can set it in vmx_pi_start_assignment(), then check+clear it in
> > kvm_vcpu_has_events() (or make it a bool in kvm_vcpu struct?).
> 
> Can't check it in kvm_vcpu_has_events() because that will set
> KVM_REQ_UNHALT (which we don't want).

I thought it was okay to break the guest HLT? As IMHO the guest code should
always be able to re-run the HLT when interrupted?  As IIUC HLT can easily be
interrupted by e.g., SMIs, according to SDM Vol.2.  Not to mention vfio hotplug
should be rare, and we'll only trigger this once for the 1st device.

> 
> I think KVM_REQ_UNBLOCK will add more lines of code.

It's very possible I overlooked something above... but if breaking HLT
unregularly is okay, I attached one patch that is based on your v3 series, just
dropped the vcpu_check_block() but use KVM_REQ_UNBLOCK (no compile test even,
just to satisfy my own curiosity on how many loc we can save.. :), it gives me:

 7 files changed, 5 insertions(+), 41 deletions(-)

But again, I could have missed something...

Thanks,

> 
> > The thing is current vmx_vcpu_check_block() is mostly a sanity check and
> > copy-paste of the pi checks on a few items, so maybe cleaner to use
> > KVM_REQ_UNBLOCK, as it might be reused in the future for re-evaluating of
> > pre-block for similar purpose?
> > 
> > No strong opinion, though.
> 
> Hum... IMHO v3 is quite clean already (although i don't object to your
> suggestion).
> 
> Paolo, what do you think?
> 
> 
> 

-- 
Peter Xu

--xz9gvtFbz3Pk7/7A
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment;
	filename="0001-replace-vcpu_check_block-hook-with-KVM_REQ_UNBLOCK.patch"

From 1131248f3c8f1f2715dd49d439c9fab25b4db9b8 Mon Sep 17 00:00:00 2001
From: Peter Xu <peterx@redhat.com>
Date: Tue, 11 May 2021 17:33:21 -0400
Subject: [PATCH] replace vcpu_check_block() hook with KVM_REQ_UNBLOCK

Signed-off-by: Peter Xu <peterx@redhat.com>
---
 arch/x86/include/asm/kvm-x86-ops.h |  1 -
 arch/x86/include/asm/kvm_host.h    | 12 +-----------
 arch/x86/kvm/svm/svm.c             |  1 -
 arch/x86/kvm/vmx/posted_intr.c     | 27 +--------------------------
 arch/x86/kvm/vmx/posted_intr.h     |  1 -
 arch/x86/kvm/vmx/vmx.c             |  1 -
 arch/x86/kvm/x86.c                 |  3 +++
 7 files changed, 5 insertions(+), 41 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index fc99fb779fd21..e7bef91cee04a 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -98,7 +98,6 @@ KVM_X86_OP_NULL(pre_block)
 KVM_X86_OP_NULL(post_block)
 KVM_X86_OP_NULL(vcpu_blocking)
 KVM_X86_OP_NULL(vcpu_unblocking)
-KVM_X86_OP_NULL(vcpu_check_block)
 KVM_X86_OP_NULL(update_pi_irte)
 KVM_X86_OP_NULL(start_assignment)
 KVM_X86_OP_NULL(apicv_post_state_restore)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 5bf7bd0e59582..74ab042e9b146 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -91,6 +91,7 @@
 #define KVM_REQ_MSR_FILTER_CHANGED	KVM_ARCH_REQ(29)
 #define KVM_REQ_UPDATE_CPU_DIRTY_LOGGING \
 	KVM_ARCH_REQ_FLAGS(30, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
+#define KVM_REQ_UNBLOCK			KVM_ARCH_REQ(31)
 
 #define CR0_RESERVED_BITS                                               \
 	(~(unsigned long)(X86_CR0_PE | X86_CR0_MP | X86_CR0_EM | X86_CR0_TS \
@@ -1350,8 +1351,6 @@ struct kvm_x86_ops {
 	void (*vcpu_blocking)(struct kvm_vcpu *vcpu);
 	void (*vcpu_unblocking)(struct kvm_vcpu *vcpu);
 
-	int (*vcpu_check_block)(struct kvm_vcpu *vcpu);
-
 	int (*update_pi_irte)(struct kvm *kvm, unsigned int host_irq,
 			      uint32_t guest_irq, bool set);
 	void (*start_assignment)(struct kvm *kvm);
@@ -1835,15 +1834,6 @@ static inline bool kvm_irq_is_postable(struct kvm_lapic_irq *irq)
 		irq->delivery_mode == APIC_DM_LOWEST);
 }
 
-#define __KVM_HAVE_ARCH_VCPU_CHECK_BLOCK
-static inline int kvm_arch_vcpu_check_block(struct kvm_vcpu *vcpu)
-{
-	if (kvm_x86_ops.vcpu_check_block)
-		return static_call(kvm_x86_vcpu_check_block)(vcpu);
-
-	return 0;
-}
-
 static inline void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu)
 {
 	static_call_cond(kvm_x86_vcpu_blocking)(vcpu);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index cda5ccb4d9d1b..8b03795cfcd11 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4459,7 +4459,6 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.vcpu_put = svm_vcpu_put,
 	.vcpu_blocking = svm_vcpu_blocking,
 	.vcpu_unblocking = svm_vcpu_unblocking,
-	.vcpu_check_block = NULL,
 
 	.update_exception_bitmap = svm_update_exception_bitmap,
 	.get_msr_feature = svm_get_msr_feature,
diff --git a/arch/x86/kvm/vmx/posted_intr.c b/arch/x86/kvm/vmx/posted_intr.c
index 2d0d009965530..0b74d598ebcbd 100644
--- a/arch/x86/kvm/vmx/posted_intr.c
+++ b/arch/x86/kvm/vmx/posted_intr.c
@@ -203,32 +203,6 @@ void pi_post_block(struct kvm_vcpu *vcpu)
 	local_irq_enable();
 }
 
-/*
- * Bail out of the block loop if the VM has an assigned
- * device, but the blocking vCPU didn't reconfigure the
- * PI.NV to the wakeup vector, i.e. the assigned device
- * came along after the initial check in vcpu_block().
- */
-
-int vmx_vcpu_check_block(struct kvm_vcpu *vcpu)
-{
-	struct pi_desc *pi_desc = vcpu_to_pi_desc(vcpu);
-
-	if (!irq_remapping_cap(IRQ_POSTING_CAP))
-		return 0;
-
-	if (!kvm_vcpu_apicv_active(vcpu))
-		return 0;
-
-	if (!kvm_arch_has_assigned_device(vcpu->kvm))
-		return 0;
-
-	if (pi_desc->nv == POSTED_INTR_WAKEUP_VECTOR)
-		return 0;
-
-	return 1;
-}
-
 /*
  * Handler for POSTED_INTERRUPT_WAKEUP_VECTOR.
  */
@@ -278,6 +252,7 @@ void vmx_pi_start_assignment(struct kvm *kvm)
 		if (!kvm_vcpu_apicv_active(vcpu))
 			continue;
 
+		kvm_make_request(KVM_REQ_UNBLOCK, vcpu);
 		kvm_vcpu_wake_up(vcpu);
 	}
 }
diff --git a/arch/x86/kvm/vmx/posted_intr.h b/arch/x86/kvm/vmx/posted_intr.h
index 2aa082fd1c7ab..7f7b2326caf53 100644
--- a/arch/x86/kvm/vmx/posted_intr.h
+++ b/arch/x86/kvm/vmx/posted_intr.h
@@ -96,6 +96,5 @@ bool pi_has_pending_interrupt(struct kvm_vcpu *vcpu);
 int pi_update_irte(struct kvm *kvm, unsigned int host_irq, uint32_t guest_irq,
 		   bool set);
 void vmx_pi_start_assignment(struct kvm *kvm);
-int vmx_vcpu_check_block(struct kvm_vcpu *vcpu);
 
 #endif /* __KVM_X86_VMX_POSTED_INTR_H */
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index ab68fed8b7e43..639ec3eba9b80 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7716,7 +7716,6 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 
 	.pre_block = vmx_pre_block,
 	.post_block = vmx_post_block,
-	.vcpu_check_block = vmx_vcpu_check_block,
 
 	.pmu_ops = &intel_pmu_ops,
 	.nested_ops = &vmx_nested_ops,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e6fee59b5dab6..739e1bd59e8a9 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11177,6 +11177,9 @@ static inline bool kvm_vcpu_has_events(struct kvm_vcpu *vcpu)
 	     static_call(kvm_x86_smi_allowed)(vcpu, false)))
 		return true;
 
+	if (kvm_check_request(KVM_REQ_UNBLOCK, vcpu))
+		return true;
+
 	if (kvm_arch_interrupt_allowed(vcpu) &&
 	    (kvm_cpu_has_interrupt(vcpu) ||
 	    kvm_guest_apic_has_interrupt(vcpu)))
-- 
2.31.1


--xz9gvtFbz3Pk7/7A--

