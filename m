Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB88B6BBB67
	for <lists+kvm@lfdr.de>; Wed, 15 Mar 2023 18:51:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232056AbjCORvy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Mar 2023 13:51:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232106AbjCORvx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Mar 2023 13:51:53 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 291F1580E4
        for <kvm@vger.kernel.org>; Wed, 15 Mar 2023 10:50:58 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id q8-20020a17090ad38800b0023f116f305bso403868pju.0
        for <kvm@vger.kernel.org>; Wed, 15 Mar 2023 10:50:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678902657;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=j+JfQIVrDBk/J4/7olMX0VBAafz8RG0aOAdc4Cp7D/0=;
        b=PaNpnBsmgKwaooGZy9601b0lB6nymObiTA3y9gjWjxg7m0SGSOr7pKYkdvtZcemYxL
         irinRZ5SfyZWIZbE3ipksDNpVvnP5fox/xvCdwVL2F7IMlxEd7DdVM3nE2B1R8vx7iCG
         xLSsyd75pDLWSJtJxv5A8Lumw5HzNAS6RtB8E+MJhYNqqpA8ShobLpXBeJqRihL3e7mk
         BGYisGCuqsnf7x+By81Vs88+f+p2NWaPvg8Eu8lLmxRCbLxJ3FtfSXm08on7W+RGngm+
         cD/U1boMx89peEsJKMNG9Z+IXW9WgdtQQ0qbfWphqBF0Hg8NhN8Do5UBJGpu793nnHu3
         x6tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678902657;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=j+JfQIVrDBk/J4/7olMX0VBAafz8RG0aOAdc4Cp7D/0=;
        b=z0WZ8TQ/WqVYqQG06fnWasL1Qt/yI0OZf21N7GKbOOFjC7vfXoSVlEnuYoRsxZ+rZ6
         JOoEJ2Me2FNe+wOA/8mhqF8sgCwT7Ua+JlEhDcxC9ofTcOx30Vab6gvpis3VhogZzDoA
         H8VYnIhj0s7zFk4Tn6xEVcEx0zgt3/YL7/gm/5SiyLZzuW+45VSlYqcsdgevFDm+QgDA
         33E2ocwnsW/09ddh4f9Pv69QRBQI1NtTvdAtUUtR33NVx5PUkDfDy0138Gx2KA5v12k9
         F/qI45hQtlIrhm73NXwSVMx35NC9w/esYaFpRaAPvX7fI+Ar+67cOgVHJx8Uw+Z2Ujlv
         QXLA==
X-Gm-Message-State: AO0yUKWPqNypFyqySZ2NTU7F64gFkuUc6MFTqZdPDpImYunpFVxm15k2
        KWB9ac810V8F7w5qPJeX1BRb7mb4FyY=
X-Google-Smtp-Source: AK7set9qSoUMjTcQvj0LH1hlYhp/p2+Ak0KF8J5jHDY+vLoEoGCccXz3Pf0o04H9eTXKqFbro75XXnyBNeg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:896:b0:23f:ebc:6c4f with SMTP id
 bj22-20020a17090b089600b0023f0ebc6c4fmr249388pjb.4.1678902657728; Wed, 15 Mar
 2023 10:50:57 -0700 (PDT)
Date:   Wed, 15 Mar 2023 10:50:56 -0700
In-Reply-To: <CA+wubQBWgz4YAi=T3MV82HrC3=gXSC_yD50ip0=N_x3MnTE1UA@mail.gmail.com>
Mime-Version: 1.0
References: <20230310125718.1442088-1-robert.hu@intel.com> <20230310125718.1442088-2-robert.hu@intel.com>
 <ZAtT5pFPqjM1Ocq0@google.com> <CA+wubQBWgz4YAi=T3MV82HrC3=gXSC_yD50ip0=N_x3MnTE1UA@mail.gmail.com>
Message-ID: <ZBIFgH4YBC71n6KR@google.com>
Subject: Re: [PATCH 1/3] KVM: VMX: Rename vmx_umip_emulated() to cpu_has_vmx_desc()
From:   Sean Christopherson <seanjc@google.com>
To:     Robert Hoo <robert.hoo.linux@gmail.com>
Cc:     Robert Hoo <robert.hu@intel.com>, pbonzini@redhat.com,
        kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Please fix your editor or whatever it is that is resulting your emails being
wrapped at very bizarre boundaries.

On Sat, Mar 11, 2023, Robert Hoo wrote:
> Also, vmx_umip_emulated() == true doesn't necessarily mean, as its name
> indicates, UMIP-being-emulated, e.g. Host has UMIP capability, then UMIP
> isn't emulated though vmx_umip_emulated() indicates true.

True.  I was going to say "there's no perfect solution" since KVM needs to check
both "is UMIP emulated" and "can UMIP be emulated", but that's not actually the
case.  vmx_emulate_umip() _should_ check for native support, as there's no
legitimate use for checking if UMIP _can_ be emulated.

Functionally, this should be a glorified nop, but I agree it's worth changing.
I'll formally post this after testing.

From: Sean Christopherson <seanjc@google.com>
Date: Wed, 15 Mar 2023 10:27:40 -0700
Subject: [PATCH] KVM: VMX: Treat UMIP as emulated if and only if the host
 doesn't have UMIP

Advertise UMIP as emulated if and only if the host doesn't natively
support UMIP, otherwise vmx_umip_emulated() is misleading when the host
_does_ support UMIP.  Of the four users of vmx_umip_emulated(), two
already check for native support, and the logic in vmx_set_cpu_caps() is
relevant if and only if UMIP isn't natively supported as UMIP is set in
KVM's caps by kvm_set_cpu_caps() when UMIP is present in hardware.

That leaves KVM's stuffing of X86_CR4_UMIP into the default cr4_fixed1
value enumerated for nested VMX.  In that case, checking for (lack of)
host support is actually a bug fix of sorts, as enumerating UMIP support
based solely on descriptor table existing works only because KVM doesn't
sanity check MSR_IA32_VMX_CR4_FIXED1.  E.g. if a (very theoretical) host
supported UMIP in hardware but didn't allow UMIP+VMX, KVM would advertise
UMIP but not actually emulate UMIP.  Of course, KVM would explode long
before it could run a nested VM on said theoretical CPU, as KVM doesn't
modify host CR4 when enabling VMX.

Reported-by: Robert Hoo <robert.hu@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/capabilities.h | 4 ++--
 arch/x86/kvm/vmx/nested.c       | 3 +--
 arch/x86/kvm/vmx/vmx.c          | 2 +-
 3 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
index 45162c1bcd8f..d0abee35d7ba 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -152,8 +152,8 @@ static inline bool cpu_has_vmx_ept(void)
 
 static inline bool vmx_umip_emulated(void)
 {
-	return vmcs_config.cpu_based_2nd_exec_ctrl &
-		SECONDARY_EXEC_DESC;
+	return !boot_cpu_has(X86_FEATURE_UMIP) &&
+	       (vmcs_config.cpu_based_2nd_exec_ctrl & SECONDARY_EXEC_DESC);
 }
 
 static inline bool cpu_has_vmx_rdtscp(void)
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 7c4f5ca405c7..e8347bf2e4fa 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2322,8 +2322,7 @@ static void prepare_vmcs02_early(struct vcpu_vmx *vmx, struct loaded_vmcs *vmcs0
 		 * Preset *DT exiting when emulating UMIP, so that vmx_set_cr4()
 		 * will not have to rewrite the controls just for this bit.
 		 */
-		if (!boot_cpu_has(X86_FEATURE_UMIP) && vmx_umip_emulated() &&
-		    (vmcs12->guest_cr4 & X86_CR4_UMIP))
+		if (vmx_umip_emulated() && (vmcs12->guest_cr4 & X86_CR4_UMIP))
 			exec_control |= SECONDARY_EXEC_DESC;
 
 		if (exec_control & SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 8626010f5d54..c7bd8931eda6 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3467,7 +3467,7 @@ void vmx_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 	else
 		hw_cr4 |= KVM_PMODE_VM_CR4_ALWAYS_ON;
 
-	if (!boot_cpu_has(X86_FEATURE_UMIP) && vmx_umip_emulated()) {
+	if (vmx_umip_emulated()) {
 		if (cr4 & X86_CR4_UMIP) {
 			secondary_exec_controls_setbit(vmx, SECONDARY_EXEC_DESC);
 			hw_cr4 &= ~X86_CR4_UMIP;

base-commit: 0da2a674e56a7fb429eb1f96a3da04d56ec167fd
-- 

