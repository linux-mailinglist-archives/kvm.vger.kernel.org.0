Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C3816D100B
	for <lists+kvm@lfdr.de>; Thu, 30 Mar 2023 22:33:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229685AbjC3UdJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Mar 2023 16:33:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbjC3UdI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Mar 2023 16:33:08 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C4CFC648
        for <kvm@vger.kernel.org>; Thu, 30 Mar 2023 13:33:07 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id nm11-20020a17090b19cb00b0023d0c90d851so6300377pjb.1
        for <kvm@vger.kernel.org>; Thu, 30 Mar 2023 13:33:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680208386;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=j0KxeUYrlcnOXoVGMqfPusW48UEFM3I6i44+5GKiP4k=;
        b=ozXPYm0pUtiSzC1+TlAKp8VYRdh8tFa1cFXQCToDZR8d4rFEg+AvV496eKlBbsX8CP
         hA2JszZJrDlUF3s9kvnpqBMFjmTOzp9Oa+2wRkrQfUGBotgcJL9qdn5fLw362jqVikkI
         sQJEDcsgZEOTtKw/rNazT2+IDkfVf00THFbz13CNNannpGI97+6+yvgB5SILsuqX4ZtL
         nOh9KNnp7rKQywGX1l6I+VeyjdncKQgK/M3+2T8nSHeS0Hj0Wk29AFncOKnhm6cD+Up2
         s9pxSrJhhYUhokVJhY+2Z18dZVq2E7K9WVAPEx3A7QIMbCMpsa8+1xnSRJmzM35Si23i
         xerg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680208386;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=j0KxeUYrlcnOXoVGMqfPusW48UEFM3I6i44+5GKiP4k=;
        b=r77iVNJ3ZfCDhJGgtxug40oVSaN1IWJDpRWJ+4KUYmqseoNRBevZ+xG/JIgZV3CLFu
         2TT4T6D18ZJKZDT3/8qcS7w/5FZnS4lsEuAkTB9JNyEaMMRdaGz5dEbkqADO0H6Sftqi
         Q7cpz7Bwl6lLGMJJ342EFPjEhRnlRLLUJV8JrljyaIpI7PSojJ8nFOHyNO9/w6jySYwj
         bmNtwm3H2v+PorY/wITqJvejqhvkYuaZ757hdOFUQdUKzFX8md9s3/jaDh/J8rwImRhV
         cMaxXfU86P5s9Pm8Jg31ig0mgHnh6k62EDYGyMydHPI+Ne9T/qiksbAEg0EzoGeDPPzl
         55TA==
X-Gm-Message-State: AAQBX9f14QCP81q+X7RxjAdawveZ+6eOKRFc/g/g43ihjc/WjZYfVwEd
        SMdmteEwOC4d8k/ek3YjY2Ys6pkk2dQ=
X-Google-Smtp-Source: AKy350ayuVHnupL82ye1zRenvDCLocpfZM9UN5K9MlRtz3hCARp/0SdJxIH5NDMraNB8t0UawE6qNK0hhUo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:678e:b0:237:2516:f76a with SMTP id
 o14-20020a17090a678e00b002372516f76amr7451285pjj.2.1680208386638; Thu, 30 Mar
 2023 13:33:06 -0700 (PDT)
Date:   Thu, 30 Mar 2023 13:33:05 -0700
In-Reply-To: <ZCXDAiUOnsL3fRBj@google.com>
Mime-Version: 1.0
References: <20230322013731.102955-1-minipli@grsecurity.net>
 <20230322013731.102955-7-minipli@grsecurity.net> <677169b4-051f-fcae-756b-9a3e1bb9f8fe@grsecurity.net>
 <ZCXDAiUOnsL3fRBj@google.com>
Message-ID: <ZCXyAcTd8NX4Lteq@google.com>
Subject: Re: [PATCH v4 6/6] KVM: VMX: Make CR0.WP a guest owned bit
From:   Sean Christopherson <seanjc@google.com>
To:     Mathias Krause <minipli@grsecurity.net>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 30, 2023, Sean Christopherson wrote:
> On Thu, Mar 30, 2023, Mathias Krause wrote:
> > On 22.03.23 02:37, Mathias Krause wrote:
> > I'm leaning to make CR0.WP guest owned only iff we're running on bare
> > metal or the VMM is KVM to not play whack-a-mole for all the VMMs that
> > might have similar bugs. (Will try to test a few others here as well.)
> > However, that would prevent them from getting the performance gain, so
> > I'd rather have this fixed / worked around in KVM instead.
> 
> Before we start putting bandaids on this, let's (a) confirm this appears to be
> an issue with ESXi and (b) pull in VMware folks to get their input.
> 
> > Any ideas how to investigate this further?
> 
> Does the host in question support UMIP?
> 
> Can you capture a tracepoint log from L1 to verify that L1 KVM is _not_ injecting
> any kind of exception?  E.g. to get the KVM kitchen sink:
> 
>   echo 1 > /sys/kernel/debug/tracing/tracing_on
>   echo 1 > /sys/kernel/debug/tracing/events/kvm/enable
> 
>   cat /sys/kernel/debug/tracing/trace > log
> 
> Or if that's too noisy, a more targeted trace (exception injection + emulation)
> woud be:
> 
>   echo 1 > /sys/kernel/debug/tracing/tracing_on
> 
>   echo 1 > /sys/kernel/debug/tracing/events/kvm/kvm_emulate_insn/enable
>   echo 1 > /sys/kernel/debug/tracing/events/kvm/kvm_inj_exception/enable
>   echo 1 > /sys/kernel/debug/tracing/events/kvm/kvm_entry/enable
>   echo 1 > /sys/kernel/debug/tracing/events/kvm/kvm_exit/enable

Duh, this is likely a KVM bug.  I expect the issue will go away if you revert

  fb509f76acc8 ("KVM: VMX: Make CR0.WP a guest owned bit")

KVM doesn't consume CR0.WP for _its_ MMU, but it does consume CR0.WP for the
guest walker.  By passing through CR0.WP, toggling only CR0.WP will not trap
(obviously) and thus won't run through kvm_post_set_cr0(), thus resulting in stle
information due to not invoking kvm_init_mmu().

I'm preetty sure I even called that we needed to refresh the permissions, but then
obviously forgot to actually make that happen.

I believe this will remedy the issue.  If it does, I'll post a proper patch
(likely won't be until next week).  Compile tested only.

---
 arch/x86/kvm/mmu.h     |  8 +++++++-
 arch/x86/kvm/mmu/mmu.c | 14 ++++++++++++++
 2 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 89f532516a45..4a303aa735dd 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -113,6 +113,7 @@ void kvm_init_shadow_ept_mmu(struct kvm_vcpu *vcpu, bool execonly,
 bool kvm_can_do_async_pf(struct kvm_vcpu *vcpu);
 int kvm_handle_page_fault(struct kvm_vcpu *vcpu, u64 error_code,
 				u64 fault_address, char *insn, int insn_len);
+void kvm_mmu_refresh_passthrough_bits(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu);
 
 int kvm_mmu_load(struct kvm_vcpu *vcpu);
 void kvm_mmu_unload(struct kvm_vcpu *vcpu);
@@ -184,8 +185,13 @@ static inline u8 permission_fault(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 	u64 implicit_access = access & PFERR_IMPLICIT_ACCESS;
 	bool not_smap = ((rflags & X86_EFLAGS_AC) | implicit_access) == X86_EFLAGS_AC;
 	int index = (pfec + (not_smap << PFERR_RSVD_BIT)) >> 1;
-	bool fault = (mmu->permissions[index] >> pte_access) & 1;
 	u32 errcode = PFERR_PRESENT_MASK;
+	bool fault;
+
+	if (tdp_enabled)
+		kvm_mmu_refresh_passthrough_bits(vcpu, mmu);
+
+	fault = (mmu->permissions[index] >> pte_access) & 1;
 
 	WARN_ON(pfec & (PFERR_PK_MASK | PFERR_RSVD_MASK));
 	if (unlikely(mmu->pkru_mask)) {
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 4c874d4ec68f..2a63b5725f36 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5186,6 +5186,20 @@ static union kvm_cpu_role kvm_calc_cpu_role(struct kvm_vcpu *vcpu,
 	return role;
 }
 
+void kvm_mmu_refresh_passthrough_bits(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu)
+{
+	const bool cr0_wp = kvm_is_cr0_bit_set(vcpu, X86_CR0_WP);
+
+	BUILD_BUG_ON((KVM_MMU_CR0_ROLE_BITS & KVM_POSSIBLE_CR0_GUEST_BITS) != X86_CR0_WP);
+	BUILD_BUG_ON((KVM_MMU_CR4_ROLE_BITS & KVM_POSSIBLE_CR4_GUEST_BITS));
+
+	if (is_cr0_wp(mmu) == cr0_wp)
+		return;
+
+	mmu->cpu_role.base.cr0_wp = cr0_wp;
+	reset_guest_paging_metadata(vcpu, mmu);
+}
+
 static inline int kvm_mmu_get_tdp_level(struct kvm_vcpu *vcpu)
 {
 	/* tdp_root_level is architecture forced level, use it if nonzero */

base-commit: 27d6845d258b67f4eb3debe062b7dacc67e0c393
-- 


